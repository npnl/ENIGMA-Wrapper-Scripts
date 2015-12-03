#################################################
#  This R script that will generate a histogram plot (in .png format) for each cortical ROI in FreeSurfer for ENIGMA
#
#  In addition it will output a text file with numerical summaries that will need to be uploaded to the ENIGMA Support Group
#
#################################################
#
#  Run this script in the same directory as your CorticalMeasuresENIGMA_ThickAvg.csv and CorticalMeasuresENIGMA_SurfAvg.csv files. All of the output will go into the same folder.
#
#  Written by Derrek Hibar (derrek.hibar@ini.usc.edu) for the ENIGMA Consortium (2011)
#        Updated for cortical structures (March 24 2013)
#
#################################################

#Read in data file
data=read.csv("CorticalMeasuresENIGMA_ThickAvg.csv");
	
#Check how many subj to use a good number of bins for hist plots
hbins=NULL;
if(nrow(data)>200){
	hbins=100;
}

#Get column names
cnames=colnames(data);

#Create a file to store summary statistics for each structure
write("Structure\tNumberExcluded\tTotalGoodSubjs\tMean\tStandDev", file="SummaryStats_Thickness.txt");

#Loop through each structure and make plots
for(x in 2:length(cnames)){
	
	#Do some checking of the data to make sure it looks ok
	badsegs=0;
	ind=which(data[,x]=="x")
	ind2=which(data[,x]=="X")
	index=c(ind,ind2);
	if(length(index) > 0){
		stop("There were values marked with x or X detected in your CorticalMeasuresENIGMA_ThickAvg.csv file. All poorly segmented \
		or otherwise missing values should be marked with the letters NA in the CorticalMeasuresENIGMA_ThickAvg.csv file.\n\n");
	}

	#Check to make sure there are not any missing values
	miss=which(data[,x]=="");
	if(length(miss)>0){
		stop("There were missing values detected in your CorticalMeasuresENIGMA_ThickAvg.csv file. Open your CorticalMeasuresENIGMA_ThickAvg.csv file \
		in Excel and locate any blank cells. Missing values should be marked with NA. \n\n");
	}

	#Check to make sure none of the values are negative
	negs=which(data[,x]<0);
	if(length(negs)>0){
		stop("Some of your volume values are negative. This does not makes sense. Open your CorticalMeasuresENIGMA_ThickAvg.csv file \
		in Excel and set negative volume values and poorly segmented values to NA in the file.\n\n");
	}

	#Find which subjects are marked as NA for a given structure in the loop
	nas=which(is.na(data[,x]));
	if(length(nas)>0){
		interm=data[-nas,x];
		badsegs=badsegs+length(nas)
		cat(paste("You marked ", as.character(badsegs), " subjects as poorly segmented (thickness) in the ", cnames[x], "\n", sep=''));
	} else {
		interm=data[,x];
		cat(paste("None of the subjects in the ", cnames[x], " were marked as poorly segmented (thickness)\n", sep=''));
	}
	
	#make sure data is in numeric format
	interm=as.numeric(as.vector(interm));
	
	#Get the summary statistic values
	mu=mean(interm);
	sdev=sd(interm);
	n.used=length(interm);
	stats=c(cnames[x], badsegs, n.used, mu, sdev);
	
	write.table(t(as.matrix(stats)), file="SummaryStats_Thickness.txt", append=T, quote=F, col.names=F,row.names=F,sep="\t");
	
	png(paste(cnames[x],"_hist_thickness.png",sep=""))
	hist(interm, nclass=hbins, main=cnames[x], xlab="Average Thickness");
	dev.off()	
}

##############################################
#Output an R data file to store the plot data
save.image(file="ENIGMA_CortexROI_plots_Thickness.Rdata");

#############################################
#############################################
#############################################
#############################################	
#Read in data file
data=read.csv("CorticalMeasuresENIGMA_SurfAvg.csv");
	
#Check how many subj to use a good number of bins for hist plots
hbins=NULL;
if(nrow(data)>200){
	hbins=100;
}

#Get column names
cnames=colnames(data);

#Create a file to store summary statistics for each structure
write("Structure\tNumberExcluded\tTotalGoodSubjs\tMean\tStandDev", file="SummaryStats_SurfArea.txt");

#Loop through each structure and make plots
for(x in 2:length(cnames)){
	
	#Do some checking of the data to make sure it looks ok
	badsegs=0;
	ind=which(data[,x]=="x")
	ind2=which(data[,x]=="X")
	index=c(ind,ind2);
	if(length(index) > 0){
		stop("There were values marked with x or X detected in your CorticalMeasuresENIGMA_SurfAvg.csv file. All poorly segmented \
		or otherwise missing values should be marked with the letters NA in the CorticalMeasuresENIGMA_SurfAvg.csv file.\n\n");
	}

	#Check to make sure there are not any missing values
	miss=which(data[,x]=="");
	if(length(miss)>0){
		stop("There were missing values detected in your CorticalMeasuresENIGMA_SurfAvg.csv file. Open your CorticalMeasuresENIGMA_SurfAvg.csv file \
		in Excel and locate any blank cells. Missing values should be marked with NA. \n\n");
	}

	#Check to make sure none of the values are negative
	negs=which(data[,x]<0);
	if(length(negs)>0){
		stop("Some of your volume values are negative. This does not makes sense. Open your CorticalMeasuresENIGMA_SurfAvg.csv file \
		in Excel and set negative volume values and poorly segmented values to NA in the file.\n\n");
	}

	#Find which subjects are marked as NA for a given structure in the loop
	nas=which(is.na(data[,x]));
	if(length(nas)>0){
		interm=data[-nas,x];
		badsegs=badsegs+length(nas)
		cat(paste("You marked ", as.character(badsegs), " subjects as poorly segmented (area) in the ", cnames[x], "\n", sep=''));
	} else {
		interm=data[,x];
		cat(paste("None of the subjects in the ", cnames[x], " were marked as poorly segmented (area)\n", sep=''));
	}
	
	#make sure data is in numeric format
	interm=as.numeric(as.vector(interm));
	
	#Get the summary statistic values
	mu=mean(interm);
	sdev=sd(interm);
	n.used=length(interm);
	stats=c(cnames[x], badsegs, n.used, mu, sdev);
	
	write.table(t(as.matrix(stats)), file="SummaryStats_SurfArea.txt", append=T, quote=F, col.names=F,row.names=F,sep="\t");
	
	png(paste(cnames[x],"_hist_surfarea.png",sep=""))
	hist(interm, nclass=hbins, main=cnames[x], xlab="Average Surface Area");
	dev.off()	
}

##############################################
#Output an R data file to store the plot data
save.image(file="ENIGMA_CortexROI_plots_SurfArea.Rdata");	
	
	
