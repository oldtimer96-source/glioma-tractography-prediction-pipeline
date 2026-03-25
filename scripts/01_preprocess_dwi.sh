#!/usr/bin/env bash

# ==========================================
# 01_preprocess_dwi.sh
# Basic DWI preprocessing for FSL tractography
# ==========================================

set -e

# -----------------------------
# USER SETTINGS
# -----------------------------

# Input diffusion data
DWI="your_dwi.nii.gz"
BVAL="your_dwi.bval"
BVEC="your_dwi.bvec"

# Output prefix
OUT_PREFIX="dwi"

# Indices of b0 / near-b0 volumes
# Example: "0 17 26 35"
B0_INDICES=("0")

# BET fractional intensity threshold
BET_F="0.25"

# -----------------------------
# STEP 1: Eddy current + motion correction
# -----------------------------
echo "Running eddy correction..."
eddy_correct "${DWI}" "${OUT_PREFIX}_ec" 0

# -----------------------------
# STEP 2: Extract b0 / near-b0 volumes
# -----------------------------
echo "Extracting b0 / near-b0 volumes..."

COUNT=1
for IDX in "${B0_INDICES[@]}"; do
    fslroi "${OUT_PREFIX}_ec.nii.gz" "b0_${COUNT}" "${IDX}" 1
    COUNT=$((COUNT + 1))
done

# -----------------------------
# STEP 3: Average extracted b0 images
# -----------------------------
echo "Averaging b0 images..."

N_B0=${#B0_INDICES[@]}

if [ "${N_B0}" -eq 1 ]; then
    cp b0_1.nii.gz mean_b0.nii.gz
else
    CMD="fslmaths b0_1"
    for ((i=2; i<=N_B0; i++)); do
        CMD="${CMD} -add b0_${i}"
    done
    CMD="${CMD} -div ${N_B0} mean_b0"
    eval "${CMD}"
fi

# -----------------------------
# STEP 4: Brain extraction
# -----------------------------
echo "Running BET on mean_b0..."
bet mean_b0 mean_b0_brain -m -f "${BET_F}"

echo "Preprocessing complete."
echo "Outputs:"
echo " - ${OUT_PREFIX}_ec.nii.gz"
echo " - mean_b0.nii.gz"
echo " - mean_b0_brain.nii.gz"
echo " - mean_b0_brain_mask.nii.gz"
