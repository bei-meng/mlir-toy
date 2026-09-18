#include "mlir/IR/DialectRegistry.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"

// ===== 方言头文件 =====
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlow.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Arith/IR/Arith.h"

// ===== 转换Pass头文件（全部匹配你搜索到的真实路径） =====
// Linalg → Affine 
#include "mlir/Dialect/Linalg/Passes.h"
/*
inline void registerLinalgPasses() {
  registerConvertElementwiseToLinalg();
  registerLinalgBufferize();
  registerLinalgDetensorize();
  registerLinalgElementwiseOpFusion();
  registerLinalgFoldUnitExtentDims();
  registerLinalgGeneralization();
  registerLinalgInlineScalarOperands();
  registerLinalgLowerToAffineLoops();
  registerLinalgLowerToLoops();
  registerLinalgLowerToParallelLoops();
  registerLinalgNamedOpConversion();
}
*/
// Affine → SCF 循环，在affine里面没有，得去Conversion里面找
#include "mlir/Dialect/Affine/Passes.h"
/*
inline void registerAffinePasses() {
  registerAffineDataCopyGeneration();
  registerAffineExpandIndexOps();
  registerAffineLoopFusion();
  registerAffineLoopInvariantCodeMotion();
  registerAffineLoopNormalize();
  registerAffineLoopTiling();
  registerAffineLoopUnroll();
  registerAffineLoopUnrollAndJam();
  registerAffineParallelize();
  registerAffinePipelineDataTransfer();
  registerAffineScalarReplacement();
  registerAffineVectorize();
  registerLoopCoalescing();
  registerSimplifyAffineStructures();
}
*/
// SCF → CF 底层控制流（已搜索确认存在）
#include "mlir/Dialect/SCF/Transforms/Passes.h"
// MemRef → LLVM（已搜索确认存在）
#include "mlir/Dialect/MemRef/Transforms/Passes.h"


#include "mlir/Conversion/MemRefToLLVM/MemRefToLLVM.h"
// Arith → LLVM（已搜索确认存在）
#include "mlir/Conversion/ArithToLLVM/ArithToLLVM.h"
// Func → LLVM（已搜索确认，新版带Convert前缀）
#include "mlir/Conversion/FuncToLLVM/ConvertFuncToLLVMPass.h"
// ControlFlow → LLVM（已搜索确认存在）
#include "mlir/Conversion/ControlFlowToLLVM/ControlFlowToLLVM.h"

// ===== 优化Pass头文件 =====
#include "mlir/Transforms/Passes.h"  // 通用优化：Canonicalizer、CSE
#include "mlir/Dialect/SCF/Transforms/Passes.h"  // SCF 循环优化

// ===== Toy 自定义方言和Pass =====
#include "toy/ToyDialect.h"
#include "toy/ToyPasses.h"