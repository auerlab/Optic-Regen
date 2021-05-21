#!/bin/sh -e

##########################################################################
#   Script description:
#       Generate index for BWA aligner
#
#   Usage:
#       sbatch 3-bwa-index.sbatch
#       ./3-bwa-index.sbatch |& tee 3.log
#
#   History:
#       Based on the work of Dr. Andrea Rau:
#       https://github.com/andreamrau/OpticRegen_2019
#   Date        Name        Modification
#   2020-02-10  Jason Bacon Begin
##########################################################################

##########################################################################
#   Main
##########################################################################

# SLURM parameters
#SBATCH --mem=3g
#SBATCH --output=Data/3-bwa-index/bwa-index-%j.out
#SBATCH --error=Data/3-bwa-index/bwa-index-%j.err

# Document software versions used for publication
uname -a > Data/3-bwa-index/os-version.txt 2>&1
bwa 2>&1 | fgrep Version > Data/3-bwa-index/bwa-version.txt || true

cd Data/3-bwa-index
ref_file=$(../../../Aux/ref-file-name.sh)
if [ ! -e $ref_file ]; then
    ../../../Aux/fetch-ref.sh
    ../../../Aux/concat-ref.sh
    bwa index $ref_file
fi
