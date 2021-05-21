#!/bin/sh -e

##########################################################################
#   Script description:
#       Run quality checks on raw and trimmed data for comparison
#
#   Usage:
#       SLURM cluster:
#           sbatch 2a-fastqc.sbatch
#       No cluster:
#           slurm-sim 2a-fastqc.sbatch |& tee 2.log
#
#   History:
#       Based on work of Dr. Andrea Rau:
#       https://github.com/andreamrau/OpticRegen_2019
#   Date        Name        Modification
#   2020-02-05  Jason Bacon Begin
##########################################################################

##########################################################################
#   Main
##########################################################################

# SLURM parameters
# --cpus-per-task is not ideal.  It requires all cores on the same node,
# where we really need 2 pairs.
#SBATCH --array=1-14 --cpus-per-task=4
#SBATCH --mem=1g
#SBATCH --output=Data/2-qc/fastqc-%A_%a.out
#SBATCH --error=Data/2-qc/fastqc-%A_%a.err

# SLURM will set SLURM_ARRAY_TASK_ID to one of the values in --array above.
# If not running on a SLURM cluster, loop through all the values by spoofing
# SLURM_ARRAY_TASK_ID to the entire list.  Make sure these variables agree
# with the #SBATCH directives above and cutadapt command flags below.
# To run specific samples, set these variables before running the script,
# e.g.
#
#   env SLURM_ARRAY_TASK_ID='1 5' ./2-qc.sbatch

# Default if not set by SLURM or user
: ${SLURM_ARRAY_TASK_ID:=1}
: ${SLURM_CPUS_PER_TASK:=2}

samples="0ATAC-1 0ATAC-2 0ATAC-3 12ATAC-1 12ATAC-2 12ATAC-3 2ATAC-1 2ATAC-2 2ATAC-3 4ATAC-1 4ATAC-2 4ATAC-3 7ATAC-2 7ATAC-3"
my_sample=$(printf "$samples\n" | cut -d ' ' -f ${SLURM_ARRAY_TASK_ID})

# Document software versions used for publication
if [ $SLURM_ARRAY_TASK_ID = 1 ]; then
    uname -a > Data/2-qc/os-version.txt 2>&1
    fastqc --version > Data/2-qc/fastqc-version.txt 2>&1
fi

mkdir -p Data/2-qc/Raw Data/2-qc/Trimmed

# One iteration if running under SLURM, all iterations otherwise
printf "Task $SLURM_ARRAY_TASK_ID running $my_sample on $(hostname)...\n"

# Raw files from sequencing center
raw1="../Raw/BCAUAGANXX/Merged-lanes/${my_sample}-R1.fastq.gz"
raw2="../Raw/BCAUAGANXX/Merged-lanes/${my_sample}-R2.fastq.gz"

# Cutadapt output
trimmed1="Data/1-trim/${my_sample}-R1.fastq.gz"
trimmed2="Data/1-trim/${my_sample}-R2.fastq.gz"

# Trimgalore
# trimmed1="Data/1-trim/${my_sample}-R1_val_1.fq.gz"
# trimmed2="Data/1-trim/${my_sample}-R2_val_2.fq.gz"

# Background the first so we can use 4 cores per job
fastqc --threads=2 $raw1 $raw2 -o Data/2-qc/Raw &
fastqc --threads=2 $trimmed1 $trimmed2 -o Data/2-qc/Trimmed
