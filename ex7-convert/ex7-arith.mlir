module {
  toy.func @add(%arg0: i32, %arg1: i32) -> i32 {
    %0 = arith.addi %arg0, %arg1 : i32
    toy.ret %0 : i32
  }
  toy.func @test(%arg0: i32, %arg1: i32) -> i32 {
    %0 = toy.call @add(%arg0, %arg1) : (i32, i32) -> i32
    %1 = arith.addi %arg0, %arg1 : i32
    %2 = arith.addi %1, %1 : i32
    toy.ret %2 : i32
  }
}

