#!/bin/bash

#SBATCH --partition=int,shared,pre
#SBATCH --time=0-01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=4000
#SBATCH --error=container.err
#SBATCH --output=container.out

export TMPDIR=/scratch/$USER/apptainer_tmp/${SLURM_JOB_ID}
mkdir -p $TMPDIR

container_image="/software/chtc/containers/ubuntu/22.04/ubuntu-22.04_openmpi-5.0.sif"

srun apptainer exec \
    --bind /home/$USER \
    --bind /scratch/$USER \
    --bind $TMPDIR \
    ${container_image} \
    ./version.sh python3

rm -rf $TMPDIR


