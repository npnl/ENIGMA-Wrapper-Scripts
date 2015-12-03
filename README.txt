# ENIGMA-Wrapper-Scripts

12-3-2015

WELCOME

Hi and welcome to the ENIGMA Stroke Recovery Working Group! We've tried to package the ENIGMA protocols with several wrapper scripts to facilitate the easiest data processing possible. A special thanks goes out to Eric Kan for writing the wrappers and Julia Anglin for testing them. Any troubleshooting issues should be directed to both Sook-Lei Liew (sliew@usc.edu) and the Neural Plasticity and Neurorehabilitation Laboratory (npnl@usc.edu). Thanks for doing this - we look forward to a productive collaboration!


GETTING STARTED

There is a little setup required before you start:

0) The project directory must be built as follows:

*Note: script assumes the string, 'subj' is somewhere in the subject names

Scripts assume the following structure

Project_parent_directory/
	-> inputs/ (mprage/anatomicals, 1 per subject)
		-> subj01 (within this folder should be subj01.nii.gz)
		-> subj02 (within this folder should be subj02.nii.gz)
		..
	-> outputs/
		-> subj01 (freesurfer outputs; will be created)
		-> subj02
		...
	-> enigma_wrapscripts/ (contains the bash, R, and Matlab .zip folders)

This should have been set up already, but you should add your subject .nii mirages into the inputs folder.

1) Unzip each of the zipped program folders (bash, Matlab, and R .zip folders) in enigma_wrapscripts if they are not unzipped already

2) FSL, Freesurfer, and Matlab must be installed on your computer. The executables of each need to be in the user's PATH environment (most times this is already setup if the programs are already installed on the machine). For Mac/linux users, to see if this is set up, type nano ~/.bash_profile (or .bash_rc or other equivalent profile) in the terminal (this file may be a different name/path). If this is not set up for a given program, you will need to manually type the following in: 

export PATH=“<directory>/<program>/bin:$PATH” 

(but replace <directory>/<program> with your specific path to the program - for instance, to execute Matlab 2013b from the command line, you might use the following line: 

export PATH="/Applications/MATLAB_R2013b.app/bin:$PATH"

3) In the recon-all.sh script, line 2 needs to be modified to point where the Freesurfer program has been installed (i.e. replace <PATH TO FREESURFER INSTALLATION> with /Applications/freesurfer). The script recon-all.sh script is found in enigma_wrapscripts/bash/.

4) Make sure all bash scripts and applications are executable. For instance:

chmod -R a+w /Applications/freesurfer
chmod a+x <parent_dir>/1_enigma_runfreesurfer.sh 


RUNNING THE SCRIPTS

When steps above are complete, you can run the 2 wrapper scripts:

1. Run Freesurfer.
This will take some time to run! Run 1_enigma_runfreesurfer.sh   -   simply runs freesurfer for a single subject (~12-16 hrs per subject)

Usage is: ./1_enigma_runfreesurfer.sh <subject number> <path to parent project directory>

NOTE: To run over many subjects, you can use a for loop:

for sub in 'list of subjects'
do
./1_enigma_runfreesurfer.sh stroke1-subj01 /Users/ekan/Project
done

(e.g. for i {1..100}; do ./1_enigma_runfreesurfer.sh subj${i} /Users/username/Desktop/ENIGMA/enigma_wrapscripts; done)

A script to run this for loop is also included: 1a_enigma_runfreesurfer_loop.sh - you will need to change the ROOTDIR variable to set it to your parent directory)

2. Run Quality Checks (subcortical).
After the completion of the 1st step, you should have freesurfer output for each subject in the subjects folder located in freesurfer. Copy and paste these folders into the outputs folder found in your parent directory. Then you can run 2_extractsubcortical_volumes.sh  - which does everything outlined in 'Instructions_ENIGMA_subcortical_volumes.doc'   (~30 min for 27 subjects)

Usage is: ./2_extractsubcortical_volumes.sh <path to parent project directory>

3. Run Quality Checks (cortical).
Then you can run 3_extractcortical_volumes.sh  - which does everything outlined in 'Instructions_ENIGMA_cortical_volumes.doc'   (~30 min for 27 subjects) 

Usage is: ./3_extractcortical_volumes.sh <path to parent project directory>
