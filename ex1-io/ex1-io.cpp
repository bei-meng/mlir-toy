#include "mlir/IR/AsmState.h"        // IR 文本打印/格式化输出的辅助能力
#include "mlir/IR/BuiltinOps.h"       // 内置算子，比如最顶层的 ModuleOp
#include "mlir/IR/MLIRContext.h"      // MLIR 核心上下文（所有IR的运行环境）
#include "mlir/Parser/Parser.h"       // MLIR 文本解析器
#include "mlir/Support/FileUtilities.h" // 文件读取工具
#include "mlir/Dialect/Func/IR/FuncOps.h"  // func 方言（函数定义/调用）
#include "mlir/Dialect/Arith/IR/Arith.h"  // arith 方言（算术运算）
#include "llvm/Support/raw_ostream.h" // LLVM 标准输出流

using namespace mlir;

int main(int argc, char **argv){
    MLIRContext context;
    // 首先注册dialect
    context.loadDialect<func::FuncDialect,arith::ArithDialect>();
    // 读入文件
    auto src = parseSourceFile<ModuleOp>(argv[1], &context);
    // 输出
    src->print(llvm::outs());
    // 简单输出
    src->dump();
    return 0;
}