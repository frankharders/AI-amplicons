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

echo "move and or copy files folders for backup";

# copy the log files
cp -r "$LOG" "$BACKUP";
# copy the raw reads
cp -r "$RAW_FASTQ" "$BACKUP"
# copy some other files
cp "$PWD"/*.txt; "$BACKUP";
cp "$PWD"/*.xls* "$BACKUP";
cp "$PWD"/*.sh* "$BACKUP";

PROJECT=$(basename "$PWD");

rm "$PROJECT"-backup.tar.gz;

tar -zcvf "$PROJECT"-backup.tar.gz "$PWD"/"$PROJECT";

mv "$PROJECT"-backup.tar.gz /mnt/lely_archive/PROJECTS/SBSUSERS/DEMULTIPLEXED/2023;


exit 1

