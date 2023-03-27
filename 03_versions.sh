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


##  loop over all used conda envs for this pipeline so all verions can be recorded for the used software and databases

## central file for reporting all PROGVERSIONS of software ans databases that will be used for the several steps in the pipeline
PROGVERSIONS="$PWD"/versions.txt;

rm -f "$PROGVERSIONS";		

echo "gather all software versions";
	
##  00_structure.sh
##  no programms were used

			echo -e "script: 00_structure.sh" >> "$PROGVERSIONS";
			echo -e "programm\tversion" >> "$PROGVERSIONS";
			echo -e "no program\tna" >> "$PROGVERSIONS";
			echo -e "\n" >> "$PROGVERSIONS";


##  01_fastqc.sh
##  fastqc was used

	eval "$(conda shell.bash hook)";
	conda activate AI-samples;

		ENV=AI-samples;
		PROG=$(conda list | grep '^fastqc' | sed 's/  */;/g' | cut -f2 -d';');
				
			echo -e "script: 01_fastqc.sh" >> "$PROGVERSIONS";
			echo -e "conda environment=$ENV" >> "$PROGVERSIONS";			
			echo -e "programm\tversion" >> "$PROGVERSIONS";
			echo -e "fastQC\t$PROG" >> "$PROGVERSIONS";
			echo -e "\n" >> "$PROGVERSIONS";

		
##  02_polishdata.sh
##  bbTools was used

		ENV=();
		ENV=AI-samples;
		PROG=();
		PROG=$(conda list | grep '^bbmap' | sed 's/  */;/g' | cut -f2 -d';');

			echo -e "script: 02_polishdata.sh" >> "$PROGVERSIONS";
			echo -e "conda environment=$ENV" >> "$PROGVERSIONS";			
			echo -e "programm\tversion" >> "$PROGVERSIONS";			
			echo -e "bbmap-Suite\t$PROG" >> "$PROGVERSIONS";
			echo -e "\n" >> "$PROGVERSIONS";
			
##  03_versions.sh
##  no programms were used

			echo -e "script: 03_versions.sh" >> "$PROGVERSIONS";
			echo -e "programm\tversion" >> "$PROGVERSIONS";
			echo -e "no program\tna" >> "$PROGVERSIONS";
			echo -e "\n" >> "$PROGVERSIONS";


##  04_backup.sh
##  no programms were used

			echo -e "script: 04_backup.sh" >> "$PROGVERSIONS";
			echo -e "programm\tversion" >> "$PROGVERSIONS";
			echo -e "no program\tna" >> "$PROGVERSIONS";
			echo -e "\n" >> "$PROGVERSIONS";


mv "$PROGVERSIONS" "$BACKUP";
	
exit 1	
			
			
			