include "mlir/Pass/PassBase.td"

def ConvertToyToArith : Pass<"convert-toy-to-arith"> {
    let summary = "Convert Toy To Arith";
    // 先在td文件声明有这么一个pass，然后再在.h文件中声明createConvertToyToArithPass函数，最后在cpp文件中实现对应的
    let constructor = "toy::createConvertToyToArithPass()";
    let options = [
      // 代码里的名字 命令行的名字 类型    默认值   帮助
      Option<"name", "name", "std::string", "", "help">
    ];
}

// 指定 Pass 在哪个 Op 上运行,toy-dce这个就是执行时用的名字
def DCE : Pass<"toy-dce","toy::FuncOp"> {
    let summary = "Toy DCE";
    let constructor = "toy::createDCEPass()";
}