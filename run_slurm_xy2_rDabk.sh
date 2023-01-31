#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --clusters=htc
#SBATCH --time=144:00:00
#SBATCH --job-name=2rDabk
#SBATCH --partition=long
#SBATCH --mail-user=yue.liu@maths.ox.ac.uk
#SBATCH --mail-type=END
module load MATLAB/R2020a
mkdir -p /home/wolf5640/woundhealing/tmp/$SLURM_JOB_ID
matlab -nodisplay -nosplash -r "param_iden_kevindata_xy2_rDabk;exit"
rm -rf /home/wolf5640/woundhealing/tmp/$SLURM_JOB_ID
