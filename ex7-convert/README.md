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