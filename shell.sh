# 替换为你实际的 install/include 路径
MLIR_INCLUDE=~/mlir-tutorial/install/include
INC=~/mlir-tutorial/install/include
echo "=== 核对核心头文件 ==="
test -f "$INC/mlir/Tools/mlir-opt/MlirOptMain.h" && echo "✅ MlirOptMain.h" || echo "❌ MlirOptMain.h"
test -f "$INC/mlir/IR/DialectRegistry.h" && echo "✅ DialectRegistry.h" || echo "❌ DialectRegistry.h"
test -f "$INC/mlir/Dialect/Linalg/Transforms/Transforms.h" && echo "✅ Linalg Transforms.h" || echo "❌ Linalg Transforms.h"
test -f "$INC/mlir/Conversion/AffineToSCF/AffineToSCF.h" && echo "✅ AffineToSCF.h" || echo "❌ AffineToSCF.h"
test -f "$INC/mlir/Conversion/SCFToControlFlow/SCFToControlFlow.h" && echo "✅ SCFToControlFlow.h" || echo "❌ SCFToControlFlow.h"
