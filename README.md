# mlir-toy

## 1.编译指令
- 创建build文件夹进行编译
    - cd build
    - rm  -r  * 
    - cmake .. -GNinja 
    - ninja

- 编译指定文件
    - ninja toy-opt


- 执行指令
    - ./toy-opt --convert-toy-to-arith --toy-dce ../ex6-pattern/ex6.mlir
    - ./toy-opt --debug --convert-toy-to-arith ../ex6-pattern/ex6.mlir