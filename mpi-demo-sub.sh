#!/bin/bash 
#SBATCH --job-name="singularity_python_test" 
#SBATCH --output="singularity_python_test.%j.out" 
#SBATCH --error="singularity_python_test.%j.err" 
#SBATCH --nodes=2 
#SBATCH --ntasks-per-node=24 
#SBATCH --time=00:05:00 
#SBATCH --export=all 
#SBATCH --partition=debug

module load mvapich2_ib singularity

CONTAINER=/cvmfs/singularity.opensciencegrid.org/sugwg/dbrown\:latest

mpirun singularity exec --home /home/dabrown/pycbc_test:/srv --pwd /srv --bind /cvmfs --bind /tmp ${CONTAINER} /srv/mpi-demo-wrapper.sh
