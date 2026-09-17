### pattern重写步骤
- 在ToyPasses.td中加入对应的pass，如toyToArith的转换pass，补充pass实现函数constructor及options
- 创建对应的ToyPasses.h头文件，头文件中加入对应实现函数的声明createConvertToyToArithPass
- 在ConvertToyToArith.cpp中加入对应的pattern模式匹配和createConvertToyToArithPass实现
- toy-opt.cpp中注册    toy::registerPasses();