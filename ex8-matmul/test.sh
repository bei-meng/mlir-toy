# Linalg 层算子级优化
# 命名算子泛化
# /home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
#     --mlir-print-ir-after-all \
#     --linalg-generalize-named-ops \
#     --linalg-fuse-elementwise-ops \
#     --linalg-fold-unit-extent-dims \
#     --canonicalize \
#     --cse\
#     step0.mlir > step1_linalg_optimized.mlir
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
    --linalg-fuse-elementwise-ops \
    --canonicalize \
    --cse\
    step0.mlir > step0_1.mlir
/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
    --linalg-generalize-named-ops \
    --canonicalize \
    --cse\
    step0_1.mlir > step0_2.mlir

/home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
    --linalg-fold-unit-extent-dims \
    --canonicalize \
    --cse\
    step0_2.mlir > step0_3.mlir


# # Linalg → Affine 降级
# /home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
#     --convert-linalg-to-affine-loops \
#     --affine-loop-normalize \
#     --canonicalize \
#     step1_linalg_optimized.mlir > step2_to_affine.mlir

# # Affine 层循环级优化
# /home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
#     --affine-loop-invariant-code-motion \
#     --affine-loop-fusion="mode=greedy" \
#     --affine-loop-tile="tile-sizes=4,4,4" \
#     --affine-loop-unroll="unroll-factor=4" \
#     --affine-scalrep \
#     --canonicalize \
#     --cse \
#     step2_to_affine.mlir > step3_affine_optimized.mlir

# # Affine → SCF 降级
# /home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
#     --lower-affine \
#     --canonicalize \
#     step3_affine_optimized.mlir > step4_to_scf.mlir

# # SCF 层控制流优化
# /home/ubuntu/mlir-tutorial/mlir-toy/build/toy-opt \
#     --scf-for-loop-canonicalization \
#     --scf-for-loop-peeling \
#     --scf-for-loop-range-folding \
#     --canonicalize \
#     --cse \
#     step4_to_scf.mlir > step5_scf_optimized.mlir

# # SCF → CF 降级
# ./toy-opt \
#     --convert-scf-to-cf \
#     --canonicalize \
#     step5_scf_optimized.mlir > step6_to_cf.mlir

# # CF → LLVM IR 最终降级
# ./toy-opt \
#     --finalize-memref-to-llvm \
#     --convert-arith-to-llvm \
#     --convert-func-to-llvm \
#     --convert-cf-to-llvm \
#     --canonicalize \
#     step6_to_cf.mlir > step7_to_llvm.mlir




