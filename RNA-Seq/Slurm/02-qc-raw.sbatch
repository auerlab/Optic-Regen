#!/bin/sh -e

##########################################################################
#   Script description:
#       Run quality checks on raw and trimmed data for comparison
#       Based on work of Dr. Andrea Rau:
#       https://github.com/andreamrau/OpticRegen_2019
#
#       All necessary tools are assumed to be in PATH.  If this is not
#       the case, add whatever code is needed here to gain access.
#       (Adding such code to your .bashrc or other startup script is
#       generally a bad idea since it's too complicated to support
#       every program with one environment.)
#
#   History:
#   Date        Name        Modification
#   2019-09-13  Jason Bacon Begin
##########################################################################

# Set job array to number of samples
# Each invocation of this script will run 2 fastqc processes, forward
# and reverse
#SBATCH --array=1-15
#SBATCH --cpus-per-task=2
# Memory requirements can only be determined by trial and error.
# Run a sample job and monitor closely in "top" or rununder a tool that
# reports maximum memory use.
#SBATCH --mem=1g
#SBATCH --output=Logs/02-qc-raw/slurm-%A_%a.out
#SBATCH --error=Logs/02-qc-raw/slurm-%A_%a.err

# Set a default value for testing outside the SLURM environment
: ${SLURM_ARRAY_TASK_ID:=1}

# Document software versions used for publication
uname -a
fastqc --version
pwd

# Raw files from sequencing center
raw1=$(ls Results/Raw-renamed/*sample${SLURM_ARRAY_TASK_ID}-*R1*.fastq.gz)
raw2=$(ls Results/Raw-renamed/*sample${SLURM_ARRAY_TASK_ID}-*R2*.fastq.gz)

# Filename stems for fastqc output
stem_raw1=$(basename ${raw1%.fastq.gz})
stem_raw2=$(basename ${raw2%.fastq.gz})

# Background the first three to run 4 jobs in parallel
zcat $raw1 | fastqc -o Results/02-qc-raw stdin:$stem_raw1 &
zcat $raw2 | fastqc -o Results/02-qc-raw stdin:$stem_raw2

# Make sure backgrounded job completes before terminating script
wait
