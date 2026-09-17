#include "mlir/IR/BuiltinDialect.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/ValueRange.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
// #include "mlir/Conversion/ArithToLLVM/ArithToLLVM.h"
// #include "mlir/Conversion/LLVMCommon/TypeConverter.h"
// #include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"
#include <cassert>
#include <cstddef>
#include <utility>
#include "mlir/Support/TypeID.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include "mlir/Transforms/DialectConversion.h"


#include "toy/ToyDialect.h"
#include "toy/ToyOps.h"
#include "toy/ToyTypes.h"
#define GEN_PASS_DEF_CONVERTTOYTOARITH
#include "toy/ToyPasses.h"

// 在原有 GET_OP_DEFS 附近加上
#define GET_TYPEDEF_DEFS
#include "ToyTypes.cpp.inc"


using namespace mlir;
using namespace llvm;
using namespace toy;

// 描述pattern
// `OpConversionPattern` 本质是 `OpRewritePattern` 的特化子类，
// 专门为「跨方言降级 + 类型转换」场景做了扩展。
struct AddOpPat:mlir::OpConversionPattern<toy::AddOp>{
  using mlir::OpConversionPattern<toy::AddOp>::OpConversionPattern;
  mlir::LogicalResult matchAndRewrite(toy::AddOp op,toy::AddOpAdaptor adaptor,
    mlir::ConversionPatternRewriter &rewriter)const override{
    auto inputs = llvm::to_vector(adaptor.getInputs());
    auto result = inputs[0];
    for(size_t i = 1;i<inputs.size();++i){
      assert(inputs[i]);
      result = rewriter.create<mlir::arith::AddIOp>(op->getLoc(),result,inputs[i]);
    }
    rewriter.replaceOp(op,mlir::ValueRange(result));
    return mlir::success();
  }
};
// struct AddOpPat:mlir::OpRewritePattern<toy::AddOp>{
//   // 使用父类的构造函数
//   using mlir::OpRewritePattern<toy::AddOp>::OpRewritePattern;
//   mlir::LogicalResult matchAndRewrite(toy::AddOp op,mlir::PatternRewriter &rewriter)const override{
//     auto inputs  = llvm::to_vector(op.getInputs());
//     auto result = inputs[0];
//     // 这是降级的核心逻辑：**把 N 元加法拆成 N-1 个二元加法**
//     for(size_t i=1;i<inputs.size();++i){
//       result = rewriter.create<mlir::arith::AddIOp>(op.getLoc(),result,inputs[i]);
//     }
//     rewriter.replaceOp(op,mlir::ValueRange(result));
//     return mlir::success();
//   }
// };

struct SubOpPat:mlir::OpConversionPattern<toy::SubOp>{
  using mlir::OpConversionPattern<toy::SubOp>::OpConversionPattern;
  mlir::LogicalResult matchAndRewrite(toy::SubOp op,toy::SubOpAdaptor adaptor,
    mlir::ConversionPatternRewriter &rewriter)const override{
    rewriter.replaceOpWithNewOp<mlir::arith::SubIOp>(op, adaptor.getLhs(),adaptor.getRhs());
    return mlir::success();
  }
};

// struct SubOpPat:mlir::OpRewritePattern<toy::SubOp>{
//   using mlir::OpRewritePattern<toy::SubOp>::OpRewritePattern;
//   mlir::LogicalResult matchAndRewrite(toy::SubOp op,mlir::PatternRewriter &rewriter)const override{
//     rewriter.replaceOpWithNewOp<mlir::arith::SubIOp>(op, op.getLhs(),op.getRhs());
//     return mlir::success();
//   }
// };


struct ConstantOpPat: mlir::OpConversionPattern<toy::ConstantOp> {
  using mlir::OpConversionPattern<toy::ConstantOp>::OpConversionPattern;
  mlir::LogicalResult matchAndRewrite(toy::ConstantOp op,toy::ConstantOpAdaptor adaptor, mlir::ConversionPatternRewriter & rewriter) const override{
    rewriter.replaceOpWithNewOp<mlir::arith::ConstantOp>(op, op.getValueAttr());
    return mlir::success();
  }
};

// struct ConstOpPat:mlir::OpRewritePattern<toy::ConstantOp>{
//   using mlir::OpRewritePattern<toy::ConstantOp>::OpRewritePattern;
//   mlir::LogicalResult matchAndRewrite(toy::ConstantOp op,mlir::PatternRewriter &rewriter)const override{
//     rewriter.replaceOpWithNewOp<mlir::arith::ConstantOp>(op, op.getValueAttr());
//     return mlir::success();
//   }
// };


struct ReturnOpPat:mlir::OpConversionPattern<toy::ReturnOp>{
  using mlir::OpConversionPattern<toy::ReturnOp>::OpConversionPattern;
  mlir::LogicalResult matchAndRewrite(toy::ReturnOp op,toy::ReturnOpAdaptor adaptor,mlir::ConversionPatternRewriter &rewriter) const override{
    auto data = adaptor.getData();
    rewriter.startRootUpdate(op);
    op.getDataMutable().assign(data);
    rewriter.finalizeRootUpdate(op);
    return mlir::success();
  }
};

struct CallOpPat: OpConversionPattern<CallOp> {
  using OpConversionPattern<CallOp>::OpConversionPattern;
  LogicalResult matchAndRewrite(CallOp op, CallOpAdaptor adaptor, ConversionPatternRewriter & rewriter) const override{
    SmallVector<Type> resTypes;
    assert(succeeded(getTypeConverter()->convertTypes(op->getResultTypes(), resTypes)));
    rewriter.replaceOpWithNewOp<CallOp>(op, resTypes, op.getCallee(), adaptor.getOperands());
    return success();
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
// struct ConvertToyToArithPass : toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>{
//   // 使用父类的构造函数
//   using toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>::ConvertToyToArithBase;
//   void getDependentDialects(mlir::DialectRegistry &registry)const final{
//     registry.insert<mlir::arith::ArithDialect>();
//   }
  
//   void runOnOperation() final {
//     // llvm::errs() << "get name: " << name << "\n";
//     mlir::ConversionTarget target(getContext());
//     target.addLegalDialect<mlir::arith::ArithDialect>();
//     mlir::RewritePatternSet patterns(&getContext());
//     patterns.add<AddOpPat,SubOpPat,ConstOpPat>(&getContext());
//     if(mlir::failed(mlir::applyPartialConversion(getOperation(),target,std::move(patterns)))){
//       signalPassFailure();
//     }
//   }
// };

struct ConvertToyToArithPass : toy::impl::ConvertToyToArithBase<ConvertToyToArithPass> {
  using toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>::ConvertToyToArithBase;
  void getDependentDialects(DialectRegistry &registry) const final {
    registry.insert<arith::ArithDialect>();
  }

  void runOnOperation()final{
    ConversionTarget target(getContext());
    target.addLegalDialect<arith::ArithDialect>();
    target.addDynamicallyLegalOp<FuncOp>([](FuncOp f) {
      return llvm::all_of(f.getArgumentTypes(), [](Type t) {return !isa<ToyIntegerType>(t);});
    });
    auto checkValid = [](Operation *f){
      return llvm::all_of(f->getOperandTypes(),[](Type t){return !isa<ToyIntegerType>(t); });
    };

    target.addDynamicallyLegalOp<ReturnOp, CallOp>(checkValid);
    TypeConverter converter;
    // 模板元编程的方法
    converter.addConversion([&](ToyIntegerType t) -> std::optional<IntegerType> {
      return IntegerType::get(&getContext(), t.getWidth());
    });
    // 物化桥接
    converter.addTargetMaterialization([](OpBuilder& builder, Type resultType, ValueRange inputs, Location loc) -> std::optional<Value> {
      return builder.create<UnrealizedConversionCastOp>(loc, resultType, inputs).getResult(0);
    });
    RewritePatternSet patterns(&getContext());
    patterns.add<AddOpPat, SubOpPat, ConstantOpPat, ReturnOpPat, CallOpPat>(converter, &getContext());
    populateFunctionOpInterfaceTypeConversionPattern<FuncOp>(patterns, converter);
    if(failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
      signalPassFailure();
  }

};

std::unique_ptr<mlir::Pass> toy::createConvertToyToArithPass(ConvertToyToArithOptions options) {
  return std::make_unique<ConvertToyToArithPass>(options);
}