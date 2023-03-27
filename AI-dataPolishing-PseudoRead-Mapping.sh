#!/bin/bash

# source activate AI-samples; # source only present on lelycompute-02!
# frank.harders@wur.nl
 

##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate AI-samples;

OUT_FOLDER="$PWD";


PROJECT=$(basename "$PWD");

RAW_FASTQ="$OUT_FOLDER"/RAWREADS/;												# i
OUTSTATS="$OUT_FOLDER"/01_raw_stats;											# s
POLISHED="$OUT_FOLDER"/02_polished/;											# o
MERGED="$OUT_FOLDER"/03_mergeReads/;											# m
LOG="$OUT_FOLDER"/LOGS/;														# l
NEXTERA=/home/harde004/pipelines/resources/nextera.fa.gz;						# a options: nextera Rubicon TAKARA truseq scriptseqv2 
BACKUP="$OUT_FOLDER"/"$PROJECT";												# b
TMP="$OUT_FOLDER"/TEMP/;														# t
REPORTING="$OUT_FOLDER"/REPORTING/;												# r


#  create folder structure for analysis
./00_structure.sh -i $RAW_FASTQ -s $OUTSTATS -b $BACKUP -o $POLISHED -m $MERGED -l $LOG -a $NEXTERA -t $TMP -r $REPORTING;

#  fastqc analysis on raw reads
#./01_fastqc.sh -i $RAW_FASTQ -s $OUTSTATS -b $BACKUP -o $POLISHED -m $MERGED -l $LOG -a $NEXTERA -t $TMP -r $REPORTING;

#  polish raw reads for artifacts
./02_polishdata.sh -i $RAW_FASTQ -s $OUTSTATS -b $BACKUP -o $POLISHED -m $MERGED -l $LOG -a $NEXTERA -t $TMP -r $REPORTING;

#  construct a file containing the software versions used for analysis
./03_versions.sh -i $RAW_FASTQ -s $OUTSTATS -b $BACKUP -o $POLISHED -m $MERGED -l $LOG -a $NEXTERA -t $TMP -r $REPORTING;

#  backup the project with the selected information
./04_backup.sh -i $RAW_FASTQ -s $OUTSTATS -b $BACKUP -o $POLISHED -m $MERGED -l $LOG -a $NEXTERA -t $TMP -r $REPORTING;

exit 1

