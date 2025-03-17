#!/bin/sh -e

species_prefix=$(../../Common/species-prefix.sh)
build=$(../../Common/genome-build.sh)
release=$(../../Common/genome-release.sh)
echo $species_prefix$build.$release.chr.gff3
