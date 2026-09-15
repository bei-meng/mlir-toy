#ifndef TOY_OPS_TD
#define TOY_OPS_TD

include "mlir/IR/OpBase.td"
include "toy/ToyDialect.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/CommonAttrConstraints.td"
// mnemonic is the name of the operation, and traits is a list of traits that the operation has.
// traits 表示特质特性，约束，特性列表
// mnemonic为操作的助记符
// 这是你自定义的 Toy 操作基类，作用是批量简化所有 Toy 操作的定义：
class ToyOp<string mnemonic,list<Trait> traits = []>:
    Op<ToyDialect,mnemonic,traits>;

// Pure 是 Trait，表示没有 SideEffect 的纯函数
def AddOp :ToyOp<"add", [Pure]>{
    let summary = "Add operation";
    // let arguments = (ins AnyInteger:$lhs, AnyInteger:$rhs);
    // **可变数量的整数操作数**，也就是加法可以接受 2 个、3 个甚至任意多个整数输入，是更灵活的设计
    let arguments = (ins Variadic<AnyInteger>:$inputs);
    let results = (outs AnyInteger:$result);
}

def SubOp:ToyOp<"sub",[Pure]>{
    let summary = "sub operation";
    let arguments = (ins AnyInteger:$lhs, AnyInteger:$rhs);
    let results = (outs AnyInteger:$result);

    // verifer 发现IR的错误
    let hasVerifier = true;
}

def ConstantOp : ToyOp<"const", [Pure]> {
    let summary = "const operation";
    // `arguments` 定义操作的所有输入项，既包含**运行时操作数（Operand）**，
    // 也包含**编译期属性（Attribute）**，用 `ins` 包裹
    // `APIntAttr`：MLIR 内置的**任意精度整数属性类型**，属于 Attribute（属性），不是 Operand（操作数）
    let arguments = (ins APIntAttr:$value);
    let results = (outs AnyInteger:$result);
}

#endif
