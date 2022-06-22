#!/bin/sh
#sed_anchor01
#SBATCH --output=Com-5-B1-CrMn.sout
#SBATCH --job-name=Com-5-B1-CrMn
#SBATCH --nodes=1
#SBATCH --partition=24Cores


export LD_LIBRARY_PATH=/opt/mpich-3.4.2/lib:/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.2/bin:$PATH
#sed_anchor02
mpiexec /opt/QEGCC_MPICH3.4.2/bin/pw.x -in Com-5-B1-CrMn.in




