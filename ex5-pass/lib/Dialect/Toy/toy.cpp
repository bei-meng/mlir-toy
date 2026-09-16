#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Interfaces/FunctionImplementation.h"
// 下面这个对应td文件里面的SameOperandsAndResultType trait的头文件
#include "mlir/Interfaces/InferTypeOpInterface.h"
// 下面
#include "mlir/Interfaces/ControlFlowInterfaces.h"


#include "toy/ToyDialect.h"
#include "toy/ToyOps.h"



#include "ToyDialect.cpp.inc"
// 生成所有 Op 的类实现触发宏
#define GET_OP_CLASSES
#include "ToyOps.cpp.inc"

using namespace mlir;
using namespace toy;

void ToyDialect::initialize(){
    addOperations<
    #define GET_OP_LIST
    #include "ToyOps.cpp.inc"
    >();
}


mlir::LogicalResult SubOp::verify(){
    if(getLhs().getType()!=getRhs().getType()){
        return this->emitOpError()<<"Lhs Type" << getLhs().getType() 
        << "is not equal to Rhs Type" << getRhs().getType();
    }
    return mlir::success();
}



int64_t ConstantOp::getBitWidth(){
    return getResult().getType().getWidth();
}


// 自动类型推导，与td文件里面的InferTypeOpInterface trait对应
mlir::LogicalResult ConstantOp::inferReturnTypes(
    mlir::MLIRContext * context,
    std::optional<mlir::Location> location,
    Adaptor adaptor,
    llvm::SmallVectorImpl<mlir::Type> & inferedReturnType
){
    inferedReturnType.push_back(adaptor.getValueAttr().getType());
    return mlir::success();
}

mlir::ParseResult FuncOp::parse(::mlir::OpAsmParser &parser, ::mlir::OperationState &result){
    auto buildFuncType = [](auto & builder, auto argTypes, auto results, auto, auto){
        return builder.getFunctionType(argTypes, results);
    };
    return function_interface_impl::parseFunctionOp(
        parser, result, false, 
        getFunctionTypeAttrName(result.name), buildFuncType, 
        getArgAttrsAttrName(result.name), getResAttrsAttrName(result.name)
    );
}

void FuncOp::print(mlir::OpAsmPrinter &p) {
  // Dispatch to the FunctionOpInterface provided utility method that prints the
  // function operation.
  mlir::function_interface_impl::printFunctionOp(
      p, *this, /*isVariadic=*/false, getFunctionTypeAttrName(),
      getArgAttrsAttrName(), getResAttrsAttrName());
}
