module {
  func.func @fc_relu(%arg0: memref<16x32xf32>, %arg1: memref<32x16xf32>, %arg2: memref<16x16xf32>, %arg3: memref<16x16xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg4 = 0 to 16 {
      affine.for %arg5 = 0 to 16 {
        affine.store %cst, %arg3[%arg4, %arg5] : memref<16x16xf32>
      }
    }
    affine.for %arg4 = 0 to 16 {
      affine.for %arg5 = 0 to 16 {
        affine.for %arg6 = 0 to 32 {
          %0 = affine.load %arg0[%arg4, %arg6] : memref<16x32xf32>
          %1 = affine.load %arg1[%arg6, %arg5] : memref<32x16xf32>
          %2 = affine.load %arg3[%arg4, %arg5] : memref<16x16xf32>
          %3 = arith.mulf %0, %1 : f32
          %4 = arith.addf %2, %3 : f32
          affine.store %4, %arg3[%arg4, %arg5] : memref<16x16xf32>
        }
      }
    }
    affine.for %arg4 = 0 to 16 {
      affine.for %arg5 = 0 to 16 {
        %0 = affine.load %arg3[%arg4, %arg5] : memref<16x16xf32>
        %1 = affine.load %arg2[%arg4, %arg5] : memref<16x16xf32>
        %2 = arith.addf %0, %1 : f32
        affine.store %2, %arg3[%arg4, %arg5] : memref<16x16xf32>
      }
    }
    affine.for %arg4 = 0 to 16 {
      affine.for %arg5 = 0 to 16 {
        %0 = affine.load %arg3[%arg4, %arg5] : memref<16x16xf32>
        %1 = arith.maximumf %0, %cst : f32
        affine.store %1, %arg3[%arg4, %arg5] : memref<16x16xf32>
      }
    }
    return
  }
}

