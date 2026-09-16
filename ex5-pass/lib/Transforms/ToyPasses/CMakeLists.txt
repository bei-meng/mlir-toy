# 生成 Pass 声明代码
set(LLVM_TARGET_DEFINITIONS ToyPasses.td)
mlir_tablegen(ToyPasses.h.inc -gen-pass-decls)

# Pass 模块公开聚合目标
add_public_tablegen_target(MLIRToyTransformsIncGen)

# 编译变换静态库
add_mlir_library(MLIRToyTransforms
  ConvertToyToArith.cpp
  DCE.cpp
  DEPENDS
  MLIRToyIncGen
  MLIRToyTransformsIncGen
  LINK_LIBS PUBLIC
  MLIRToyDialect
)

target_include_directories(MLIRToyTransforms
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

