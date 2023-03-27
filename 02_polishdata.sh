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

##  list of directories used with this pipeline

## used variables read trimming

KTRIM=r;
TRIMQ=20;
QTRIM='rl';
k=29;

##  log file fort metrics
PSEUDOreport="$REPORTING"/pseudo-read-count.tab;
echo -e "sample\treads\treadsPolished\tpseudoReads" > "$PSEUDOreport";


count0=1;
countS=$(cat samples.txt | wc -l);

while [ "$count0" -le "$countS" ]; do 

SAMPLE=$(cat samples.txt | awk 'NR=='"$count0");

echo "$SAMPLE";

## LOG files for debugging
LOG1="$LOG"/"$SAMPLE".general.bbmap.log;

R1="$RAW_FASTQ"/"$SAMPLE"_R1.fastq.gz;
R2="$RAW_FASTQ"/"$SAMPLE"_R2.fastq.gz;	

## intermediate files stored in a TEMp directory
## files will be deleted when re-starting the script 
FILTERED1="$TMP"/"$SAMPLE"_R1.filterbytile.fq.gz;
FILTERED2="$TMP"/"$SAMPLE"_R2.filterbytile.fq.gz;
ADAPTER="$TMP"/"$SAMPLE"_adapters.fa;
ADAPTERout1="$TMP"/"$SAMPLE"_R1.adapter.fq.gz;
ADAPTERout2="$TMP"/"$SAMPLE"_R2.adapter.fq.gz;
	
OUTPUT1="$POLISHED"/"$SAMPLE"_R1.QTR.adapter.nextera.k"$k".fq.gz;
OUTPUT2="$POLISHED"/"$SAMPLE"_R2.QTR.adapter.nextera.k"$k".fq.gz;

PSEUDOout1="$MERGED"/"$SAMPLE".merged.QTR.adapter.nextera.k."$k".fq.gz;
PSEUDOout2="$TMP"/"$SAMPLE".unmerged.QTR.adapter.nextera.k."$k".fq.gz;
INSERTout="$LOG"/"$SAMPLE"-insertSize.tab;




echo -e "R1=$R1";
echo -e "R2=$R2";


		# 1
		##  filter blurry parts from flowcell
		filterbytile.sh in1="$R1" in2="$R2" out1="$FILTERED1" out2="$FILTERED2" ow=t > "$LOG1" 2>&1;

		# 2
		##  Discover adapter sequence for this library based on read overlap.
		##  You can examine the adapters output file afterward if desired;
		##  If there were too few short-insert pairs this step will fail (and you can just use the default Illumina adapters).
		bbmerge.sh in1="$FILTERED1" in2="$FILTERED2" outa="$ADAPTER" ow reads=1m >> "$LOG1" 2>&1;

		# 3
		##  Perform adapter-trimming on the reads.
		##  Also do quality trimming and filtering.
		##  If desired, also do primer-trimming here by adding, e.g., 'ftl=20' to to trim the leftmost 20 bases.
		##  If the prior adapter-detection step failed, use "ref=adapters"
     	bbduk.sh -Xmx24g in1="$FILTERED1" in2="$FILTERED2" out1="$ADAPTERout1" out2="$ADAPTERout2" ktrim="$KTRIM" ref="$NEXTERA" k="$k" mink=21 ow=t >> "$LOG1" 2>&1;
		bbduk.sh -Xmx48g in1="$ADAPTERout1" in2="$ADAPTERout2" out1="$OUTPUT1" out2="$OUTPUT2" qtrim="$QTRIM" trimq="$TRIMQ" ow=t >> "$LOG1" 2>&1;

		# 4
		##  verify read pairs
		reformat.sh verifypaired=t in1="$OUTPUT1" in2="$OUTPUT2" ow=t >> "$LOG1" 2>&1;

		# 5
		##  verify insertSize of NGS libs
		bbmerge-auto.sh in1="$OUTPUT1" in2="$OUTPUT2" out="$PSEUDOout1" outu="$PSEUDOout2" outinsert="$INSERTout" iterations=10 k="$k" ecct qtrim2=r trimq="$TRIMQ" strict minlength=150 ow=t >> "$LOG1" 2>&1;

		# 6
		##  map the polished reads against the clustered database file
#		bbmap.sh -Xmx48g ref="$reference" build=1 in1="$OUTPUT1" in2="$OUTPUT2" outm="$TEMP"/"$SAMPLE"."$REF".sam untrim=t showprogress=0 ambig=best local=t sam=1.3 fast=t ow=t > "$LOG7" 2>&1 ;
		
#		samtools view -@ "$NODES" -S "$TEMP"/"$SAMPLE"."$REF".sam -b -o "$TEMP"/"$SAMPLE"."$REF".bam;
#		samtools sort -@ "$NODES"  -o "$dbMAPPING"/"$SAMPLE"."$REF"_sorted.bam "$TEMP"/"$SAMPLE"."$REF".bam;
#		samtools index "$dbMAPPING"/"$SAMPLE"."$REF"_sorted.bam "$dbMAPPING"/"$SAMPLE"."$REF"_sorted.bai;


RAWcnt=$(zcat "$R1" | wc -l);
READcnt=$(zcat "$OUTPUT1" | wc -l);
PSEUDOcnt=$(zcat "$PSEUDOout1" | wc -l);

RAWc=$((RAWcnt / 4 ));
READc=$((READcnt /4 ));
PSEUDOc=$((PSEUDOcnt / 4 ));

echo -e "$SAMPLE\t$RAWc\t$READc\t$PSEUDOc" >> "$PSEUDOreport";

	let cnt--;	
	echo -e "$cnt samples to go!";
	echo "NEXT";

count0=$((count0+1));	
		done

echo "read polishing is done for all samples";
echo -e "output files for downstream processing can be found in the directory $PROCESSED";

rm -rf "$TEMP";


		
exit 1

