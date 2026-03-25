#!/usr/bin/env bash

# ==========================================
# 05_probtrackx_tumor.sh
# Tumor-seeded probabilistic tractography
# using FSL PROBTRACKX2
# ==========================================

set -e

# -----------------------------
# USER SETTINGS
# -----------------------------

# Tumor seed mask in diffusion space
SEED_MASK="tumor_mask_DWI.nii.gz"

# BEDPOSTX output directory
BEDPOSTX_DIR="bedpostx_input.bedpostX"

# Brain mask in diffusion space
BRAIN_MASK="${BEDPOSTX_DIR}/nodif_brain_mask.nii.gz"

# Output directory
OUT_DIR="probtrackx_tumor"

# Tractography parameters
N_SAMPLES="5000"
N_STEPS="2000"
STEP_LENGTH="0.5"
CURVATURE="0.2"

# -----------------------------
# STEP 1: Run PROBTRACKX2
# -----------------------------
echo "Running tumor-seeded probabilistic tractography..."

probtrackx2 \
  -x "${SEED_MASK}" \
  -l \
  --onewaycondition \
  -c "${CURVATURE}" \
  -S "${N_STEPS}" \
  --steplength="${STEP_LENGTH}" \
  -P "${N_SAMPLES}" \
  --opd \
  -s "${BEDPOSTX_DIR}/merged" \
  -m "${BRAIN_MASK}" \
  --dir="${OUT_DIR}"

echo "PROBTRACKX2 complete."

# -----------------------------
# OUTPUTS
# -----------------------------
echo "Outputs:"
echo " - ${OUT_DIR}/fdt_paths.nii.gz"
echo " - ${OUT_DIR}/waytotal"
echo " - ${OUT_DIR}/probtrackx.log"
