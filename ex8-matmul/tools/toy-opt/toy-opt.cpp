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
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"

// 转换Pass头文件
// Linalg → Affine 
#include "mlir/Dialect/Linalg/Passes.h"
// Affine优化
#include "mlir/Dialect/Affine/Passes.h"

// Affine 整体降级，生成 SCF + arith + memref，没有先生成SCF再降级到CF的
// tensor --> memref
// SCF → CF 底层控制流
// MemRef → LLVM
// Arith → LLVM
// Func → LLVM
// ControlFlow → LLVM
#include "mlir/Conversion/Passes.h"


// ===== 优化Pass头文件 =====
#include "mlir/Transforms/Passes.h"  // 通用优化：Canonicalizer、CSE
#include "mlir/Dialect/SCF/Transforms/Passes.h"  // SCF 循环优化

// ===== Toy 自定义方言和Pass =====
#include "toy/ToyDialect.h"
#include "toy/ToyPasses.h"

using namespace mlir;
using namespace llvm;

int main(int argc, char **argv) {
    DialectRegistry registry;
    // 注册所有用到的方言（降级链路每一层都必须注册）
    registry.insert<
        toy::ToyDialect,
        func::FuncDialect,
        linalg::LinalgDialect,
        tensor::TensorDialect,
        affine::AffineDialect,  // 新增：注册 Affine 方言
        scf::SCFDialect,
        cf::ControlFlowDialect,
        memref::MemRefDialect,
        arith::ArithDialect,
        LLVM::LLVMDialect
    >();


    // Linalg → Affine   #include "mlir/Dialect/Linalg/Passes.h"
    registerLinalgPasses();
    mlir::affine::registerAffinePasses();
    registerSCFPasses();
    registerCanonicalizer();
    registerCSEPass();
    // 批量注册转换pass
    // registerConversionPasses();
    // tensor --> memref
    registerConvertBufferizationToMemRef();
    // Affine 整体降级，生成 SCF + arith + memref，没有先生成SCF再降级到CF的  #include "mlir/Conversion/Passes.h"
    registerConvertAffineToStandard();
    // SCF → CF 底层控制流  #include "mlir/Conversion/Passes.h"
    registerSCFToControlFlow();
    // memref --> LLVM  #include "mlir/Conversion/Passes.h"
    registerFinalizeMemRefToLLVMConversionPass();
    // arith --> LLVM  #include "mlir/Conversion/Passes.h"
    registerArithToLLVMConversionPass();
    // Func → LLVM  #include "mlir/Conversion/Passes.h"
    registerConvertFuncToLLVMPass();
    // ControlFlow → LLVM #include "mlir/Conversion/Passes.h"
    registerConvertControlFlowToLLVMPass();

    // registerTransformsPasses();


    // 自定义 Toy Pass
    toy::registerPasses();

    return asMainReturnCode(MlirOptMain(argc, argv, "toy-opt", registry));
}
