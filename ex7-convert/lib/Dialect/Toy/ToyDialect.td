#ifndef TOY_DIALECT_TD
#define TOY_DIALECT_TD

include "mlir/IR/DialectBase.td"
def ToyDialect : Dialect{
    let name = "toy";
    let cppNamespace = "toy";
    let summary = "Toy dialect - by bei meng";
    // let typeDefs = [ToyInteger];
    let useDefaultTypePrinterParser = true; // 新增
    let extraClassDeclaration = [{
        void registerTypes();
    }];
}
#endif


