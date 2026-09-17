# 生成方言框架代码
set(LLVM_TARGET_DEFINITIONS ToyDialect.td)
mlir_tablegen(ToyDialect.h.inc -gen-dialect-decls)
mlir_tablegen(ToyDialect.cpp.inc -gen-dialect-defs)

# 生成操作符代码
set(LLVM_TARGET_DEFINITIONS ToyOps.td)
mlir_tablegen(ToyOps.h.inc -gen-op-decls)
mlir_tablegen(ToyOps.cpp.inc -gen-op-defs)

# 公开聚合目标
add_public_tablegen_target(MLIRToyIncGen)

# 编译方言静态库
add_mlir_dialect_library(MLIRToyDialect
  toy.cpp
  DEPENDS
  MLIRToyIncGen
)

# 将 TableGen 生成文件的目录加入库的公开头文件搜索路径
target_include_directories(MLIRToyDialect
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

