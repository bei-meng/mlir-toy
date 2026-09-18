module {
  // 全连接层：Y = ReLU(X × W + B)
  // 尺寸：X[16,32] × W[32,16] + B[16,16] = Y[16,16]
  func.func @fc_relu(%X: memref<16x32xf32>, 
                     %W: memref<32x16xf32>, 
                     %B: memref<16x16xf32>,
                     %Y: memref<16x16xf32>) {
    %c0 = arith.constant 0.0 : f32
    
    // 初始化输出
    linalg.fill ins(%c0 : f32) outs(%Y : memref<16x16xf32>)
    
    // 矩阵乘法
    linalg.matmul 
      ins(%X, %W : memref<16x32xf32>, memref<32x16xf32>)
      outs(%Y : memref<16x16xf32>)
    
    // 加偏置
    linalg.add 
      ins(%Y, %B : memref<16x16xf32>, memref<16x16xf32>)
      outs(%Y : memref<16x16xf32>)
    
    // ReLU 激活
    linalg.max 
      ins(%Y, %c0 : memref<16x16xf32>, f32)
      outs(%Y : memref<16x16xf32>)
    
    return
  }
}
