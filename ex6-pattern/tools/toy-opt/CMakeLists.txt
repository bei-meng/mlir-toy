add_mlir_tool(toy-opt
  toy-opt.cpp
)

target_link_libraries(toy-opt PRIVATE
  MLIRToyDialect       # Toy 方言库，正确名是 MLIRToyDialect，不是 Toy
  MLIRToyTransforms    # Toy 变换 Pass 库
  MLIRSupport
  MLIRIR
  MLIRParser
  # MLIRTransforms       # 通用变换 Pass，已间接包含 MLIRPass
  # MLIRMlirOptLib       # mlir-opt 框架库，标准名 MLIRMlirOptLib，部分版本别名 MLIROptLib

  MLIROptLib        # 对应 #include "mlir/Tools/mlir-opt/MlirOptMain.h"
  MLIRFuncDialect   # 对应 #include "mlir/Dialect/Func/IR/FuncOps.h"
  MLIRTransforms    # 对应 #include "mlir/Transforms/Passes.h"
)
