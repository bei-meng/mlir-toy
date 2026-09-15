ex3-dialect
├── CMakeLists.txt           # 控制其他各个部分的 CMakeList
├── include
│   └── toy
│       ├── CMakeLists.txt  # 控制 Dialect 定义的 CMakeList
│       ├── ToyDialect.h    # Dialect 头文件
│       ├── ToyDialect.td   # Dialect TableGen 文件
│       ├── ToyOps.h        # Op 头文件
│       ├── ToyOps.td       # Op TableGen 文件
│       └── Toy.td          # 把 ToyDialect.td 和 ToyOps.td include 到一起，用于 tablegen
├── lib
│   ├── CMakeLists.txt
│   └── toy.cpp             # Dialect library
└── tools
    └── toy-opt
        ├── CMakeLists.txt
        └── toy-opt.cpp     # Executable Tool