#ifndef TOY_OPS_TD
#define TOY_OPS_TD

include "mlir/IR/OpBase.td"
include "ToyDialect.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/FunctionInterfaces.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/IR/RegionKindInterface.td"

// include "mlir/IR/CommonAttrConstraints.td"
// include "mlir/Interfaces/RegionBranchOpInterface.td"


// mnemonic is the name of the operation, and traits is a list of traits that the operation has.
// traits 表示特质特性，约束，特性列表
// mnemonic为操作的助记符
// 这是你自定义的 Toy 操作基类，作用是批量简化所有 Toy 操作的定义：
class ToyOp<string mnemonic, list<Trait> traits = []>
    : Op<ToyDialect, mnemonic, traits> {
  let summary = ?;
  let description = ?;
}


// Pure 是 Trait，表示没有 SideEffect 的纯函数
def AddOp :ToyOp<"add", [Pure,SameOperandsAndResultType]>{
    let summary = "Add operation";
    // let arguments = (ins AnyInteger:$lhs, AnyInteger:$rhs);
    // **可变数量的整数操作数**，也就是加法可以接受 2 个、3 个甚至任意多个整数输入，是更灵活的设计
    let arguments = (ins Variadic<AnyInteger>:$inputs);
    let results = (outs AnyInteger:$result);
    // 更容易读的输出
    // let assemblyFormat = "$inputs attr-dict `:` type($inputs) `->` type($result)";
    // 有了自动类型推断后SameOperandsAndResultType
    let assemblyFormat = "$inputs attr-dict `:` type($result)";
}

def SubOp:ToyOp<"sub",[Pure,SameOperandsAndResultType]>{
    let summary = "Sub operation";
    let arguments = (ins AnyInteger:$lhs, AnyInteger:$rhs);
    let results = (outs AnyInteger:$result);

    // 不建议自动写结果类型推断
    // let builders = [
    //     OpBuilder<
    //         (ins "mlir::Value":$lhs, "mlir::Value":$rhs),
    //         "build($_builder,$_state,lhs.getType(),lhs,rhs);"
    //     >
    // ];

    // verifer 发现IR的错误
    let hasVerifier = true;
    let assemblyFormat = "$lhs `,` $rhs attr-dict `:` type($result)";
}


def ConstantOp : ToyOp<"const", [Pure,InferTypeOpAdaptor]> {
    let summary = "const operation";
    // `arguments` 定义操作的所有输入项，既包含**运行时操作数（Operand）**，
    // 也包含**编译期属性（Attribute）**，用 `ins` 包裹
    // `APIntAttr`：MLIR 内置的**任意精度整数属性类型**，属于 Attribute（属性），不是 Operand（操作数）
    let arguments = (ins APIntAttr:$value);
    let results = (outs AnyInteger:$result);

    let extraClassDeclaration = [{
        int64_t getBitWidth();
    }];

    let assemblyFormat = "$value attr-dict";
}

// 另一种实现
//
// def ConstantOp : ToyOp<"const", [Pure, InferTypeOpInterface]> {
//   let summary = "const operation";
//   let arguments = (ins APIntAttr:$value);
//   let results = (outs AnyInteger:$result);
//   let assemblyFormat = "$value attr-dict";
//   let extraClassDeclaration = [{
//     static mlir::LogicalResult inferReturnTypes(
//       mlir::MLIRContext * context,
//       std::optional<::mlir::Location> location,
//       mlir::ValueRange operands,
//       mlir::DictionaryAttr attributes,
//       mlir::OpaqueProperties properties,
//       mlir::RegionRange regions,
//       llvm::SmallVectorImpl<::mlir::Type>& inferredReturnTypes
//     );
//   }];
// }



// **`Terminator`（终止符 Trait）**
// 标记该操作是**基本块（Block）的结尾指令**
// **`ReturnLike`（返回类 Trait）**include "mlir/Interfaces/ControlFlowInterfaces.td"
// 标记该操作是**函数返回操作**，语义上代表函数执行结束，将控制流和返回值交还给调用方。
// returnLike Trait 继承了 Terminator Trait，意味着 ReturnLike 操作也是 Terminator 操作的一种特殊情况。
def ReturnOp :ToyOp<"ret", [Terminator, ReturnLike]>{
    let summary = "return operation";
    // ODS 的可选包装器，表示这个操作数**可以有，也可以没有**
    let arguments = (ins Optional<AnyInteger>:$data);
    let assemblyFormat = "($data `:` type($data)^)? attr-dict";
}



/*
- `Optional<I1>`：**可选的运行时信号**，关注「有没有这个输入」，输入本身是个 SSA 变量；
- `UnitAttr`：**编译期开关标记**，关注「有没有这个标记」，没有值；
`BoolAttr`：**编译期布尔常量**，关注「值是 true 还是 false」，有明确的布尔值。
*/
def HWRegOp :ToyOp<"reg">{
    let summary = "Hardware Register operation";
    let arguments = (ins I1:$clock,AnyInteger:$input,Optional<I1>:$reset,UnitAttr:$is_public);
    let results = (outs AnyInteger:$result);
    let assemblyFormat = [{
        (`public` $is_public^)? $input
        `clock` $clock
        (`reset` $reset^)?
        attr-dict `:` functional-type($input, results)
    }];
}



def FuncOp:ToyOp<"func", [
    IsolatedFromAbove,
    FunctionOpInterface,
    /* Symbol, */ /* Symbol 会自动被 FunctionOpInterface 加上 */
    /* CallableOpInterface, */ /* CallOpInterface 会自动被 FunctionOpInterface 加上 */
    RegionKindInterface
]>{
    let summary = "function operation";
    let arguments = (ins 
        SymbolNameAttr:$sym_name,
        TypeAttrOf<FunctionType>:$function_type,
        // FunctionOpInterface 需要两个 Attr 来记录 arg 和 res 的名字
        OptionalAttr<DictArrayAttr>:$arg_attrs,
        OptionalAttr<DictArrayAttr>:$res_attrs
    );

    dag regions = (region AnyRegion:$body);
    let hasCustomAssemblyFormat = true;
    let extraClassDeclaration = [{
        // Method of FunctionOpInterface
        mlir::Region * getCallableRegion() {return &getBody();}
        // getFunctionType 函数会自动生成
        // mlir::FunctionType getFunctionType(); 

        // Method of CallableOpInterface
        llvm::ArrayRef<mlir::Type> getArgumentTypes() {return getFunctionType().getInputs();}
        llvm::ArrayRef<mlir::Type> getResultTypes() {return getFunctionType().getResults();}

        // Method of RegionKindInterface
        static mlir::RegionKind getRegionKind(unsigned idx) { return mlir::RegionKind::SSACFG; }
    }];
}

def CallOp : ToyOp<"call", [CallOpInterface]> {
  let summary = "call operation";
  let arguments = (ins SymbolRefAttr:$callee, Variadic<AnyType>:$arg_operands);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$callee `(` $arg_operands `)` attr-dict `:` functional-type($arg_operands, results)";
  let extraClassDeclaration = [{
    mlir::CallInterfaceCallable getCallableForCallee() { return getCalleeAttr(); }
    void setCalleeFromCallable(mlir::CallInterfaceCallable callee) { setCalleeAttr(callee.get<mlir::SymbolRefAttr>()); }
  }];
}
#endif
