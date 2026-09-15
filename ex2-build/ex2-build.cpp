# include "mlir/IR/Builders.h"        // IR 构建器
# include "mlir/IR/AsmState.h"        // IR 文本打印/格式化输出的辅助能力
# include "mlir/IR/BuiltinOps.h"       // 内置算子，比如最顶层的 ModuleOp
# include "mlir/IR/MLIRContext.h"      // MLIR 核心上下文（所有IR的运行环境）
# include "mlir/Parser/Parser.h"       // MLIR 文本解析器
# include "mlir/Support/FileUtilities.h" // 文件读取工具
# include "mlir/Dialect/Func/IR/FuncOps.h"  // func 方言（函数定义/调用）
# include "mlir/Dialect/Arith/IR/Arith.h"  // arith 方言（算术运算）
# include "llvm/Support/raw_ostream.h" // LLVM 标准输出流
#include "mlir/IR/Verifier.h"


using namespace mlir;
int main(int argc,char **argv){
    MLIRContext ctx;
    ctx.loadDialect<func::FuncDialect,arith::ArithDialect>();

    /*
    创建OpBuilder对象，OpBuilder是MLIR中用于构建IR的工具类，
    它提供了创建各种操作（Operation）的方法。通过OpBuilder，
    我们可以方便地在指定的上下文中创建和插入操作，
    从而构建完整的MLIR模块。
    */ 
    OpBuilder builder(&ctx);

    auto mod = builder.create<ModuleOp>(builder.getUnknownLoc());

    // 设置插入点到模块的末尾
    builder.setInsertionPointToEnd(mod.getBody());

    // 创建一个函数，函数名为"test"，参数类型为两个i32，返回类型为一个i32
    auto i32 = builder.getI32Type();
    auto funcType = builder.getFunctionType({i32,i32},{i32});
    auto func = builder.create<func::FuncOp>(builder.getUnknownLoc(),"test",funcType);

    // 添加一个基本块
    auto entry = func.addEntryBlock();
    auto args = entry->getArguments();

    // 设置插入点到基本块的末尾
    builder.setInsertionPointToEnd(entry);

    auto addi = builder.create<arith::AddIOp>(builder.getUnknownLoc(),args[0],args[1]);

    builder.create<func::ReturnOp>(builder.getUnknownLoc(),ValueRange({addi}));


    if (failed(verify(mod.getOperation()))) {

        llvm::errs() << "错误：构建的 IR 不合法\n";
        return 1;
    }

    mod->print(llvm::outs());
    return 0;
}