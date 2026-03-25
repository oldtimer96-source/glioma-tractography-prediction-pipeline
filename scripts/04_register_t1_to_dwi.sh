#!/usr/bin/env bash

# ==========================================
# 04_register_t1_to_dwi.sh
# Register T1 anatomy to diffusion space and
# transform tumor mask into diffusion space
# ==========================================

set -e

# -----------------------------
# USER SETTINGS
# -----------------------------

# Input anatomical image (T1 space)
T1_IMAGE="your_T1w.nii.gz"

# Input tumor mask drawn in T1 space
TUMOR_MASK_T1="tumor_mask_T1.nii.gz"

# Diffusion-space reference image
DWI_REF="mean_b0_brain.nii.gz"

# Output names
T1_TO_DWI_OUT="T1_to_DWI.nii.gz"
T1_TO_DWI_MAT="T1_to_DWI.mat"
TUMOR_MASK_DWI="tumor_mask_DWI.nii.gz"

# Registration parameters
DOF="6"
COST="mutualinfo"

# -----------------------------
# STEP 1: Register T1 to DWI space
# -----------------------------
echo "Registering T1 to diffusion space..."

flirt \
  -in "${T1_IMAGE}" \
  -ref "${DWI_REF}" \
  -out "${T1_TO_DWI_OUT}" \
  -omat "${T1_TO_DWI_MAT}" \
  -dof "${DOF}" \
  -cost "${COST}"

# -----------------------------
# STEP 2: Transform tumor mask into DWI space
# -----------------------------
echo "Transforming tumor mask into diffusion space..."

flirt \
  -in "${TUMOR_MASK_T1}" \
  -ref "${DWI_REF}" \
  -applyxfm \
  -init "${T1_TO_DWI_MAT}" \
  -out "${TUMOR_MASK_DWI}" \
  -interp nearestneighbour

echo "Registration complete."

# -----------------------------
# OUTPUTS
# -----------------------------
echo "Outputs:"
echo " - ${T1_TO_DWI_OUT}"
echo " - ${T1_TO_DWI_MAT}"
echo " - ${TUMOR_MASK_DWI}"
