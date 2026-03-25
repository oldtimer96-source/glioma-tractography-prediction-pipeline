#!/usr/bin/env bash

# ==========================================
# 02_dtifit.sh
# Diffusion tensor fitting using FSL
# ==========================================

set -e

# -----------------------------
# USER SETTINGS
# -----------------------------

# Input files (from preprocessing)
DWI_EC="dwi_ec.nii.gz"
MASK="mean_b0_brain_mask.nii.gz"

# Gradient files
BVAL="your_dwi.bval"
BVEC="your_dwi.bvec"

# Output prefix
OUT_PREFIX="dti"

# -----------------------------
# STEP 1: Run DTIFIT
# -----------------------------
echo "Running DTIFIT..."

dtifit \
  -k "${DWI_EC}" \
  -o "${OUT_PREFIX}" \
  -m "${MASK}" \
  -r "${BVEC}" \
  -b "${BVAL}"

echo "DTIFIT complete."

# -----------------------------
# OUTPUTS
# -----------------------------
echo "Outputs:"
echo " - ${OUT_PREFIX}_FA.nii.gz"
echo " - ${OUT_PREFIX}_MD.nii.gz"
echo " - ${OUT_PREFIX}_V1.nii.gz"
echo " - ${OUT_PREFIX}_L1/L2/L3.nii.gz"
