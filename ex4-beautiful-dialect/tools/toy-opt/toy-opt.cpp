#include "mlir/IR/DialectRegistry.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
// 导入Function dialect
#include "mlir/Dialect/Func/IR/FuncOps.h"
// 导入MLIR自带的Pass
#include "mlir/Transforms/Passes.h"
// 导入Toy dialect
#include "toy/ToyDialect.h"


using namespace mlir;
using namespace llvm;

int main(int argc,char **argv){
    DialectRegistry registry;
    // 注册dialect,// 注册Function dialect
    registry.insert<toy::ToyDialect,func::FuncDialect>();
    
    registerCSEPass();
    registerCanonicalizerPass();
    return asMainReturnCode(MlirOptMain(argc,argv,"toy-opt",registry));
}
