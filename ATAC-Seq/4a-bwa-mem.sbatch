#!/bin/sh -e

##########################################################################
#   Script description:
#       Align reads to reference genome
#
#   Usage:
#       SLURM cluster:
#           sbatch 4-bwa-mem.sbatch
#       No cluster:
#           [env SLURM_CPUS_PER_TASK=n] \
#               ../slurm-sim 4-bwa-mem.sbatch |& tee 4.log
#
#   History:
#       Based on the work of Dr. Andrea Rau:
#       https://github.com/andreamrau/OpticRegen_2019
#   Date        Name        Modification
#   2020-02-20  Jason Bacon Begin
##########################################################################

##########################################################################
#   Main
##########################################################################

# SLURM parameters
# Not yet sure how many threads are useful.  Maybe use --exclusive and all
# available cores? Smaller thread counts are usually more efficient as
# they will require less communication overhead.  If cores are limited,
# this will get the job done faster.
#SBATCH --array=1-14 --cpus-per-task=4
# Based on 2 threads on Albacore cluster
# 12 threads on Peregrine used close to 6g
#SBATCH --mem=5g
#SBATCH --output=Data/4-bwa-mem/bwa-mem-%A_%a.out
#SBATCH --error=Data/4-bwa-mem/bwa-mem-%A_%a.err

# Defaults if not set by SLURM or user
: ${SLURM_ARRAY_TASK_ID:=1}
export SLURM_ARRAY_TASK_ID
. ./my-sample

: ${SLURM_CPUS_PER_TASK:=4}

# Document software versions used for publication
if [ $SLURM_ARRAY_TASK_ID = 1 ]; then
    uname -a > Data/4-bwa-mem/os-version.txt 2>&1
    bwa 2>&1 | fgrep Version > Data/4-bwa-mem/bwa-version.txt || true
fi

# One iteration if running under SLURM, all iterations otherwise
cd Data/4-bwa-mem

samples="0ATAC-1 0ATAC-2 0ATAC-3 12ATAC-1 12ATAC-2 12ATAC-3 2ATAC-1 2ATAC-2 2ATAC-3 4ATAC-1 4ATAC-2 4ATAC-3 7ATAC-2 7ATAC-3"
my_sample=$(printf "$samples\n" | cut -d ' ' -f ${SLURM_ARRAY_TASK_ID})
printf "Task $SLURM_ARRAY_TASK_ID running $my_sample on $(hostname)...\n"

infile1=../1-trim/${my_sample}-R1.fastq.gz
infile2=../1-trim/${my_sample}-R2.fastq.gz
outfile=$(echo $infile1 | cut -d / -f 3 | sed -e 's|-R1.fastq.gz|.sam|')
ref_file=$(../../../Aux/ref-file-name.sh)

set -x
srun bwa mem -M -t $SLURM_CPUS_PER_TASK \
    ../3-bwa-index/$ref_file $infile1 $infile2 > $outfile
