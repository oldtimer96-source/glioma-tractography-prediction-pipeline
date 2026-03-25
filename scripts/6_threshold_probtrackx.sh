#!/usr/bin/env bash

# ==========================================
# 06_threshold_probtrackx.sh
# Threshold probabilistic tractography outputs
# ==========================================

set -e

# -----------------------------
# USER SETTINGS
# -----------------------------

# Input tractography file
TRACT="probtrackx_tumor/fdt_paths.nii.gz"

# Output prefix
OUT_PREFIX="probtrackx_tumor/fdt_paths"

# Absolute threshold for quick visualization
ABS_THR="5"

# Percentage threshold of the maximum value
# Example: 5 means 5%
PERCENT_THR="5"

# Binary output? (true/false)
MAKE_BINARY="true"

# -----------------------------
# STEP 1: Absolute threshold
# -----------------------------
echo "Applying absolute threshold: ${ABS_THR}"

if [ "${MAKE_BINARY}" = "true" ]; then
    fslmaths "${TRACT}" -thr "${ABS_THR}" -bin "${OUT_PREFIX}_thr${ABS_THR}_abs_bin.nii.gz"
else
    fslmaths "${TRACT}" -thr "${ABS_THR}" "${OUT_PREFIX}_thr${ABS_THR}_abs.nii.gz"
fi

# -----------------------------
# STEP 2: Percentage-of-maximum threshold
# -----------------------------
echo "Computing maximum value in tract..."

MAXVAL=$(fslstats "${TRACT}" -R | awk '{print $2}')
echo "Maximum value: ${MAXVAL}"

THR=$(python3 -c "print(${MAXVAL} * (${PERCENT_THR}/100.0))")
echo "Computed ${PERCENT_THR}% threshold: ${THR}"

if [ "${MAKE_BINARY}" = "true" ]; then
    fslmaths "${TRACT}" -thr "${THR}" -bin "${OUT_PREFIX}_thr${PERCENT_THR}pct_bin.nii.gz"
else
    fslmaths "${TRACT}" -thr "${THR}" "${OUT_PREFIX}_thr${PERCENT_THR}pct.nii.gz"
fi

echo "Thresholding complete."

# -----------------------------
# OUTPUTS
# -----------------------------
echo "Outputs:"
if [ "${MAKE_BINARY}" = "true" ]; then
    echo " - ${OUT_PREFIX}_thr${ABS_THR}_abs_bin.nii.gz"
    echo " - ${OUT_PREFIX}_thr${PERCENT_THR}pct_bin.nii.gz"
else
    echo " - ${OUT_PREFIX}_thr${ABS_THR}_abs.nii.gz"
    echo " - ${OUT_PREFIX}_thr${PERCENT_THR}pct.nii.gz"
fi
