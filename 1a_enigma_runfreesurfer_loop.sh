#!/bin/sh
# 11-18-2015
# Written by Sook-Lei Liew, sliew@usc.edu

# This wrapper script allows you to run the first wrapper script 
# for all subjects in your inputs directory. 
# It assumes all subjects are listed as "sub___" (e.g., subj01, subj02, sub309234098)

#Below, enter your parent directory below where it says /Users/username/enigma (e.g., ROOTDIR=/Your/path/to/enigma)
ROOTDIR=/Users/Julia/Desktop/enigma_protocols_JA

cd $ROOTDIR
pwd

cd $ROOTDIR/inputs
ls sub*

for SUB in sub*
do
	echo Now running freesurfer on $SUB
	$ROOTDIR/1_enigma_runfreesurfer.sh $SUB $ROOTDIR
done


