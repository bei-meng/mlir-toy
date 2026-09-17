#include "mlir/Pass/Pass.h"
#include "toy/ToyOps.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"
#define GEN_PASS_DEF_DCE
#include "toy/ToyPasses.h"

using namespace mlir;
using namespace llvm;
using namespace toy;

struct DCEPass : toy::impl::DCEBase<DCEPass>{
    void visitAll(llvm::DenseSet<Operation*> &visited, Operation *op){
        if(visited.contains(op)){
            return ;
        }
        visited.insert(op);
        for(auto operand:op->getOperands()){
            // 在调用 value->getDefiningOp() 的时候，BlockArgument 会返回 null
            if(auto def = operand.getDefiningOp()){
                visitAll(visited,def);
            }
        }
    }
    // 核心入口
    /*
        // 递归遍历所有儿子
        func.walk([](Operation * child) {
        // do something
        });
        // 递归遍历所有是 `ReturnOp` 类型的儿子
        func.walk([](ReturnOp ret) {
        // do something
        })
    */
    void runOnOperation() final{
        llvm::DenseSet<Operation*> visited;
        // 便利所以Return ，把return 可达的加入visited集合
        getOperation()->walk([&](toy::ReturnOp op){
            visitAll(visited,op);
        });
        llvm::SmallVector<Operation*> opToRemove;
        // 将不可达的加入到opToRemove集合
        getOperation().walk([&](Operation * op) {
            if(op == getOperation()) return;
            if(!visited.contains(op)) opToRemove.push_back(op);
        });
        // 反向erase
        for(auto v:reverse(opToRemove)){
            v->erase();
        }
    }
};
// **CRTP（奇异递归模板模式）**：把自身作为模板参数传给基类
// struct ConvertToyToArithPass : toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>{
std::unique_ptr<mlir::Pass> toy::createDCEPass() {
  return std::make_unique<DCEPass>();
}
