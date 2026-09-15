#pragma once
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"

// td里面include,这里也要include对应的h文件
#include "toy/ToyDialect.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

// 生成所有 Op 的类声明
#define GET_OP_CLASSES
#include "toy/Toy.h.inc"