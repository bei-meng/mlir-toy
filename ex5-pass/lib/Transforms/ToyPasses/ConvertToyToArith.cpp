#include "llvm/Support/raw_ostream.h"

#define GEN_PASS_DEF_CONVERTTOYTOARITH
#include "toy/ToyPasses.h"

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


struct ConvertToyToArithPass : 
    toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>
{
  // 使用父类的构造函数
  using toy::impl::ConvertToyToArithBase<ConvertToyToArithPass>::ConvertToyToArithBase;
  void runOnOperation() final {
    llvm::errs() << "get name: " << name << "\n";
  }
};

std::unique_ptr<mlir::Pass> toy::createConvertToyToArithPass(ConvertToyToArithOptions options) {
  return std::make_unique<ConvertToyToArithPass>(options);
}