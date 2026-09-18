add_mlir_tool(toy-opt
  toy-opt.cpp
)

target_link_libraries(toy-opt PRIVATE
  # 你已有的 Toy 相关库
  MLIRToyDialect
  MLIRToyTransforms

  # ===== 方言库 =====
  MLIRFuncDialect
  MLIRLinalgDialect
  MLIRLLVMDialect
  MLIRAffineDialect
  MLIRSCFDialect
  MLIRControlFlowDialect
  MLIRMemRefDialect
  MLIRArithDialect

  # ===== 转换 Pass 库（和代码里注册的一一对应）=====
  MLIRLinalgTransforms       # Linalg→Affine
  MLIRAffineTransforms
  MLIRAffineToStandard       # Affine→SCF+Arith
  MLIRSCFToControlFlow       # SCF→CF
  MLIRMemRefToLLVM           # MemRef→LLVM
  MLIRArithToLLVM            # Arith→LLVM
  MLIRFuncToLLVM             # Func→LLVM
  MLIRControlFlowToLLVM      # CF→LLVM
  MLIRBufferizationToMemRef
  # ===== 优化 Pass 库 =====
  MLIRTransforms             # 通用优化：Canonicalize、CSE
  MLIRSCFTransforms          # SCF 优化：LICM

  # ===== MLIR 基础框架库（你已有的保留）=====
  MLIRSupport
  MLIRIR
  MLIRParser
  MLIROptLib
)
