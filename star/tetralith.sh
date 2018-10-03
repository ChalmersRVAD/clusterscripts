#!/bin/bash
#SBATCH -J <JOBNAME>
#SBATCH -N <NODES> -n <NODES*32>
#SBATCH -A <ALLOCATION>
#SBATCH -t 20:00:00

NODEFILE=hostlist.$SLURM_JOB_ID
hostlist -e $SLURM_JOB_NODELIST > $NODEFILE

module load star-ccm+/13.04.010

export MYCASE=$(find *.sim)

export MYJAVA="<BATCHFILE>"

export LM_PROJECT="POD-KEY"
export LM_LICENSE_FILE=1999@flex.cd-adapco.com

echo $SLURM_NTASKS

starccm+ -collab -power -mpi intel -mpiflags "-bootstrap slurm" -fabric psm2 -rsh jobsh -batch $MYJAVA -np $SLURM_NTASKS -machinefile $NODEFILE $MYCASE > $(basename $MYCASE .sim).log 

rm $NODEFILE
