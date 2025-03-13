#!/bin/sh -e

##########################################################################
#   This script should no longer be needed, since kallisto -gtf appears
#   to work with GFF3.  Use the equivalent gff3 script instead.
##########################################################################

species_prefix=$(../../Common/species-prefix.sh)
build=$(../../Common/genome-build.sh)
release=$(../../Common/genome-release.sh)
echo $species_prefix$build.$release.chr.gtf
