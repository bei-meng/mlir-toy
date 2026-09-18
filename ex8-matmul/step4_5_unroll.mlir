#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> (d0 + 4)>
module {
  func.func @fc_relu(%arg0: memref<16x32xf32>, %arg1: memref<32x16xf32>, %arg2: memref<16x16xf32>, %arg3: memref<16x16xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg4 = 0 to 16 step 4 {
      affine.for %arg5 = 0 to 16 step 4 {
        affine.for %arg6 = #map(%arg4) to #map1(%arg4) {
          affine.store %cst, %arg3[%arg6, %arg5] : memref<16x16xf32>
          affine.store %cst, %arg3[%arg6, %arg5 + 1] : memref<16x16xf32>
          affine.store %cst, %arg3[%arg6, %arg5 + 2] : memref<16x16xf32>
          affine.store %cst, %arg3[%arg6, %arg5 + 3] : memref<16x16xf32>
        }
      }
    }
    affine.for %arg4 = 0 to 16 step 4 {
      affine.for %arg5 = 0 to 16 step 4 {
        affine.for %arg6 = 0 to 32 step 4 {
          affine.for %arg7 = #map(%arg4) to #map1(%arg4) {
            affine.for %arg8 = #map(%arg5) to #map1(%arg5) {
              %0 = affine.load %arg0[%arg7, %arg6] : memref<16x32xf32>
              %1 = affine.load %arg1[%arg6, %arg8] : memref<32x16xf32>
              %2 = affine.load %arg3[%arg7, %arg8] : memref<16x16xf32>
              %3 = arith.mulf %0, %1 : f32
              %4 = arith.addf %2, %3 : f32
              affine.store %4, %arg3[%arg7, %arg8] : memref<16x16xf32>
              %5 = affine.load %arg0[%arg7, %arg6 + 1] : memref<16x32xf32>
              %6 = affine.load %arg1[%arg6 + 1, %arg8] : memref<32x16xf32>
              %7 = affine.load %arg3[%arg7, %arg8] : memref<16x16xf32>
              %8 = arith.mulf %5, %6 : f32
              %9 = arith.addf %7, %8 : f32
              affine.store %9, %arg3[%arg7, %arg8] : memref<16x16xf32>
              %10 = affine.load %arg0[%arg7, %arg6 + 2] : memref<16x32xf32>
              %11 = affine.load %arg1[%arg6 + 2, %arg8] : memref<32x16xf32>
              %12 = affine.load %arg3[%arg7, %arg8] : memref<16x16xf32>
              %13 = arith.mulf %10, %11 : f32
              %14 = arith.addf %12, %13 : f32
              affine.store %14, %arg3[%arg7, %arg8] : memref<16x16xf32>
              %15 = affine.load %arg0[%arg7, %arg6 + 3] : memref<16x32xf32>
              %16 = affine.load %arg1[%arg6 + 3, %arg8] : memref<32x16xf32>
              %17 = affine.load %arg3[%arg7, %arg8] : memref<16x16xf32>
              %18 = arith.mulf %15, %16 : f32
              %19 = arith.addf %17, %18 : f32
              affine.store %19, %arg3[%arg7, %arg8] : memref<16x16xf32>
            }
          }
        }
      }
    }
    affine.for %arg4 = 0 to 16 step 4 {
      affine.for %arg5 = 0 to 16 step 4 {
        affine.for %arg6 = #map(%arg4) to #map1(%arg4) {
          %0 = affine.load %arg3[%arg6, %arg5] : memref<16x16xf32>
          %1 = affine.load %arg2[%arg6, %arg5] : memref<16x16xf32>
          %2 = arith.addf %0, %1 : f32
          affine.store %2, %arg3[%arg6, %arg5] : memref<16x16xf32>
          %3 = affine.load %arg3[%arg6, %arg5 + 1] : memref<16x16xf32>
          %4 = affine.load %arg2[%arg6, %arg5 + 1] : memref<16x16xf32>
          %5 = arith.addf %3, %4 : f32
          affine.store %5, %arg3[%arg6, %arg5 + 1] : memref<16x16xf32>
          %6 = affine.load %arg3[%arg6, %arg5 + 2] : memref<16x16xf32>
          %7 = affine.load %arg2[%arg6, %arg5 + 2] : memref<16x16xf32>
          %8 = arith.addf %6, %7 : f32
          affine.store %8, %arg3[%arg6, %arg5 + 2] : memref<16x16xf32>
          %9 = affine.load %arg3[%arg6, %arg5 + 3] : memref<16x16xf32>
          %10 = affine.load %arg2[%arg6, %arg5 + 3] : memref<16x16xf32>
          %11 = arith.addf %9, %10 : f32
          affine.store %11, %arg3[%arg6, %arg5 + 3] : memref<16x16xf32>
        }
      }
    }
    affine.for %arg4 = 0 to 16 step 4 {
      affine.for %arg5 = 0 to 16 step 4 {
        affine.for %arg6 = #map(%arg4) to #map1(%arg4) {
          %0 = affine.load %arg3[%arg6, %arg5] : memref<16x16xf32>
          %1 = arith.maximumf %0, %cst : f32
          affine.store %1, %arg3[%arg6, %arg5] : memref<16x16xf32>
          %2 = affine.load %arg3[%arg6, %arg5 + 1] : memref<16x16xf32>
          %3 = arith.maximumf %2, %cst : f32
          affine.store %3, %arg3[%arg6, %arg5 + 1] : memref<16x16xf32>
          %4 = affine.load %arg3[%arg6, %arg5 + 2] : memref<16x16xf32>
          %5 = arith.maximumf %4, %cst : f32
          affine.store %5, %arg3[%arg6, %arg5 + 2] : memref<16x16xf32>
          %6 = affine.load %arg3[%arg6, %arg5 + 3] : memref<16x16xf32>
          %7 = arith.maximumf %6, %cst : f32
          affine.store %7, %arg3[%arg6, %arg5 + 3] : memref<16x16xf32>
        }
      }
    }
    return
  }
}

