# 阶段1：Linalg Tensor层算子优化
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --linalg-fold-unit-extent-dims \
  --linalg-fuse-elementwise-ops \
  --linalg-generalize-named-ops \
  --canonicalize \
  --cse \
  step0.mlir > step1_linalg_opt.mlir

# 阶段3：降级到Affine仿射循环
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --convert-linalg-to-affine-loops \
  --affine-loop-normalize \
  --canonicalize \
  step1_linalg_opt.mlir > step3_to_affine.mlir

# 阶段4：Affine层循环优化（含循环融合）
# 循环规范化（所有优化的前提）
# 统一循环边界格式、消除非规范的循环上下界，把所有循环规整成标准形式，为后续所有循环优化做准备
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --affine-loop-normalize \
  --canonicalize \
  --cse \
  step3_to_affine.mlir > step4_1_normalize.mlir

# 循环不变量外提（LICM）
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --affine-loop-invariant-code-motion \
  --canonicalize \
  --cse \
  step4_1_normalize.mlir > step4_2_licm.mlir

# 循环融合（消除中间内存读写）
# 识别「生产者循环 → 消费者循环」的依赖链，把相邻的多层循环合并成一层，
# 消除中间结果的写回 - 重读开销。这就是对应你场景中 `matmul + add + max` 
# 融合的关键步骤。
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --affine-loop-fusion="mode=greedy" \
  --canonicalize \
  --cse \
  step4_2_licm.mlir > step4_3_fusion.mlir

# 循环分块（优化缓存局部性）
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --affine-loop-tile="tile-sizes=4,4,4" \
  --canonicalize \
  --cse \
  step4_3_fusion.mlir > step4_4_tile.mlir

# 循环展开（减少分支开销）
# 把最内层循环的循环体复制多份，减少循环迭代的分支判断和索引计算开销，增加指令级并行
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --affine-loop-unroll="unroll-factor=4" \
  --canonicalize \
  --cse \
  step4_4_tile.mlir > step4_5_unroll.mlir

# 标量替换（消除冗余内存访问）
# 转发存储到加载的值，用寄存器标量替代重复的内存访问，消除冗余的 `affine.load` 和 `affine.store`
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --affine-scalrep \
  --canonicalize \
  --cse \
  step4_5_unroll.mlir > step4_affine_opt.mlir


# 阶段5：降级到SCF结构化循环
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --lower-affine \
  --scf-for-loop-canonicalization \
  --scf-for-loop-peeling \
  --scf-for-loop-range-folding \
  --canonicalize \
  --cse \
  step4_affine_opt.mlir > step5_scf_opt.mlir

# 阶段6：降级到CF底层控制流
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --convert-scf-to-cf \
  --canonicalize="region-simplify=true" \
  --cse \
  step5_scf_opt.mlir > step6_to_cf.mlir

# 阶段7：最终降级到LLVM IR
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
  --finalize-memref-to-llvm \
  --convert-arith-to-llvm \
  --convert-func-to-llvm \
  --convert-cf-to-llvm \
  --canonicalize \
  step6_to_cf.mlir > step7_final_llvm.ll
