## 设置LLVM的运行时输出目录为CMake的二进制目录，指cmake ..指令执行时在的目录
# CMAKE_BINARY_DIR是CMake的二进制目录，通常是build目录
# CMAKE_SOURCE_DIR是CMake的源代码目录，通常是项目的根目录，存在一个CMakeLists.txt文件
# CMAKE_CURRENT_BINARY_DIR是当前CMakeLists.txt所在的二进制目录，通常是build/ex3-dialect目录
# CMAKE_CURRENT_SOURCE_DIR是当前CMakeLists.txt所在的源代码目录，通常是ex3-dialect目录

set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR})

# include_directories用于c++找h文件
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/include)

# 构建顺序：先库后工具
add_subdirectory(lib)
add_subdirectory(tools)