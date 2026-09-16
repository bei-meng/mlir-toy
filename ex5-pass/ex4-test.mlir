module {
  // ==============================================
  // 1. 双参加法函数：验证 FuncOp / AddOp / ReturnOp
  // ==============================================
  toy.func @add_two(%lhs: i32, %rhs: i32) -> i32 {
    // AddOp：可变参数版本，两个操作数，结果类型与操作数一致
    %sum = toy.add %lhs, %rhs : i32
    // ReturnOp：带返回值的终止符，匹配函数返回类型
    toy.ret %sum : i32
  }

  // ==============================================
  // 2. 三参加法函数：验证 AddOp 的 Variadic 可变参数特性
  // ==============================================
  toy.func @add_three(%a: i32, %b: i32, %c: i32) -> i32 {
    // AddOp：传入 3 个操作数，验证可变参数支持
    %total = toy.add %a, %b, %c : i32
    toy.ret %total : i32
  }

  // ==============================================
  // 3. 无返回值函数：验证 ReturnOp 的 Optional 可选特性
  // ==============================================
  toy.func @print_value(%val: i32) {
    // ReturnOp：无返回值，可选参数为空
    toy.ret
  }

  // ==============================================
  // 4. 主函数：覆盖 ConstantOp / SubOp / CallOp / 全量组合
  // ==============================================
  toy.func @main() -> i32 {
    // ConstantOp：整数常量属性，验证 InferTypeOpAdaptor 类型推断
    %x = toy.const 200 : i32
    %y = toy.const 75 : i32

    // SubOp：双操作数减法，验证 SameOperandsAndResultType + verifier 类型校验
    %diff = toy.sub %x, %y : i32

    // CallOp：函数调用，验证 SymbolRefAttr 符号引用 + CallOpInterface
    %sum2 = toy.call @add_two(%x, %y) : (i32, i32) -> i32
    %sum3 = toy.call @add_three(%x, %y, %diff) : (i32, i32, i32) -> i32

    // AddOp：多参数组合运算
    %result = toy.add %diff, %sum2, %sum3 : i32

    toy.ret %result : i32
  }
}
