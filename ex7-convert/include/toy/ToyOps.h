#pragma once
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
// 必须在 .h.inc 之前包含
#include "mlir/IR/OpDefinition.h"          // mlir::Op 基类
#include "mlir/Interfaces/CallInterfaces.h" // CallOpInterface、CallInterfaceCallable
#include "mlir/Interfaces/FunctionInterfaces.h" // FunctionOpInterface
#include "mlir/Interfaces/InferTypeOpInterface.h" // InferTypeOpInterface
#include "mlir/Interfaces/ControlFlowInterfaces.h" // RegionBranchTerminatorOpInterface
#include "mlir/Interfaces/SideEffectInterfaces.h" // MemoryEffectOpInterface


// td里面include,这里也要include对应的h文件
#include "ToyDialect.h"       // 1. 先包含方言核心头文件（同目录下直接写文件名）
#include "ToyTypes.h"  // ✅ 必须在 ToyOps.h.inc 之前
#define GET_OP_CLASSES       // 2. 控制宏：告诉.inc文件输出所有Op的完整类声明
#include "ToyOps.h.inc"     // 3. TableGen生成的Op声明文件（构建目录下，通过搜索路径找到）
