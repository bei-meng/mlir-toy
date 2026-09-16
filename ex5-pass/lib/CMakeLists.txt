# 方言本体：被其他模块依赖，必须先构建
add_subdirectory(Dialect/Toy)
# 变换 Pass：依赖方言本体
add_subdirectory(Transforms/ToyPasses)
