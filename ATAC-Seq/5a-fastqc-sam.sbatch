#!/bin/sh -e

##########################################################################
#   Script description:
#       QC BWA alignments
#
#   Usage:
#       SLURM cluster:
#           sbatch 5-qc.sbatch
#       No cluster:
#           ../slurm-sim 5-qc.sbatch |& tee 5.log
#
#   History:
#       Based on the work of Dr. Andrea Rau:
#       https://github.com/andreamrau/OpticRegen_2019
#   Date        Name        Modification
#   2020-02-25  Jason Bacon Begin
##########################################################################

##########################################################################
#   Main
##########################################################################

# SLURM parameters
#SBATCH --array=1-14
# FIXME: Check actual memory use
#SBATCH --mem=1g
#SBATCH --output=Data/5-qc-sam/slurm-%A_%a.out
#SBATCH --error=Data/5-qc-sam/slurm-%A_%a.err

# For test runs outside SLURM
: ${SLURM_ARRAY_TASK_ID:=1}
export SLURM_ARRAY_TASK_ID
. ./my-sample

# Document software versions used for publication
if [ $SLURM_ARRAY_TASK_ID = 1 ]; then
    uname -a > Data/5-qc-sam/os-version.txt 2>&1
    fastqc --version > Data/5-qc-sam/fastqc-version.txt 2>&1
fi

# Set my_sample based on SLURM_ARRAY_TASK_ID
infile=Data/4-bwa-mem/$my_sample.sam
printf "Processing $infile...\n"
fastqc $infile -o Data/5-qc-sam
