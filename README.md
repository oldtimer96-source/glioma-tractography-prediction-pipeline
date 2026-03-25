# Glioma Tractography Pipeline (FSL)

This repository contains a step-by-step **diffusion MRI / probabilistic tractography pipeline in FSL**, designed for:

1. **training and method development** on open-source diffusion MRI data, and  
2. adaptation to **glioma / tumor-seeded probabilistic tractography** workflows.

The workflow is inspired by:

**Kis et al. (2022)**  
*Predicting the true extent of glioblastoma based on probabilistic tractography*  
Frontiers in Neuroscience. DOI: 10.3389/fnins.2022.886465

---

## Project goals

- preprocess diffusion MRI data
- estimate diffusion tensors
- model multiple fiber orientations with uncertainty
- generate probabilistic tractography
- register a tumor mask from T1 space to diffusion space
- run tumor-seeded tractography
- visualize and threshold tumor connection maps

---

## Recommended pipeline levels

### Minimal version
- `dcm2bids` *(or use already-BIDS data)*
- eddy correction
- b0 extraction
- BET
- DTIFIT
- BEDPOSTX
- PROBTRACKX

### Recommended version
- `dcm2bids`
- **TOPUP** *(if AP/PA reverse phase-encoding is available)*
- **EDDY**
- b0 extraction
- BET
- DTIFIT
- BEDPOSTX
- FLIRT registration
- tumor mask transfer to diffusion space
- PROBTRACKX
- thresholding and visualization

---

## Input data

### Diffusion MRI
- `sub-XX_dwi.nii.gz`
- `sub-XX_dwi.bval`
- `sub-XX_dwi.bvec`

### Anatomical MRI
- `sub-XX_T1w.nii.gz`

### Optional masks
- tumor mask

---

## BIDS and DICOM conversion

### If data are already in BIDS
Skip conversion and start from preprocessing.

### If data start as DICOM
Use **`dcm2bids`** to organize data into BIDS format.  
`dcm2bids` uses **`dcm2niix` internally**, so you generally do **not** run `dcm2niix` separately unless you want to inspect series names and metadata before writing the config file.

Example:

```bash
dcm2bids -d /path/to/DICOM -p sub-01 -c config.json -o /path/to/BIDS_dataset
