#!/bin/sh
#SBATCH --output=Al2ZnO4_mp-34210.sout
#SBATCH --job-name=job10
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --partition=C16M32
###SBATCH --exclude=node22,node24
export LD_LIBRARY_PATH=/opt/mpich-4.0.3/lib:$LD_LIBRARY_PATH
export PATH=/opt/mpich-4.0.3/bin:$PATH
export LD_LIBRARY_PATH=/opt/intel/compilers_and_libraries_2018.0.128/linux/mkl/lib/intel64_lin:$LD_LIBRARY_PATH

/opt/mpich-4.0.3/bin/mpiexec /opt/QEGCC_MPICH4.0.3-cp/bin/pw.x -in Al2ZnO4_mp-34210.in

