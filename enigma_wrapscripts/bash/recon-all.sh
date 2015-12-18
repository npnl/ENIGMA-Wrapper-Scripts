#!/bin/bash
export FREESURFER_HOME=/Applications/freesurfer
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh
export PATH=${PATH}:${FREESURFER_HOME}/bin

recon-all $@

exit $?