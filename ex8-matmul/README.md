### type定义
- 创建ToyTypes.td文件，定义对应的Type
- 创建ToyTypes.h文件，加入由ToyTypes.td生成的ToyTypes的定义
- 在ToyDialect.td文件中加入对应的标记，和registerTypes函数说明
- 在Toy.cpp中实现registerTypes函数

- 可能的问题
1. 自定义 Dialect 中，Trait 是什么？Pure Trait 为什么能让 CSE/DCE 自动生效？
2. DCE Pass 的实现思路是什么？为什么要从返回节点反向遍历？MLIR 中修改 IR 要注意什么问题？
3. Pattern Rewrite 和普通 Pass 有什么区别？ConversionPattern 和 RewritePattern 的差异是什么？
4. 为什么要多级降级？不直接从 Linalg 一步降到 LLVM？每一层的优化优势是什么？
5. Linalg 算子的 ins/outs 设计有什么好处？和普通的函数返回值有什么区别？



### 三、完整分步测试流程（严格对应你的分层）

每一步基于上一步输出，生成单独文件，方便逐层对比变换效果。

#### 第 1 步：Linalg 层算子级优化

**对应环节**：算子融合、算子泛化、布局规范化
**执行命令**：

```
./toy-opt \
  --linalg-generalize-named-ops \
  --linalg-fuse-elementwise-ops \
  --linalg-fold-unit-extent-dims \
  --canonicalize \
  --cse \
  step0_input.mlir > step1_linalg_optimized.mlir
```

**观察重点**：

- 3 个独立 Linalg 算子融合为 1 个带内部计算体的通用算子；
- 冗余的 `linalg.fill` 初始化被消除；
- 算子接口统一为泛化形式，为后续降级做准备。

---
### 阶段 2：Bufferize —— Tensor 转 MemRef（值语义→引用语义）

**核心目标**：把高层的张量值语义转换为底层的内存引用语义，引入实际的内存分配和访问。
**Pass 顺序与作用**：

1. `--linalg-bufferize`：Linalg 算子专属 Bufferize，把张量操作转成内存缓冲区操作
2. `--convert-bufferization-to-memref`：把 Bufferization 方言的临时操作完全转换为标准 MemRef 方言
3. `--canonicalize` + `--cse`：清理冗余的内存操作、常量折叠
#### 第 2 步：Linalg → Affine 降级

**对应环节**：高层算子展开为仿射循环
**执行命令**：

```
./toy-opt \
  --convert-linalg-to-affine-loops \
  --affine-loop-normalize \
  --canonicalize \
  step1_linalg_optimized.mlir > step2_to_affine.mlir
```

**观察重点**：

- Linalg 算子消失，替换为 **三层嵌套 `affine.for` 循环**（i、j、k 三个维度）；
- 内存访问变为 `affine.load` / `affine.store`，索引为仿射表达式；
- 计算体拆解为 `arith.mulf` / `arith.addf` / `arith.maxf` 标量运算。

---

#### 第 3 步：Affine 层循环级优化

**对应环节**：循环分块、融合、展开、不变量外提、标量替换
**执行命令**（中等优化强度，可调整参数）：

```
./toy-opt \
  --affine-loop-invariant-code-motion \
  --affine-loop-fusion="mode=greedy" \
  --affine-loop-tile="tile-sizes=4,4,4" \
  --affine-loop-unroll="unroll-factor=4" \
  --affine-scalrep \
  --canonicalize \
  --cse \
  step2_to_affine.mlir > step3_affine_optimized.mlir
```

**观察重点**：

- 三层循环被拆分为「外层块循环 + 内层块内循环」的 6 重分块结构；
- 内层循环被展开 4 倍，循环分支开销降低；
- 循环不变的加载、计算被外提到循环外；
- 冗余的内存访问被标量替换消除。

> 
> 可选向量化升级：加上 `--affine-super-vectorize="virtual-vector-size=4"` 可以生成 SIMD 向量运算。

---

#### 第 4 步：Affine → SCF 降级

**对应环节**：仿射循环降级为结构化控制流
**执行命令**：

```
./toy-opt \
  --lower-affine \
  --canonicalize \
  step3_affine_optimized.mlir > step4_to_scf.mlir
```

**观察重点**：

- `affine.for` 全部变为 `scf.for`，循环索引变为标准 `index` 类型；
- 仿射索引表达式被展开为普通整数运算；
- 保留完整的分块循环嵌套结构。

---

#### 第 5 步：SCF 层控制流优化

**对应环节**：循环规范化、剥离、死代码消除、分支消除
**执行命令**：

```
./toy-opt \
  --scf-for-loop-canonicalization \
  --scf-for-loop-peeling \
  --scf-for-loop-range-folding \
  --canonicalize \
  --cse \
  step4_to_scf.mlir > step5_scf_optimized.mlir
```

**观察重点**：

- 循环统一为「从 0 开始、步长为 1」的标准格式；
- 循环首尾边界迭代被拆出循环体，循环内部无分支；
- 冗余计算、不可达代码被清理。

---

#### 第 6 步：SCF → CF 降级

**对应环节**：结构化控制流降级为底层 CFG
**执行命令**：

```
./toy-opt \
  --convert-scf-to-cf \
  --canonicalize \
  step5_scf_optimized.mlir > step6_to_cf.mlir
```

**观察重点**：

- 所有 `scf.for` / `scf.if` 结构化指令消失；
- 代码变为带标签的基本块 + 分支跳转的控制流图形式；
- 逻辑与汇编语言完全对齐，结构化语义全部丢失。

---

#### 第 7 步：CF → LLVM IR 最终降级

**对应环节**：生成标准 LLVM IR，对接机器码生成
**执行命令**：

```
./toy-opt \
  --finalize-memref-to-llvm \
  --convert-arith-to-llvm \
  --convert-func-to-llvm \
  --convert-cf-to-llvm \
  --canonicalize \
  step6_to_cf.mlir > step7_to_llvm.mlir
```

**观察重点**：

- 所有 MLIR 自定义方言消失，全部变为 `llvm.` 前缀指令；
- 函数变为 LLVM 标准签名，内存变为 LLVM 指针操作；
- 输出为标准 LLVM IR，可直接用 `llc` 编译生成目标平台机器码。

---

### 四、一键全流程管道命令

不需要分步观察的话，可以直接拼成一条命令跑完整个优化降级流水线：

```
./toy-opt \
  --linalg-generalize-named-ops \
  --linalg-fuse-elementwise-ops \
  --linalg-fold-unit-extent-dims \
  --convert-linalg-to-affine-loops \
  --affine-loop-normalize \
  --affine-loop-invariant-code-motion \
  --affine-loop-fusion="mode=greedy" \
  --affine-loop-tile="tile-sizes=4,4,4" \
  --affine-loop-unroll="unroll-factor=4" \
  --affine-scalrep \
  --lower-affine \
  --scf-for-loop-canonicalization \
  --scf-for-loop-peeling \
  --scf-for-loop-range-folding \
  --convert-scf-to-cf \
  --finalize-memref-to-llvm \
  --convert-arith-to-llvm \
  --convert-func-to-llvm \
  --convert-cf-to-llvm \
  --canonicalize \
  --cse \
  step0_input.mlir -o output.ll
```

---

### 五、补充说明

1. **优化强度可调**：可以通过修改 `tile-sizes`（分块大小）、`unroll-factor`（展开因子）、是否开启向量化来调整优化强度，适配不同场景。
2. **调试辅助**：加上 `--mlir-print-ir-after-all` 参数可以打印每个 Pass 执行后的 IR，方便定位每一步的变换效果。
3. **并行版本**：如果想测试并行化，可以把 `--convert-linalg-to-affine-loops` 换成 `--convert-linalg-to-parallel-loops`，配合 SCF 层并行优化使用。

今天 11:39