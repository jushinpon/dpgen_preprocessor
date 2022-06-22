#!/bin/sh
#sed_anchor01
#SBATCH --output=Chg_1-B1-FeMn.sout
#SBATCH --job-name=Chg_1-B1-FeMn
#SBATCH --nodes=1
#SBATCH --partition=24Cores
#SBATCH --exclude=node09

export LD_LIBRARY_PATH=/opt/mpich-3.4.2/lib:/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.2/bin:$PATH
#sed_anchor02
mpiexec /opt/QEGCC_MPICH3.4.2/bin/pw.x -in /home/kevin/QE_CoCrFeMnNi/CoCrFeMnNi/Opt/binary/Opt-B1-FeMn/Mix/elastic/Chg_1-B1-FeMn.in




