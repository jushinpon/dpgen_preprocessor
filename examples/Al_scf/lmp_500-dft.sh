#!/bin/sh
#sed_anchor01
#SBATCH --output=lmp_500-dft.sout
#SBATCH --job-name=lmp_500-dft
##SBATCH --nodes=1
##SBATCH --ntasks-per-node=8
#SBATCH --partition=debug
##SBATCH --exclude=node18,node20
export LD_LIBRARY_PATH=/opt/mpich-3.4.2/lib:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.2/bin:$PATH
export LD_LIBRARY_PATH=/opt/intel/compilers_and_libraries_2018.0.128/linux/mkl/lib/intel64_lin:$LD_LIBRARY_PATH
#export PATH=/opt/mpich-3.4.2/bin:$PATH
#mpiexec_anchor
mpiexec /opt/QEGCC_MPICH3.4.2/bin/pw.x -in /home/jsp/Al/Perl4dpgen/DFT_output/T1150-P0-R6000-Al-12345/lmp_500/lmp_500-dft.in
echo "Done" > dft_done.txt
