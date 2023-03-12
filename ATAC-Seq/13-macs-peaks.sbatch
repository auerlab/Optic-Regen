#!/bin/sh -e

##########################################################################
#   Script description:
#       Call peaks in alignments PE ATAC-seq aligned (BWA) reads
#
#   History:
#       Based on the work of Dr. Andrea Rau:
#       https://github.com/andreamrau/OpticRegen_2019
#   Date        Name        Modification
#   2020-03-10  Jason Bacon Begin
##########################################################################

##########################################################################
#   Main
##########################################################################

#SBATCH --mem=4g
#SBATCH --output=Logs/13-macs-peaks/slurm-%A_%a.out
#SBATCH --error=Logs/13-macs-peaks/slurm-%A_%a.err

# Document software versions used for publication
uname -a
macs2 --version
pwd

printf "Peak calling, merging replicates across all time points, calling peaks...\n"
# "mm" is the compiled-in Mus Musculus genome size.  See MACS2 docs.
# BAMPE = BAM Paired End
# Would it make any difference to use the merged BAMs instead?
# FIXME: 1.37e09 is from Andrea's previous run.  How do we get this value
# for the latest build?  Nothing in MACS2 docs about it.
set -x
macs2 callpeak --nomodel \
    -t Results/09-remove-duplicates/*-mapq1.bam \
    -f BAMPE -g 1.37e+09 --call-summits -n ATAC \
    --keep-dup all --outdir Results/13-macs-peaks
