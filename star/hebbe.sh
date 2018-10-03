#!/bin/bash
#SBATCH -J <JOBNAME>
#SBATCH -p hebbe
#SBATCH -N<NODES> -n<NODES*20>
#SBATCH -e error_file.e%J
#SBATCH -o output_file.o%J
#SBATCH -A <ALLOCATION>
#SBATCH -t 168:00:00

hostlist --expand --append=":8" $SLURM_JOB_NODELIST > nodes
NCPU=$SLURM_NTASKS

module load starccm+/13.04.010

export MYCASE=$(find *.sim)

export MYJAVA="<BATCHFILE>"

export LM_PROJECT="<POD-KEY>"
export LM_LICENSE_FILE=1999@flex.cd-adapco.com

echo "Starting the job script..."
starccm+ -collab -np $NCPU -power -rsh ssh -podkey $LM_PROJECT -batch $MYJAVA -machinefile nodes ${MYCASE} >> $(basename ${MYCASE} .sim).log 2>&1

echo "End of script."
