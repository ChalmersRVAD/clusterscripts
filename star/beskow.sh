#!/bin/bash -l
#SBATCH -J <JOBNAME>
#SBATCH -N<NODES> -n<NODES*32>
#SBATCH -A <ALLOCATION>
#SBATCH --mail-type=ALL
#SBATCH -e error_file.e%J
#SBATCH -o output_file.o%J
#SBATCH -t 01:00:00

NCPU=$SLURM_NTASKS

# Load the correct environment
module unload PrgEnv-cray 
module unload PrgEnv-gnu
module unload PrgEnv-intel
module load PrgEnv-gnu

module load starccm+/13.04.010-sp

# Set the temporary path
LETTER=`echo $USER | cut -c1`
LUSTRE_ROOT=/cfs/klemming/nobackup/$LETTER/$USER/StarCCM_config
export TMPDIR=/cfs/klemming/nobackup/$LETTER/$USER

export sim_file=$(find *.sim)
export MYJAVA="<BATCHFILE>"

export LM_PROJECT="<POD-KEY>"
export LM_LICENSE_FILE=1999@flex.cd-adapco.com

starccm+ -collab -mpidriver crayxt -power -pio -batch $MYJAVA -np $NCPU -arch linux-x86_64-2.5 -nbuserdir $LUSTRE_ROOT ${sim_file} >> $(basename ${sim_file} .sim).log 2>&1
