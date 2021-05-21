#!/bin/sh -e

##########################################################################
#   Script description:
#       Trim adapters and low quality ends from Lumina reads
#
#   Usage:
#       SLURM Cluster:
#           sbatch 1-trim.sbatch
#       No cluster:
#           ../slurm-sim 1-trim.sbatch |& tee 1.log
#
#   History:
#       Based on the work of Dr. Andrea Rau:
#       https://github.com/andreamrau/OpticRegen_2019
#   Date        Name        Modification
#   2020-02-02  Jason Bacon Begin
##########################################################################

##########################################################################
#   Main
##########################################################################

# 2 cores per task to accommodate pigz
# We don't get full utilization of both cores, but this speeds up the
# job somewhat.  If you prefer to maximize CPU utilization, set
# cpus-per-task to 1.
#SBATCH --array=1-14 --cpus-per-task=2
#SBATCH --mem-per-cpu=300
#SBATCH --output=Data/1-trim/1b-trim-%A_%a.out
#SBATCH --error=Data/1-trim/1b-trim-%A_%a.err

samples="0ATAC-1 0ATAC-2 0ATAC-3 12ATAC-1 12ATAC-2 12ATAC-3 2ATAC-1 2ATAC-2 2ATAC-3 4ATAC-1 4ATAC-2 4ATAC-3 7ATAC-2 7ATAC-3"

: ${SLURM_ARRAY_TASK_ID:=4}
my_sample=$(printf "$samples\n" | cut -d ' ' -f ${SLURM_ARRAY_TASK_ID})

# Defaults if not set by SLURM or user
: ${SLURM_CPUS_PER_TASK:=2}

# Document software versions used for publication
if [ $SLURM_ARRAY_TASK_ID = 1 ]; then
    uname -a > Data/1-trim/os-version.txt 2>&1
    cutadapt --version > Data/1-trim/cutadapt-version.txt 2>&1
fi

# One iteration if running under SLURM, all iterations otherwise
printf "Task $SLURM_ARRAY_TASK_ID processing $my_sample...\n"

# xz is not supported by fastqc as of 0.11.9.
input1="../Raw/BCAUAGANXX/Merged-lanes/${my_sample}-R1.fastq.gz"
input2="../Raw/BCAUAGANXX/Merged-lanes/${my_sample}-R2.fastq.gz"

# TrimGalore cannot cut a fixed number of bases while trimming adapters.
# We want to remove bases at 5' end due to bias and last base at 3' end

# Andrea's code
# Trimgalore doesn't detect the correct adapter
# trim_galore --illumina --stringency 3 -q 20 --paired -o Data/1-trim \
#    $input1 $input2 # > Data/1-trim/${stem}-trash.out
# trim_galore --illumina --stringency 3 -q 20 --paired --trim1 -o 1-trim-trim1 \
#    $input1 $input2 > Data/1-trim-trim1/${stem}-trash.out

# From trim_galore log:
#   cutadapt -j 1 -e 0.1 -q 20 -O 3 -a AGATCGGAAGAGC
# -j 1 -O 3 -e 0.1 are defaults for cutadapt

# ATAC-Seq adapter: https://www.biostars.org/p/367067/
# This appears at the 3' end of many reads and is not removed by trimgalore
adapter=CTGTCTCTTATACACATCT

# Strong bias in first ~15 bases.  Probably restriction enzyme bias selecting
# cleavage sites in a non-random way.  Not an issue with read quality.
# -u +15 -U +15
# Not sure about min length for ATAC
# Need 2 cores for each cutadapt process to accommodate pigz/xzip

cutadapt \
    --cores=$SLURM_CPUS_PER_TASK \
    --quality-cutoff=24 \
    -u -3 -U -3 \
    -a $adapter -A $adapter \
    --minimum-length=20 \
    --output=Data/1-trim/${my_sample}-R1.fastq.gz \
    --paired-output=Data/1-trim/${my_sample}-R2.fastq.gz \
    $input1 $input2
