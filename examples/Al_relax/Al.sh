#!/bin/sh
#sed_anchor01
#SBATCH --output=Opt-fcc-Al.sout
#SBATCH --job-name=Opt-fcc-Al
#SBATCH --nodes=1
#SBATCH --partition=IB


export LD_LIBRARY_PATH=/opt/mpich-3.4.2/lib:/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.2/bin:$PATH
#sed_anchor02
mpiexec /opt/QEGCC_MPICH3.4.2/bin/pw.x -in Opt-fcc-Al.in




