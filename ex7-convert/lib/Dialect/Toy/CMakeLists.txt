# 1. 生成方言框架代码
set(LLVM_TARGET_DEFINITIONS ToyDialect.td)
mlir_tablegen(ToyDialect.h.inc -gen-dialect-decls)
mlir_tablegen(ToyDialect.cpp.inc -gen-dialect-defs)
add_public_tablegen_target(MLIRToyDialectIncGen)

# 2. 生成操作符代码
set(LLVM_TARGET_DEFINITIONS ToyOps.td)
mlir_tablegen(ToyOps.h.inc -gen-op-decls)
mlir_tablegen(ToyOps.cpp.inc -gen-op-defs)
add_public_tablegen_target(MLIRToyOpsIncGen)

# 3. 生成自定义类型代码
set(LLVM_TARGET_DEFINITIONS ToyTypes.td)
mlir_tablegen(ToyTypes.h.inc -gen-typedef-decls)
mlir_tablegen(ToyTypes.cpp.inc -gen-typedef-defs)
add_public_tablegen_target(MLIRToyTypesIncGen)

# 4. 编译方言静态库
add_mlir_dialect_library(MLIRToyDialect
    toy.cpp
    DEPENDS
    MLIRToyDialectIncGen
    MLIRToyOpsIncGen
    MLIRToyTypesIncGen
)

# 5. 将生成文件目录加入公开头文件搜索路径
target_include_directories(MLIRToyDialect
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)
