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
    scf.for %arg4 = %c0 to %c16 step %c4 {
      scf.for %arg5 = %c0 to %c16 step %c4 {
        %0 = arith.addi %arg4, %c4 : index
        scf.for %arg6 = %arg4 to %0 step %c1 {
          memref.store %cst, %arg3[%arg6, %arg5] : memref<16x16xf32>
          %1 = arith.addi %arg5, %c1 : index
          memref.store %cst, %arg3[%arg6, %1] : memref<16x16xf32>
          %2 = arith.addi %arg5, %c2 : index
          memref.store %cst, %arg3[%arg6, %2] : memref<16x16xf32>
          %3 = arith.addi %arg5, %c3 : index
          memref.store %cst, %arg3[%arg6, %3] : memref<16x16xf32>
        }
      }
    }
    scf.for %arg4 = %c0 to %c16 step %c4 {
      scf.for %arg5 = %c0 to %c16 step %c4 {
        scf.for %arg6 = %c0 to %c32 step %c4 {
          %0 = arith.addi %arg4, %c4 : index
          scf.for %arg7 = %arg4 to %0 step %c1 {
            %1 = arith.addi %arg5, %c4 : index
            scf.for %arg8 = %arg5 to %1 step %c1 {
              %2 = memref.load %arg0[%arg7, %arg6] : memref<16x32xf32>
              %3 = memref.load %arg1[%arg6, %arg8] : memref<32x16xf32>
              %4 = memref.load %arg3[%arg7, %arg8] : memref<16x16xf32>
              %5 = arith.mulf %2, %3 : f32
              %6 = arith.addf %4, %5 : f32
              memref.store %6, %arg3[%arg7, %arg8] : memref<16x16xf32>
              %7 = arith.addi %arg6, %c1 : index
              %8 = memref.load %arg0[%arg7, %7] : memref<16x32xf32>
              %9 = memref.load %arg1[%7, %arg8] : memref<32x16xf32>
              %10 = arith.mulf %8, %9 : f32
              %11 = arith.addf %6, %10 : f32
              memref.store %11, %arg3[%arg7, %arg8] : memref<16x16xf32>
              %12 = arith.addi %arg6, %c2 : index
              %13 = memref.load %arg0[%arg7, %12] : memref<16x32xf32>
              %14 = memref.load %arg1[%12, %arg8] : memref<32x16xf32>
              %15 = arith.mulf %13, %14 : f32
              %16 = arith.addf %11, %15 : f32
              memref.store %16, %arg3[%arg7, %arg8] : memref<16x16xf32>
              %17 = arith.addi %arg6, %c3 : index
              %18 = memref.load %arg0[%arg7, %17] : memref<16x32xf32>
              %19 = memref.load %arg1[%17, %arg8] : memref<32x16xf32>
              %20 = arith.mulf %18, %19 : f32
              %21 = arith.addf %16, %20 : f32
              memref.store %21, %arg3[%arg7, %arg8] : memref<16x16xf32>
            }
          }
        }
      }
    }
    scf.for %arg4 = %c0 to %c16 step %c4 {
      scf.for %arg5 = %c0 to %c16 step %c4 {
        %0 = arith.addi %arg4, %c4 : index
        scf.for %arg6 = %arg4 to %0 step %c1 {
          %1 = memref.load %arg3[%arg6, %arg5] : memref<16x16xf32>
          %2 = memref.load %arg2[%arg6, %arg5] : memref<16x16xf32>
          %3 = arith.addf %1, %2 : f32
          memref.store %3, %arg3[%arg6, %arg5] : memref<16x16xf32>
          %4 = arith.addi %arg5, %c1 : index
          %5 = memref.load %arg3[%arg6, %4] : memref<16x16xf32>
          %6 = memref.load %arg2[%arg6, %4] : memref<16x16xf32>
          %7 = arith.addf %5, %6 : f32
          memref.store %7, %arg3[%arg6, %4] : memref<16x16xf32>
          %8 = arith.addi %arg5, %c2 : index
          %9 = memref.load %arg3[%arg6, %8] : memref<16x16xf32>
          %10 = memref.load %arg2[%arg6, %8] : memref<16x16xf32>
          %11 = arith.addf %9, %10 : f32
          memref.store %11, %arg3[%arg6, %8] : memref<16x16xf32>
          %12 = arith.addi %arg5, %c3 : index
          %13 = memref.load %arg3[%arg6, %12] : memref<16x16xf32>
          %14 = memref.load %arg2[%arg6, %12] : memref<16x16xf32>
          %15 = arith.addf %13, %14 : f32
          memref.store %15, %arg3[%arg6, %12] : memref<16x16xf32>
        }
      }
    }
    scf.for %arg4 = %c0 to %c16 step %c4 {
      scf.for %arg5 = %c0 to %c16 step %c4 {
        %0 = arith.addi %arg4, %c4 : index
        scf.for %arg6 = %arg4 to %0 step %c1 {
          %1 = memref.load %arg3[%arg6, %arg5] : memref<16x16xf32>
          %2 = arith.maximumf %1, %cst : f32
          memref.store %2, %arg3[%arg6, %arg5] : memref<16x16xf32>
          %3 = arith.addi %arg5, %c1 : index
          %4 = memref.load %arg3[%arg6, %3] : memref<16x16xf32>
          %5 = arith.maximumf %4, %cst : f32
          memref.store %5, %arg3[%arg6, %3] : memref<16x16xf32>
          %6 = arith.addi %arg5, %c2 : index
          %7 = memref.load %arg3[%arg6, %6] : memref<16x16xf32>
          %8 = arith.maximumf %7, %cst : f32
          memref.store %8, %arg3[%arg6, %6] : memref<16x16xf32>
          %9 = arith.addi %arg5, %c3 : index
          %10 = memref.load %arg3[%arg6, %9] : memref<16x16xf32>
          %11 = arith.maximumf %10, %cst : f32
          memref.store %11, %arg3[%arg6, %9] : memref<16x16xf32>
        }
      }
    }
    return
  }
}

