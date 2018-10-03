#!/bin/bash -l
#SBATCH -J <JOBNAME>
#SBATCH -N<NODES> -n<NODES*28>
#SBATCH -A <ALLOCATION>
#SBATCH --mail-type=ALL
#SBATCH -e error_file.e%J
#SBATCH -o output_file.o%J
#SBATCH -t 20:00:00

# Get the allocated nodes
hostlist --expand --append=" $SLURM_CPUS_ON_NODE" $SLURM_JOB_NODELIST | awk '{i=1;while (i<=$2) {print($1); i++} i=1}' > nodes
NCPU=$SLURM_NTASKS

LETTER=`echo $USER | cut -c1`
BINARY=/pfs/nobackup/home/$LETTER/$USER/star1304010/13.04.010/STAR-CCM+13.04.010/star/bin/starccm+
LUSTRE_ROOT=/pfs/nobackup/home/$LETTER/$USER/StarCCM_config

export sim_file=$(find *.sim)
export MYJAVA="<BATCHFILE>"

export LM_PROJECT="<POD-KEY>"
export LM_LICENSE_FILE=1999@flex.cd-adapco.com

# Node 631 is not behaving, so don't use it.
if grep -q "b-cn0631" nodes
then
	echo "Node b-cn0631 detected! Removing it from the node list."
	sed -i /0631/d nodes
	NCPU=$(($NCPU-28))
fi

$BINARY -collab -mpi intel -mpiflags "-bootstrap slurm" -np $NCPU -power -batch $MYJAVA -nbuserdir $LUSTRE_ROOT -machinefile nodes ${sim_file} >> $(basename ${sim_file} .sim).log 2>&1

rm nodes
