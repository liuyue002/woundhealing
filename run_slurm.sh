#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --clusters=htc
#SBATCH --time=48:00:00
#SBATCH --job-name=6rDgk
#SBATCH --partition=long
#SBATCH --mail-user=yue.liu@maths.ox.ac.uk
#SBATCH --mail-type=END
module load MATLAB/R2020a
matlab -nodisplay -nosplash -r "param_iden_kevindata_xy6_rDgk;exit"
