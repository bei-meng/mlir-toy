#include "mlir/IR/BuiltinDialect.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/ValueRange.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
// #include "mlir/Conversion/ArithToLLVM/ArithToLLVM.h"
// #include "mlir/Conversion/LLVMCommon/TypeConverter.h"
// #include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"
#include <utility>
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include "mlir/Transforms/DialectConversion.h"


#include "toy/ToyDialect.h"
#include "toy/ToyOps.h"
#define GEN_PASS_DEF_CONVERTTOYTOARITH
#include "toy/ToyPasses.h"

// 描述pattern
struct AddOpPat:mlir::OpRewritePattern<toy::AddOp>{
  // 使用父类的构造函数
  using mlir::OpRewritePattern<toy::AddOp>::OpRewritePattern;
  mlir::LogicalResult matchAndRewrite(toy::AddOp op,mlir::PatternRewriter &rewriter)const override{
    auto inputs  = llvm::to_vector(op.getInputs());
    auto result = inputs[0];
    // 这是降级的核心逻辑：**把 N 元加法拆成 N-1 个二元加法**
    for(size_t i=1;i<inputs.size();++i){
      result = rewriter.create<mlir::arith::AddIOp>(op.getLoc(),result,inputs[i]);
    }
    rewriter.replaceOp(op,mlir::ValueRange(result));
    return mlir::success();
  }
};

struct SubOpPat:mlir::OpRewritePattern<toy::SubOp>{
  using mlir::OpRewritePattern<toy::SubOp>::OpRewritePattern;
  mlir::LogicalResult matchAndRewrite(toy::SubOp op,mlir::PatternRewriter &rewriter)const override{
    rewriter.replaceOpWithNewOp<mlir::arith::SubIOp>(op, op.getLhs(),op.getRhs());
    return mlir::success();
  }
};

struct ConstOpPat:mlir::OpRewritePattern<toy::ConstantOp>{
  using mlir::OpRewritePattern<toy::ConstantOp>::OpRewritePattern;
  mlir::LogicalResult matchAndRewrite(toy::ConstantOp op,mlir::PatternRewriter &rewriter)const override{
    rewriter.replaceOpWithNewOp<mlir::arith::ConstantOp>(op, op.getValueAttr());
    return mlir::success();
  }
};



/*不带参数版本
// **CRTP（奇异递归模板模式）**：把自身作为模板参数传给基类
struct ConvertToyToArithPass : toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>{
  // 使用父类的构造函数-这行是 C++ 的「继承构造函数」语法，**显式把基类的构造函数导入到子类中**
  using toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>::ConvertToyToArithBase;
  void runOnOperation() final {
    getOperation()->print(llvm::errs());
  }
};

// 这是公共头文件中声明的工厂函数的**具体实现**，是对外暴露的 Pass 创建接口
std::unique_ptr<mlir::Pass> toy::createConvertToyToArithPass() {
  return std::make_unique<ConvertToyToArithPass>();
}
*/

// **CRTP（奇异递归模板模式）**：把自身作为模板参数传给基类
struct ConvertToyToArithPass : toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>{
  // 使用父类的构造函数
  using toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>::ConvertToyToArithBase;
  void getDependentDialects(mlir::DialectRegistry &registry)const final{
    registry.insert<mlir::arith::ArithDialect>();
  }
  
  void runOnOperation() final {
    // llvm::errs() << "get name: " << name << "\n";
    mlir::ConversionTarget target(getContext());
    target.addLegalDialect<mlir::arith::ArithDialect>();
    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<AddOpPat,SubOpPat,ConstOpPat>(&getContext());
    if(mlir::failed(mlir::applyPartialConversion(getOperation(),target,std::move(patterns)))){
      signalPassFailure();
    }
  }
};

std::unique_ptr<mlir::Pass> toy::createConvertToyToArithPass(ConvertToyToArithOptions options) {
  return std::make_unique<ConvertToyToArithPass>(options);
}