#!/bin/bash

# source activate AI-samples; # source only present on lelycompute-02!
# frank.harders@wur.nl

##  activate the environment for this downstream analysis
eval "$(conda shell.bash hook)";
conda activate AI-samples;


#create several directories
while getopts "i:s:o:m:b:l:a:t:r:" opt; do
  case $opt in
     i)
      echo "-i was triggered! $OPTARG"
      RAW_FASTQ="`echo $(readlink -m $OPTARG)`"
      echo $RAW_FASTQ
      ;;
     s)
      echo "-s was triggered! $OPTARG"
      OUTSTATS="`echo $(readlink -m $OPTARG)`"
      echo $OUTSTATS
      ;;
	 o)
      echo "-o was triggered! $OPTARG"
      POLISHED="`echo $(readlink -m $OPTARG)`"
      echo $POLISHED
      ;;
	 m)
      echo "-m was triggered! $OPTARG"
      MERGED="`echo $(readlink -m $OPTARG)`"
      echo $MERGED
      ;;
	  b)
      echo "-b was triggered! $OPTARG"
      BACKUP="`echo $(readlink -m $OPTARG)`"
      echo $BACKUP
      ;;
	 l)
      echo "-l was triggered! $OPTARG"
      LOG="`echo $(readlink -m $OPTARG)`"
      echo $LOG
      ;;
	 a)
      echo "-a was triggered! $OPTARG"
      NEXTERA="`echo $(readlink -m $OPTARG)`"
      echo $NEXTERA
      ;;
	  t)
      echo "-t was triggered! $OPTARG"
      TMP="`echo $(readlink -m $OPTARG)`"
      echo $TMP
      ;;
	  r)
      echo "-r was triggered! $OPTARG"
      REPORTING="`echo $(readlink -m $OPTARG)`"
      echo $REPORTING
      ;;
     \?)
      echo " Let's start some analysis" >&2
      ;;

  esac
done

cnt=$(cat samples.txt | wc -l);


count0=1;
countS=$(cat samples.txt | wc -l);


while [ "$count0" -le "$countS" ];do 

SAMPLE=$(cat samples.txt | awk 'NR=='"$count0");

R1=$RAW_FASTQ/$SAMPLE'_R1.fastq.gz';
R2=$RAW_FASTQ/$SAMPLE'_R2.fastq.gz';


echo "fastQC analysis on raw sequence files";
fastqc -t 8 -o $OUTSTATS $R1 $R2;

rm "$OUTSTATS"/*.zip;
	let cnt--;	
	echo -e "$cnt samples to go!";
	echo "NEXT";

count0=$((count0+1));
		done
		

cp -r $OUTSTATS $BACKUP;
	
exit 1


