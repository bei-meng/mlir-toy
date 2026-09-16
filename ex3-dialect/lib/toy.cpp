#include "toy/ToyDialect.h"
#include "toy/ToyOps.h"
#include "toy/ToyDialect.cpp.inc"
// 生成所有 Op 的类实现触发宏
#define GET_OP_CLASSES
#include "toy/Toy.cpp.inc"

using namespace toy;
void ToyDialect::initialize(){
    addOperations<
    #define GET_OP_LIST
    #include "toy/Toy.cpp.inc"
    >();
}

mlir::LogicalResult SubOp::verify(){
    if(getLhs().getType()!=getRhs().getType()){
        return this->emitOpError()<<"Lhs Type" << getLhs().getType() 
        << "is not equal to Rhs Type" << getRhs().getType();
    }
    return mlir::success();
}