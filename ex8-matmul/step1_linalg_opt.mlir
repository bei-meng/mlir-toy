#map = affine_map<(d0, d1) -> ()>
#map1 = affine_map<(d0, d1) -> (d0, d1)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d2)>
#map3 = affine_map<(d0, d1, d2) -> (d2, d1)>
#map4 = affine_map<(d0, d1, d2) -> (d0, d1)>
module {
  func.func @fc_relu(%arg0: memref<16x32xf32>, %arg1: memref<32x16xf32>, %arg2: memref<16x16xf32>, %arg3: memref<16x16xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "parallel"]} ins(%cst : f32) outs(%arg3 : memref<16x16xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    }
    linalg.generic {indexing_maps = [#map2, #map3, #map4], iterator_types = ["parallel", "parallel", "reduction"]} ins(%arg0, %arg1 : memref<16x32xf32>, memref<32x16xf32>) outs(%arg3 : memref<16x16xf32>) {
    ^bb0(%in: f32, %in_0: f32, %out: f32):
      %0 = arith.mulf %in, %in_0 : f32
      %1 = arith.addf %out, %0 : f32
      linalg.yield %1 : f32
    }
    linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg3, %arg2 : memref<16x16xf32>, memref<16x16xf32>) outs(%arg3 : memref<16x16xf32>) {
    ^bb0(%in: f32, %in_0: f32, %out: f32):
      %0 = arith.addf %in, %in_0 : f32
      linalg.yield %0 : f32
    }
    linalg.generic {indexing_maps = [#map1, #map, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg3, %cst : memref<16x16xf32>, f32) outs(%arg3 : memref<16x16xf32>) {
    ^bb0(%in: f32, %in_0: f32, %out: f32):
      %0 = arith.maximumf %in, %in_0 : f32
      linalg.yield %0 : f32
    }
    return
  }
}

