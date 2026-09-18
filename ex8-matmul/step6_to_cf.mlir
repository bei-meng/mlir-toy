module {
  func.func @fc_relu(%arg0: memref<16x32xf32>, %arg1: memref<32x16xf32>, %arg2: memref<16x16xf32>, %arg3: memref<16x16xf32>) {
    %c32 = arith.constant 32 : index
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c16 = arith.constant 16 : index
    %c4 = arith.constant 4 : index
    cf.br ^bb1(%c0 : index)
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb7
    %1 = arith.cmpi slt, %0, %c16 : index
    cf.cond_br %1, ^bb2(%c0 : index), ^bb8(%c0 : index)
  ^bb2(%2: index):  // 2 preds: ^bb1, ^bb6
    %3 = arith.cmpi slt, %2, %c16 : index
    cf.cond_br %3, ^bb3, ^bb7
  ^bb3:  // pred: ^bb2
    %4 = arith.addi %0, %c4 : index
    cf.br ^bb4(%0 : index)
  ^bb4(%5: index):  // 2 preds: ^bb3, ^bb5
    %6 = arith.cmpi slt, %5, %4 : index
    cf.cond_br %6, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    memref.store %cst, %arg3[%5, %2] : memref<16x16xf32>
    %7 = arith.addi %2, %c1 : index
    memref.store %cst, %arg3[%5, %7] : memref<16x16xf32>
    %8 = arith.addi %2, %c2 : index
    memref.store %cst, %arg3[%5, %8] : memref<16x16xf32>
    %9 = arith.addi %2, %c3 : index
    memref.store %cst, %arg3[%5, %9] : memref<16x16xf32>
    %10 = arith.addi %5, %c1 : index
    cf.br ^bb4(%10 : index)
  ^bb6:  // pred: ^bb4
    %11 = arith.addi %2, %c4 : index
    cf.br ^bb2(%11 : index)
  ^bb7:  // pred: ^bb2
    %12 = arith.addi %0, %c4 : index
    cf.br ^bb1(%12 : index)
  ^bb8(%13: index):  // 2 preds: ^bb1, ^bb19
    %14 = arith.cmpi slt, %13, %c16 : index
    cf.cond_br %14, ^bb9(%c0 : index), ^bb20(%c0 : index)
  ^bb9(%15: index):  // 2 preds: ^bb8, ^bb18
    %16 = arith.cmpi slt, %15, %c16 : index
    cf.cond_br %16, ^bb10(%c0 : index), ^bb19
  ^bb10(%17: index):  // 2 preds: ^bb9, ^bb17
    %18 = arith.cmpi slt, %17, %c32 : index
    cf.cond_br %18, ^bb11, ^bb18
  ^bb11:  // pred: ^bb10
    %19 = arith.addi %13, %c4 : index
    cf.br ^bb12(%13 : index)
  ^bb12(%20: index):  // 2 preds: ^bb11, ^bb16
    %21 = arith.cmpi slt, %20, %19 : index
    cf.cond_br %21, ^bb13, ^bb17
  ^bb13:  // pred: ^bb12
    %22 = arith.addi %15, %c4 : index
    cf.br ^bb14(%15 : index)
  ^bb14(%23: index):  // 2 preds: ^bb13, ^bb15
    %24 = arith.cmpi slt, %23, %22 : index
    cf.cond_br %24, ^bb15, ^bb16
  ^bb15:  // pred: ^bb14
    %25 = memref.load %arg0[%20, %17] : memref<16x32xf32>
    %26 = memref.load %arg1[%17, %23] : memref<32x16xf32>
    %27 = memref.load %arg3[%20, %23] : memref<16x16xf32>
    %28 = arith.mulf %25, %26 : f32
    %29 = arith.addf %27, %28 : f32
    memref.store %29, %arg3[%20, %23] : memref<16x16xf32>
    %30 = arith.addi %17, %c1 : index
    %31 = memref.load %arg0[%20, %30] : memref<16x32xf32>
    %32 = memref.load %arg1[%30, %23] : memref<32x16xf32>
    %33 = arith.mulf %31, %32 : f32
    %34 = arith.addf %29, %33 : f32
    memref.store %34, %arg3[%20, %23] : memref<16x16xf32>
    %35 = arith.addi %17, %c2 : index
    %36 = memref.load %arg0[%20, %35] : memref<16x32xf32>
    %37 = memref.load %arg1[%35, %23] : memref<32x16xf32>
    %38 = arith.mulf %36, %37 : f32
    %39 = arith.addf %34, %38 : f32
    memref.store %39, %arg3[%20, %23] : memref<16x16xf32>
    %40 = arith.addi %17, %c3 : index
    %41 = memref.load %arg0[%20, %40] : memref<16x32xf32>
    %42 = memref.load %arg1[%40, %23] : memref<32x16xf32>
    %43 = arith.mulf %41, %42 : f32
    %44 = arith.addf %39, %43 : f32
    memref.store %44, %arg3[%20, %23] : memref<16x16xf32>
    %45 = arith.addi %23, %c1 : index
    cf.br ^bb14(%45 : index)
  ^bb16:  // pred: ^bb14
    %46 = arith.addi %20, %c1 : index
    cf.br ^bb12(%46 : index)
  ^bb17:  // pred: ^bb12
    %47 = arith.addi %17, %c4 : index
    cf.br ^bb10(%47 : index)
  ^bb18:  // pred: ^bb10
    %48 = arith.addi %15, %c4 : index
    cf.br ^bb9(%48 : index)
  ^bb19:  // pred: ^bb9
    %49 = arith.addi %13, %c4 : index
    cf.br ^bb8(%49 : index)
  ^bb20(%50: index):  // 2 preds: ^bb8, ^bb26
    %51 = arith.cmpi slt, %50, %c16 : index
    cf.cond_br %51, ^bb21(%c0 : index), ^bb27(%c0 : index)
  ^bb21(%52: index):  // 2 preds: ^bb20, ^bb25
    %53 = arith.cmpi slt, %52, %c16 : index
    cf.cond_br %53, ^bb22, ^bb26
  ^bb22:  // pred: ^bb21
    %54 = arith.addi %50, %c4 : index
    cf.br ^bb23(%50 : index)
  ^bb23(%55: index):  // 2 preds: ^bb22, ^bb24
    %56 = arith.cmpi slt, %55, %54 : index
    cf.cond_br %56, ^bb24, ^bb25
  ^bb24:  // pred: ^bb23
    %57 = memref.load %arg3[%55, %52] : memref<16x16xf32>
    %58 = memref.load %arg2[%55, %52] : memref<16x16xf32>
    %59 = arith.addf %57, %58 : f32
    memref.store %59, %arg3[%55, %52] : memref<16x16xf32>
    %60 = arith.addi %52, %c1 : index
    %61 = memref.load %arg3[%55, %60] : memref<16x16xf32>
    %62 = memref.load %arg2[%55, %60] : memref<16x16xf32>
    %63 = arith.addf %61, %62 : f32
    memref.store %63, %arg3[%55, %60] : memref<16x16xf32>
    %64 = arith.addi %52, %c2 : index
    %65 = memref.load %arg3[%55, %64] : memref<16x16xf32>
    %66 = memref.load %arg2[%55, %64] : memref<16x16xf32>
    %67 = arith.addf %65, %66 : f32
    memref.store %67, %arg3[%55, %64] : memref<16x16xf32>
    %68 = arith.addi %52, %c3 : index
    %69 = memref.load %arg3[%55, %68] : memref<16x16xf32>
    %70 = memref.load %arg2[%55, %68] : memref<16x16xf32>
    %71 = arith.addf %69, %70 : f32
    memref.store %71, %arg3[%55, %68] : memref<16x16xf32>
    %72 = arith.addi %55, %c1 : index
    cf.br ^bb23(%72 : index)
  ^bb25:  // pred: ^bb23
    %73 = arith.addi %52, %c4 : index
    cf.br ^bb21(%73 : index)
  ^bb26:  // pred: ^bb21
    %74 = arith.addi %50, %c4 : index
    cf.br ^bb20(%74 : index)
  ^bb27(%75: index):  // 2 preds: ^bb20, ^bb33
    %76 = arith.cmpi slt, %75, %c16 : index
    cf.cond_br %76, ^bb28(%c0 : index), ^bb34
  ^bb28(%77: index):  // 2 preds: ^bb27, ^bb32
    %78 = arith.cmpi slt, %77, %c16 : index
    cf.cond_br %78, ^bb29, ^bb33
  ^bb29:  // pred: ^bb28
    %79 = arith.addi %75, %c4 : index
    cf.br ^bb30(%75 : index)
  ^bb30(%80: index):  // 2 preds: ^bb29, ^bb31
    %81 = arith.cmpi slt, %80, %79 : index
    cf.cond_br %81, ^bb31, ^bb32
  ^bb31:  // pred: ^bb30
    %82 = memref.load %arg3[%80, %77] : memref<16x16xf32>
    %83 = arith.maximumf %82, %cst : f32
    memref.store %83, %arg3[%80, %77] : memref<16x16xf32>
    %84 = arith.addi %77, %c1 : index
    %85 = memref.load %arg3[%80, %84] : memref<16x16xf32>
    %86 = arith.maximumf %85, %cst : f32
    memref.store %86, %arg3[%80, %84] : memref<16x16xf32>
    %87 = arith.addi %77, %c2 : index
    %88 = memref.load %arg3[%80, %87] : memref<16x16xf32>
    %89 = arith.maximumf %88, %cst : f32
    memref.store %89, %arg3[%80, %87] : memref<16x16xf32>
    %90 = arith.addi %77, %c3 : index
    %91 = memref.load %arg3[%80, %90] : memref<16x16xf32>
    %92 = arith.maximumf %91, %cst : f32
    memref.store %92, %arg3[%80, %90] : memref<16x16xf32>
    %93 = arith.addi %80, %c1 : index
    cf.br ^bb30(%93 : index)
  ^bb32:  // pred: ^bb30
    %94 = arith.addi %77, %c4 : index
    cf.br ^bb28(%94 : index)
  ^bb33:  // pred: ^bb28
    %95 = arith.addi %75, %c4 : index
    cf.br ^bb27(%95 : index)
  ^bb34:  // pred: ^bb27
    return
  }
}

