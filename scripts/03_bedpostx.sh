#!/usr/bin/env bash

# ==========================================
# 03_bedpostx.sh
# Multi-fiber orientation modeling with FSL BEDPOSTX
# ==========================================

set -e

# -----------------------------
# USER SETTINGS
# -----------------------------

# Input files
DWI_EC="dwi_ec.nii.gz"
MASK="mean_b0_brain_mask.nii.gz"
BVAL="your_dwi.bval"
BVEC="your_dwi.bvec"

# BEDPOSTX input folder name
BEDPOSTX_DIR="bedpostx_input"

# -----------------------------
# STEP 1: Create BEDPOSTX input folder
# -----------------------------
echo "Creating BEDPOSTX input folder..."

mkdir -p "${BEDPOSTX_DIR}"

# -----------------------------
# STEP 2: Copy files with FSL-required names
# -----------------------------
echo "Copying input files..."

cp "${DWI_EC}" "${BEDPOSTX_DIR}/data.nii.gz"
cp "${MASK}" "${BEDPOSTX_DIR}/nodif_brain_mask.nii.gz"
cp "${BVEC}" "${BEDPOSTX_DIR}/bvecs"
cp "${BVAL}" "${BEDPOSTX_DIR}/bvals"

# -----------------------------
# STEP 3: Run BEDPOSTX
# -----------------------------
echo "Running BEDPOSTX..."
bedpostx "${BEDPOSTX_DIR}"

echo "BEDPOSTX complete."

# -----------------------------
# OUTPUTS
# -----------------------------
echo "Output folder:"
echo " - ${BEDPOSTX_DIR}.bedpostX/"
echo ""
echo "Important outputs inside:"
echo " - merged* (fiber orientation samples)"
echo " - mean_* files"
echo " - dyads*"
