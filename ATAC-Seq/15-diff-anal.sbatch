#!/bin/sh -e

##########################################################################
#   Script description:
#       Find differential accessibility across time points
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

#SBATCH --mem=3g
#SBATCH --output=Logs/15-diff-anal/slurm-%A_%a.out
#SBATCH --error=Logs/15-diff-anal/slurm-%A_%a.err

# Set a default value for testing outside the SLURM environment
: ${SLURM_ARRAY_TASK_ID:=1}

# Document software versions used for publication
uname -a
R --version
pwd

./diff-anal.R
