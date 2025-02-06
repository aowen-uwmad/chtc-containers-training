#!/bin/bash

#SBATCH --partition=int,shared,pre
#SBATCH --time=0-01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=4000
#SBATCH --error=regular.err
#SBATCH --output=regular.out

srun ./version.sh python3

