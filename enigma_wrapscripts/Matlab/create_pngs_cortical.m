addpath(getenv('mdir'))
QC_output_directory=getenv('qcdir');
FS_directory=getenv('fsdir');
b=getenv('sub');

func_make_corticalpngs_ENIGMA_QC(QC_output_directory,b, [FS_directory,'/', b, '/mri/orig.mgz'], [FS_directory,'/',b, '/mri/aparc+aseg.mgz']);

