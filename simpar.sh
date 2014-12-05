#!/bin/bash

#------------------------------------------------------------------------------#
#                             SIMULATIONS FOR FUBAR                            #
#------------------------------------------------------------------------------#

#------------------------------------ paths -----------------------------------#

# Path to input csv
csvfile=/data/veg/FUBAR3D/pipeline/test.out.0.0.csv

# Path to FUBAR3Dsims directory
simsdir=/data/veg/FUBAR3D/FUBAR3Dsims


#----------------------------- parameter settings -----------------------------#

# Number of taxa in tree
ntaxa=16

# Nonsyn distributions

mu1n=4
sigma1n=0.1
mu2n=0.4
sigma2n=0.2

# Syn distributions

mu1s=4
sigma1s=0.1
mu2s=0.4
sigma2s=0.1

#--------------------------------- simulation ---------------------------------#

for k in $csvfile; do
  newname=$k.sim;
  python3 $simsdir/simsetgen.py $ntaxa $k $newname \
    --nonsyn $mu1n $sigma1n $mu2n $sigma2n \
    --syn $mu1s $sigma1s $mu2s $sigma2s;
done

for k in $csvfile.sim.*; do
  simname=$k;
  faname=$simname.fasta;
  (echo $simname; echo $faname) | /usr/local/bin/HYPHYMP $simsdir/f3dsims.bf;
  #echo "((echo $simname; echo $faname) | /usr/local/bin/HYPHYMP ${PWD}/../f3dsims.bf )" | qsub -l walltime=48:00:00 -q eternity ;
done

# The resulting FASTA files can be found at $csvfile.sim.*.fasta

exit
