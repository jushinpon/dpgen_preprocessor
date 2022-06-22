#!/bin/sh
#sed_anchor01
#SBATCH --output=Com-3-B1-FeNi.sout
#SBATCH --job-name=Com-3-B1-FeNi
#SBATCH --nodes=1
#SBATCH --partition=24Cores


export LD_LIBRARY_PATH=/opt/mpich-3.4.2/lib:/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.2/bin:$PATH
#sed_anchor02
mpiexec /opt/QEGCC_MPICH3.4.2/bin/pw.x -in Com-3-B1-FeNi.in




