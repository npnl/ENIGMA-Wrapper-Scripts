#!/bin/bash
#####
# 10/23/15
# Wrapper written by Eric Kan (ekan@chla.usc.edu)
#
#	
# Script assumes the following structure
#			Project_parent_directory/
#						-> inputs/ (nii files 1_enigma_runfreesurfer.sh script,
#													not used here)
#						-> outputs/
#							-> subj01(freesurfer outputs)
#							-> subj02
#							...
#						-> enigma_wrapscripts/ (copied from elsewhere)
#
######

###############
# Setup directory where volumes are
enigmadir=$1

if [ -z ${enigmadir} ] || [ $# -gt 1 ] ; then

	echo "One input directory must be specified"
	echo "Usage is: ./2_extractsubcortical_volumes.sh <parent directory of project>"
	exit
fi

if [ ! -e ${enigmadir} ]; then
	echo "Input directory does not exist"
	exit
fi

###############
# Extract volumes

mkdir ${enigmadir}/outputs/subcortical #JA

cd ${enigmadir}/outputs
echo ${PWD}
echo "SubjID,LLatVent,RLatVent,Lthal,Rthal,Lcaud,Rcaud,Lput,Rput,Lpal,Rpal,Lhippo,Rhippo,Lamyg,Ramyg,Laccumb,Raccumb,ICV" > subcortical/LandRvolumes.csv
for subj_id in `ls -d *subj*`
do 
	printf "%s,"  "${subj_id}" >> subcortical/LandRvolumes.csv  #JA
	for x in Left-Lateral-Ventricle Right-Lateral-Ventricle Left-Thalamus-Proper Right-Thalamus-Proper Left-Caudate Right-Caudate Left-Putamen Right-Putamen Left-Pallidum Right-Pallidum Left-Hippocampus Right-Hippocampus Left-Amygdala Right-Amygdala Left-Accumbens-area Right-Accumbens-area 
	do
		printf "%g," `grep  ${x} ${subj_id}/stats/aseg.stats | awk '{print $4}'` >> subcortical/LandRvolumes.csv  #JA
	done
	
	printf "%g" `cat ${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> subcortical/LandRvolumes.csv  #JA
	echo "" >> subcortical/LandRvolumes.csv  #JA
done

###############
# Generate histogram plots

mkdir ${enigmadir}/outputs/subcortical/figures  #JA
cp ${enigmadir}/outputs/subcortical/LandRvolumes.csv ${enigmadir}/outputs/subcortical/figures  #JA

cd ${enigmadir}/outputs/subcortical/figures  #JA
R --no-save --slave < ${enigmadir}/enigma_wrapscripts/R/ENIGMA_plots.R

###############
# Perform outlier detection
cd ${enigmadir}/outputs/subcortical/figures  #JA
${enigmadir}/enigma_wrapscripts/bash/mkIQIrange.sh > jnk.txt
more jnk.txt | grep "has" |  awk -F/ ' { print $NF } ' | awk ' { print $1 } '| sort | uniq > jnk2.txt
more jnk2.txt | wc -l
hd=`pwd`

num=`cat jnk2.txt | wc | awk '{print $1}'`
echo "There are ${num} subjects labeled as outliers"
echo "Would you like to review them now? (type y or n)"
read resp

if [ ${resp} == "y" ]; then
	for img in `more jnk2.txt`
	do 
		echo $img 
		cd ${enigmadir}/outputs/$img/mri/
		mri_convert --out_orientation RAS --in_type mgz --out_type nii T1.mgz T1.nii ; 
		mri_convert --out_orientation RAS --in_type mgz --out_type nii aseg.mgz aseg.nii ; 
		more $hd/jnk.txt | grep $img
		fslview T1.nii aseg.nii -t 0.2 -l "MGH-Subcortical"; 
		rm *.nii
	done
fi

#################
# Create PNGs for QC

mkdir ${enigmadir}/outputs/subcortical/QC  #JA

export mdir=${enigmadir}/enigma_wrapscripts/Matlab
export fsdir=${enigmadir}/outputs
export qcdir=${enigmadir}/outputs/subcortical/QC  #JA

for x in `ls -d ${fsdir}/*subj*`
do
	export sub=`basename ${x}`
	echo ${sub}
	matlab  -nosplash < ${enigmadir}/enigma_wrapscripts/Matlab/create_pngs_subcortical.m  #JA
done

#################
# Create QC webpage
cd ${enigmadir}/outputs/subcortical/QC

chmod 777 make_subcortical_ENIGMA_QC_webpage.sh  #JA
${enigmadir}/enigma_wrapscripts/bash/make_subcortical_ENIGMA_QC_webpage.sh ${enigmadir}/outputs/subcortical/QC  #JA
