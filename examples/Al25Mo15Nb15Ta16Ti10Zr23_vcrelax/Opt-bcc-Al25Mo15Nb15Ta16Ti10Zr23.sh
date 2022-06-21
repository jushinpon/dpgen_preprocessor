#!/bin/sh
#sed_anchor01
#SBATCH --output=Opt-bcc-Al25Mo15Nb15Ta16Ti10Zr23.sout
#SBATCH --job-name=Opt-bcc-Al25Mo15Nb15Ta16Ti10Zr23
#SBATCH --nodes=1
#SBATCH --partition=24Cores

export LD_LIBRARY_PATH=/opt/mpich-3.4.2/lib:/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.2/bin:$PATH
#sed_anchor02
mpiexec /opt/QEGCC_MPICH3.4.2/bin/pw.x -in Opt-bcc-Al25Mo15Nb15Ta16Ti10Zr23.in




