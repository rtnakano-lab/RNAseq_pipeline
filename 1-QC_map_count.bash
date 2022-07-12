#!/bin/bash
# bash script for preprocessing of reads by fastp, mapping to araport11 genome by HiSAT2, and read count by featureCount
# Originally by Ryohei Thomas Nakano, nakano@mpipz.mpg.de
# Last modified: 12 Jan 2022

# Note: Optimized for single-end reads, unstranded

# prerequisites:
# appropriate edits of 0-config.bash
# list of libraries in a tab-separted text file with a single-line header, containing the name of Libraries in the first column
# each raw read file is in fastq.gz format and contains the libary name in the beginning and "R1" in the middle of its file name
# the read file names may vary depending on where you read them. If they have different styles of name, modify the file names or modify the respective line of this script to be optimized

# usage on dell node: ./1-QC_map_count.bash ./0-config.bash

# Or, if you want to submit to LSF:
# ssh connection to hpcws001.mpipz.mpg.de (via Putty in case of Windows)
# type "lsfenv" and enter to active LSF submission system
# bsub -J QC_map_count -q multicore40 -n 40 -R "rusage[mem=6400] span[hosts=1]" -M 12800 ./1-QC_map_count.bash ./0-config.bash
# -J: job name
# -q: queues (multicore40, multicore20, ioheavy, normal, ...)
# -n: number of cores
# -R and -M: about memory usage



# initialization
set -e
set -o nounset

log() {
    echo $(date -u)": "$1 >> $logfile
}

# load configs
config_file=$1
source $config_file

logfile="${out_dir}/log.txt"
output_file="${out_dir}/output.txt"

# clean up and initialize
report_dir=${out_dir}/fastp_report
clean_seq_dir=${out_dir}/clean_seq
map_dir="${out_dir}/map"
count_dir="${out_dir}/featureCounts"

rm -r -f ${report_dir}
rm -r -f ${clean_seq_dir}
rm -r -f ${map_dir}
rm -r -f ${count_dir}
rm -r -f ${logfile}
rm -r -f ${output_file}

mkdir -p ${report_dir}
mkdir -p ${clean_seq_dir}
mkdir -p ${map_dir}
mkdir -p ${count_dir}

# prepare lists of libraries and of fastq.gz files (normally one file per library but not always)
lib_list=($(tail -n +2 ${design_path} | cut -f 1))
file_list=($(cd ${dat_dir} && ls *.fastq.gz))

# start
log "Start the entire pipeline"




log "FASTP..."

# do what's in the loop for each file
for file in ${file_list[@]}
do	
	log "FASTP for ${file}"

	${FASTP_PATH}/fastp -w 16 -p -q 30 -x \
		-i ${dat_dir}/${file} \
		-h ${report_dir}/${file/.fastq.gz/.html} \
		-j ${report_dir}/${file/.fastq.gz/.json} \
		-o ${clean_seq_dir}/${file} \
		&>> ${output_file}

		# -w: number of threads
		# -p: overrepresenting analysis
		# -x: polyX trimming
		# -q: a quality threshhold (>= Q30)
		# -i: input
		# -h: html-format report output
		# -j: json-format report output
		# -o: output (cleaned fastq.gz file)

done





log "HiSat2 mapping..."

# do what's in the loop for each library
for lib in ${lib_list[@]}
do
	log "HiSat2 for ${lib}"

	# collect read files for each library and connect with "," in between
	R1=$(echo ${file_list[@]} | tr ' ' '\n' | grep -e ${lib} | grep -v ${lib}[0-9] | tr '\n' ',' | sed s/,$//g)

	# mapping by HiSAT2
	hisat2 --threads 40 \
		-U ${clean_seq_dir}/${R1} \
		-x ${HISAT2_INDEXES} \
		-S ${map_dir}/${lib}_hisat2.sam \
		-t \
		--new-summary \
		--summary-file ${map_dir}/${lib}_align_summary.txt \
		--met-file ${map_dir}/${lib}_metrics.txt \
		&>> ${output_file}

		# --threads: number of threads
		# -U: read file
		# -x: path to the indexed library (should have done by yourself during the setup)
		# -S: output sam file
		# -t: print time taken
		# --new-summary: print alingment summary
		# --met-file: print mapping metrices

	echo ${lib} >> ${map_dir}/HiSat2-align_summary_all.txt
	tail -n +2 ${map_dir}/${lib}_align_summary.txt >> ${map_dir}/HiSat2-align_summary_all.txt

done






log "featureCounts..."

sam_list=($(awk -v path=${map_dir} 'NR>1{print path"/"$1"_hisat2.sam"}' ${design_path}))

${FEATURECOUNTS_PATH}/featureCounts -T 40 \
	-t exon \
	-s 0 \
	-g gene_id \
	-a ${anno_dir} \
	-o ${count_dir}/count_table_lousy.txt \
	${sam_list[@]} \
	&>> ${output_file}

	# -T: number of threads
	# -s: strandedness - 0 (unstranded), 1 (stranded) and 2 (reversely stranded). 0 by default.
	# -g: which identifies you use for the count table
	# -a: annotation GTF file
	# -o: output

# convert column names from sam file names to respective library names
cat ${count_dir}/count_table_lousy.txt | \
	sed "s/${map_dir//\//\\/}\///g" | \
	sed "s/_hisat2.sam//g" | \
	tail -n +2 | \
	cut -f 1,7-$(expr ${#sam_list[@]} + 6) \
	> ${count_dir}/count_table.txt

rm ${count_dir}/count_table_lousy.txt


# # clean up
# log "clean up..."

# rm -r -f ${map_dir}
# rm -r -f ${clean_seq_dir}


log "All Done"



























