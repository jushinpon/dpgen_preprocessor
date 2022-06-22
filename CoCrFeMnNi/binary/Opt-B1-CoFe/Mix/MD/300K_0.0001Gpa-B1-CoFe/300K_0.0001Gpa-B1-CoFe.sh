#!/bin/sh
#sed_anchor01
#SBATCH --output=300K_0.0001Gpa-B1-CoFe.sout
#SBATCH --job-name=300K_0.0001Gpa-B1-CoFe
#SBATCH --nodes=1
#SBATCH --partition=GPU_nodes


export LD_LIBRARY_PATH=/opt/mpich-3.4.2/lib:/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.2/bin:$PATH
#sed_anchor02
mpiexec /opt/QEGCC_MPICH3.4.2/bin/pw.x -in /home/kevin/QE_CoCrFeMnNi/CoCrFeMnNi/Opt/binary/Opt-B1-CoFe/Mix/MD/300K_0.0001Gpa-B1-CoFe/300K_0.0001Gpa-B1-CoFe.in




