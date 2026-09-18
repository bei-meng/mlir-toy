module {
  llvm.func @fc_relu(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr, %arg8: !llvm.ptr, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr, %arg15: !llvm.ptr, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64, %arg21: !llvm.ptr, %arg22: !llvm.ptr, %arg23: i64, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64) {
    %0 = llvm.mlir.constant(4 : index) : i64
    %1 = llvm.mlir.constant(16 : index) : i64
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %4 = llvm.mlir.constant(1 : index) : i64
    %5 = llvm.mlir.constant(2 : index) : i64
    %6 = llvm.mlir.constant(3 : index) : i64
    %7 = llvm.mlir.constant(32 : index) : i64
    llvm.br ^bb1(%2 : i64)
  ^bb1(%8: i64):  // 2 preds: ^bb0, ^bb7
    %9 = llvm.icmp "slt" %8, %1 : i64
    llvm.cond_br %9, ^bb2(%2 : i64), ^bb8(%2 : i64)
  ^bb2(%10: i64):  // 2 preds: ^bb1, ^bb6
    %11 = llvm.icmp "slt" %10, %1 : i64
    llvm.cond_br %11, ^bb3, ^bb7
  ^bb3:  // pred: ^bb2
    %12 = llvm.add %8, %0  : i64
    llvm.br ^bb4(%8 : i64)
  ^bb4(%13: i64):  // 2 preds: ^bb3, ^bb5
    %14 = llvm.icmp "slt" %13, %12 : i64
    llvm.cond_br %14, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %15 = llvm.mul %13, %1  : i64
    %16 = llvm.add %15, %10  : i64
    %17 = llvm.getelementptr %arg22[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %3, %17 : f32, !llvm.ptr
    %18 = llvm.add %10, %4  : i64
    %19 = llvm.mul %13, %1  : i64
    %20 = llvm.add %19, %18  : i64
    %21 = llvm.getelementptr %arg22[%20] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %3, %21 : f32, !llvm.ptr
    %22 = llvm.add %10, %5  : i64
    %23 = llvm.mul %13, %1  : i64
    %24 = llvm.add %23, %22  : i64
    %25 = llvm.getelementptr %arg22[%24] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %3, %25 : f32, !llvm.ptr
    %26 = llvm.add %10, %6  : i64
    %27 = llvm.mul %13, %1  : i64
    %28 = llvm.add %27, %26  : i64
    %29 = llvm.getelementptr %arg22[%28] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %3, %29 : f32, !llvm.ptr
    %30 = llvm.add %13, %4  : i64
    llvm.br ^bb4(%30 : i64)
  ^bb6:  // pred: ^bb4
    %31 = llvm.add %10, %0  : i64
    llvm.br ^bb2(%31 : i64)
  ^bb7:  // pred: ^bb2
    %32 = llvm.add %8, %0  : i64
    llvm.br ^bb1(%32 : i64)
  ^bb8(%33: i64):  // 2 preds: ^bb1, ^bb19
    %34 = llvm.icmp "slt" %33, %1 : i64
    llvm.cond_br %34, ^bb9(%2 : i64), ^bb20(%2 : i64)
  ^bb9(%35: i64):  // 2 preds: ^bb8, ^bb18
    %36 = llvm.icmp "slt" %35, %1 : i64
    llvm.cond_br %36, ^bb10(%2 : i64), ^bb19
  ^bb10(%37: i64):  // 2 preds: ^bb9, ^bb17
    %38 = llvm.icmp "slt" %37, %7 : i64
    llvm.cond_br %38, ^bb11, ^bb18
  ^bb11:  // pred: ^bb10
    %39 = llvm.add %33, %0  : i64
    llvm.br ^bb12(%33 : i64)
  ^bb12(%40: i64):  // 2 preds: ^bb11, ^bb16
    %41 = llvm.icmp "slt" %40, %39 : i64
    llvm.cond_br %41, ^bb13, ^bb17
  ^bb13:  // pred: ^bb12
    %42 = llvm.add %35, %0  : i64
    llvm.br ^bb14(%35 : i64)
  ^bb14(%43: i64):  // 2 preds: ^bb13, ^bb15
    %44 = llvm.icmp "slt" %43, %42 : i64
    llvm.cond_br %44, ^bb15, ^bb16
  ^bb15:  // pred: ^bb14
    %45 = llvm.mul %40, %7  : i64
    %46 = llvm.add %45, %37  : i64
    %47 = llvm.getelementptr %arg1[%46] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %48 = llvm.load %47 : !llvm.ptr -> f32
    %49 = llvm.mul %37, %1  : i64
    %50 = llvm.add %49, %43  : i64
    %51 = llvm.getelementptr %arg8[%50] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %52 = llvm.load %51 : !llvm.ptr -> f32
    %53 = llvm.mul %40, %1  : i64
    %54 = llvm.add %53, %43  : i64
    %55 = llvm.getelementptr %arg22[%54] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %56 = llvm.load %55 : !llvm.ptr -> f32
    %57 = llvm.fmul %48, %52  : f32
    %58 = llvm.fadd %56, %57  : f32
    %59 = llvm.mul %40, %1  : i64
    %60 = llvm.add %59, %43  : i64
    %61 = llvm.getelementptr %arg22[%60] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %58, %61 : f32, !llvm.ptr
    %62 = llvm.add %37, %4  : i64
    %63 = llvm.mul %40, %7  : i64
    %64 = llvm.add %63, %62  : i64
    %65 = llvm.getelementptr %arg1[%64] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %66 = llvm.load %65 : !llvm.ptr -> f32
    %67 = llvm.mul %62, %1  : i64
    %68 = llvm.add %67, %43  : i64
    %69 = llvm.getelementptr %arg8[%68] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %70 = llvm.load %69 : !llvm.ptr -> f32
    %71 = llvm.fmul %66, %70  : f32
    %72 = llvm.fadd %58, %71  : f32
    %73 = llvm.mul %40, %1  : i64
    %74 = llvm.add %73, %43  : i64
    %75 = llvm.getelementptr %arg22[%74] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %72, %75 : f32, !llvm.ptr
    %76 = llvm.add %37, %5  : i64
    %77 = llvm.mul %40, %7  : i64
    %78 = llvm.add %77, %76  : i64
    %79 = llvm.getelementptr %arg1[%78] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %80 = llvm.load %79 : !llvm.ptr -> f32
    %81 = llvm.mul %76, %1  : i64
    %82 = llvm.add %81, %43  : i64
    %83 = llvm.getelementptr %arg8[%82] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %84 = llvm.load %83 : !llvm.ptr -> f32
    %85 = llvm.fmul %80, %84  : f32
    %86 = llvm.fadd %72, %85  : f32
    %87 = llvm.mul %40, %1  : i64
    %88 = llvm.add %87, %43  : i64
    %89 = llvm.getelementptr %arg22[%88] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %86, %89 : f32, !llvm.ptr
    %90 = llvm.add %37, %6  : i64
    %91 = llvm.mul %40, %7  : i64
    %92 = llvm.add %91, %90  : i64
    %93 = llvm.getelementptr %arg1[%92] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %94 = llvm.load %93 : !llvm.ptr -> f32
    %95 = llvm.mul %90, %1  : i64
    %96 = llvm.add %95, %43  : i64
    %97 = llvm.getelementptr %arg8[%96] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %98 = llvm.load %97 : !llvm.ptr -> f32
    %99 = llvm.fmul %94, %98  : f32
    %100 = llvm.fadd %86, %99  : f32
    %101 = llvm.mul %40, %1  : i64
    %102 = llvm.add %101, %43  : i64
    %103 = llvm.getelementptr %arg22[%102] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %100, %103 : f32, !llvm.ptr
    %104 = llvm.add %43, %4  : i64
    llvm.br ^bb14(%104 : i64)
  ^bb16:  // pred: ^bb14
    %105 = llvm.add %40, %4  : i64
    llvm.br ^bb12(%105 : i64)
  ^bb17:  // pred: ^bb12
    %106 = llvm.add %37, %0  : i64
    llvm.br ^bb10(%106 : i64)
  ^bb18:  // pred: ^bb10
    %107 = llvm.add %35, %0  : i64
    llvm.br ^bb9(%107 : i64)
  ^bb19:  // pred: ^bb9
    %108 = llvm.add %33, %0  : i64
    llvm.br ^bb8(%108 : i64)
  ^bb20(%109: i64):  // 2 preds: ^bb8, ^bb26
    %110 = llvm.icmp "slt" %109, %1 : i64
    llvm.cond_br %110, ^bb21(%2 : i64), ^bb27(%2 : i64)
  ^bb21(%111: i64):  // 2 preds: ^bb20, ^bb25
    %112 = llvm.icmp "slt" %111, %1 : i64
    llvm.cond_br %112, ^bb22, ^bb26
  ^bb22:  // pred: ^bb21
    %113 = llvm.add %109, %0  : i64
    llvm.br ^bb23(%109 : i64)
  ^bb23(%114: i64):  // 2 preds: ^bb22, ^bb24
    %115 = llvm.icmp "slt" %114, %113 : i64
    llvm.cond_br %115, ^bb24, ^bb25
  ^bb24:  // pred: ^bb23
    %116 = llvm.mul %114, %1  : i64
    %117 = llvm.add %116, %111  : i64
    %118 = llvm.getelementptr %arg22[%117] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %119 = llvm.load %118 : !llvm.ptr -> f32
    %120 = llvm.mul %114, %1  : i64
    %121 = llvm.add %120, %111  : i64
    %122 = llvm.getelementptr %arg15[%121] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %123 = llvm.load %122 : !llvm.ptr -> f32
    %124 = llvm.fadd %119, %123  : f32
    %125 = llvm.mul %114, %1  : i64
    %126 = llvm.add %125, %111  : i64
    %127 = llvm.getelementptr %arg22[%126] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %124, %127 : f32, !llvm.ptr
    %128 = llvm.add %111, %4  : i64
    %129 = llvm.mul %114, %1  : i64
    %130 = llvm.add %129, %128  : i64
    %131 = llvm.getelementptr %arg22[%130] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %132 = llvm.load %131 : !llvm.ptr -> f32
    %133 = llvm.mul %114, %1  : i64
    %134 = llvm.add %133, %128  : i64
    %135 = llvm.getelementptr %arg15[%134] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %136 = llvm.load %135 : !llvm.ptr -> f32
    %137 = llvm.fadd %132, %136  : f32
    %138 = llvm.mul %114, %1  : i64
    %139 = llvm.add %138, %128  : i64
    %140 = llvm.getelementptr %arg22[%139] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %137, %140 : f32, !llvm.ptr
    %141 = llvm.add %111, %5  : i64
    %142 = llvm.mul %114, %1  : i64
    %143 = llvm.add %142, %141  : i64
    %144 = llvm.getelementptr %arg22[%143] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %145 = llvm.load %144 : !llvm.ptr -> f32
    %146 = llvm.mul %114, %1  : i64
    %147 = llvm.add %146, %141  : i64
    %148 = llvm.getelementptr %arg15[%147] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %149 = llvm.load %148 : !llvm.ptr -> f32
    %150 = llvm.fadd %145, %149  : f32
    %151 = llvm.mul %114, %1  : i64
    %152 = llvm.add %151, %141  : i64
    %153 = llvm.getelementptr %arg22[%152] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %150, %153 : f32, !llvm.ptr
    %154 = llvm.add %111, %6  : i64
    %155 = llvm.mul %114, %1  : i64
    %156 = llvm.add %155, %154  : i64
    %157 = llvm.getelementptr %arg22[%156] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %158 = llvm.load %157 : !llvm.ptr -> f32
    %159 = llvm.mul %114, %1  : i64
    %160 = llvm.add %159, %154  : i64
    %161 = llvm.getelementptr %arg15[%160] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %162 = llvm.load %161 : !llvm.ptr -> f32
    %163 = llvm.fadd %158, %162  : f32
    %164 = llvm.mul %114, %1  : i64
    %165 = llvm.add %164, %154  : i64
    %166 = llvm.getelementptr %arg22[%165] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %163, %166 : f32, !llvm.ptr
    %167 = llvm.add %114, %4  : i64
    llvm.br ^bb23(%167 : i64)
  ^bb25:  // pred: ^bb23
    %168 = llvm.add %111, %0  : i64
    llvm.br ^bb21(%168 : i64)
  ^bb26:  // pred: ^bb21
    %169 = llvm.add %109, %0  : i64
    llvm.br ^bb20(%169 : i64)
  ^bb27(%170: i64):  // 2 preds: ^bb20, ^bb33
    %171 = llvm.icmp "slt" %170, %1 : i64
    llvm.cond_br %171, ^bb28(%2 : i64), ^bb34
  ^bb28(%172: i64):  // 2 preds: ^bb27, ^bb32
    %173 = llvm.icmp "slt" %172, %1 : i64
    llvm.cond_br %173, ^bb29, ^bb33
  ^bb29:  // pred: ^bb28
    %174 = llvm.add %170, %0  : i64
    llvm.br ^bb30(%170 : i64)
  ^bb30(%175: i64):  // 2 preds: ^bb29, ^bb31
    %176 = llvm.icmp "slt" %175, %174 : i64
    llvm.cond_br %176, ^bb31, ^bb32
  ^bb31:  // pred: ^bb30
    %177 = llvm.mul %175, %1  : i64
    %178 = llvm.add %177, %172  : i64
    %179 = llvm.getelementptr %arg22[%178] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %180 = llvm.load %179 : !llvm.ptr -> f32
    %181 = llvm.intr.maximum(%180, %3)  : (f32, f32) -> f32
    %182 = llvm.mul %175, %1  : i64
    %183 = llvm.add %182, %172  : i64
    %184 = llvm.getelementptr %arg22[%183] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %181, %184 : f32, !llvm.ptr
    %185 = llvm.add %172, %4  : i64
    %186 = llvm.mul %175, %1  : i64
    %187 = llvm.add %186, %185  : i64
    %188 = llvm.getelementptr %arg22[%187] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %189 = llvm.load %188 : !llvm.ptr -> f32
    %190 = llvm.intr.maximum(%189, %3)  : (f32, f32) -> f32
    %191 = llvm.mul %175, %1  : i64
    %192 = llvm.add %191, %185  : i64
    %193 = llvm.getelementptr %arg22[%192] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %190, %193 : f32, !llvm.ptr
    %194 = llvm.add %172, %5  : i64
    %195 = llvm.mul %175, %1  : i64
    %196 = llvm.add %195, %194  : i64
    %197 = llvm.getelementptr %arg22[%196] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %198 = llvm.load %197 : !llvm.ptr -> f32
    %199 = llvm.intr.maximum(%198, %3)  : (f32, f32) -> f32
    %200 = llvm.mul %175, %1  : i64
    %201 = llvm.add %200, %194  : i64
    %202 = llvm.getelementptr %arg22[%201] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %199, %202 : f32, !llvm.ptr
    %203 = llvm.add %172, %6  : i64
    %204 = llvm.mul %175, %1  : i64
    %205 = llvm.add %204, %203  : i64
    %206 = llvm.getelementptr %arg22[%205] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %207 = llvm.load %206 : !llvm.ptr -> f32
    %208 = llvm.intr.maximum(%207, %3)  : (f32, f32) -> f32
    %209 = llvm.mul %175, %1  : i64
    %210 = llvm.add %209, %203  : i64
    %211 = llvm.getelementptr %arg22[%210] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %208, %211 : f32, !llvm.ptr
    %212 = llvm.add %175, %4  : i64
    llvm.br ^bb30(%212 : i64)
  ^bb32:  // pred: ^bb30
    %213 = llvm.add %172, %0  : i64
    llvm.br ^bb28(%213 : i64)
  ^bb33:  // pred: ^bb28
    %214 = llvm.add %170, %0  : i64
    llvm.br ^bb27(%214 : i64)
  ^bb34:  // pred: ^bb27
    llvm.return
  }
}

