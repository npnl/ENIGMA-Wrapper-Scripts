#!/bin/bash
export FREESURFER_HOME=<PATH TO FREESURFER INSTALLATION>
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh
export PATH=${PATH}:${FREESURFER_HOME}/bin

recon-all $@

exit $?