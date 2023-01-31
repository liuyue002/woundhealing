#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --clusters=htc
#SBATCH --time=48:00:00
#SBATCH --job-name=bi_rDgk_rD
#SBATCH --partition=medium
#SBATCH --mail-user=yue.liu@maths.ox.ac.uk
#SBATCH --mail-type=END
module load MATLAB/R2020a
mkdir -p /home/wolf5640/woundhealing/tmp/$SLURM_JOB_ID
matlab -nodisplay -nosplash -r "param_iden_kevindata_radial_bivariate_xy1_rDgk_rD;exit"
rm -rf /home/wolf5640/woundhealing/tmp/$SLURM_JOB_ID
