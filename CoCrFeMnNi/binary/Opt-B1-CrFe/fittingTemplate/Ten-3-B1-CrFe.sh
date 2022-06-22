#!/bin/sh
#sed_anchor01
#SBATCH --output=Ten-3-B1-CrFe.sout
#SBATCH --job-name=Ten-3-B1-CrFe
#SBATCH --nodes=1
#SBATCH --partition=24Cores


export LD_LIBRARY_PATH=/opt/mpich-3.4.2/lib:/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.2/bin:$PATH
#sed_anchor02
mpiexec /opt/QEGCC_MPICH3.4.2/bin/pw.x -in Ten-3-B1-CrFe.in




