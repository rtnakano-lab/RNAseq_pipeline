#!/bin/bash
# config file for RNAseq_pipeline/1-QC_map_count.bash
# Originally by Ryohei Thomas Nakano, nakano@mpipz.mpg.de
# Last modified: 16 Dec 2025, by Ryohei Thomas Nakano, rtnakano@sci.hokudai.ac.jp

# === Edit for each dataset === #
# path to raw fastq.gz data
export dat_dir="/data/seq_rawdata/PROJECT_NAME/rawdata"

# path to the design file (a tab-deliminated file with a single-line header row, whose first column contains the list of library names)
export design_path="/data/USER_ID/PROJECT_NAME/original_data/design.txt"

# path to output directory where all intermediate and final data will be stored
# NOTE: The main script will overwrite everything in this directory.
export out_dir="/data/USER_ID/PROJECT_NAME/temp"




# === Normally you need to edit the followings only once === #
# path to softwares
export FASTP_PATH="/shared_tools"
export FEATURECOUNTS_PATH="/shared_tools/subread-2.0.6-source/bin"
export HISAT2_PATH="/shared_tools/hisat2-2.2.1"

# path to directory you store the HiSAT2 index that you created
export HISAT2_INDEXES="/data/common/plant_genomes/Athaliana/araport11_hisat2"

# path to the directory you store the GTF file you used to create the above HiSAT2 index
export anno_dir="/data/common/plant_genomes/Athaliana/araport11_hisat2/Araport11_GFF3_genes_transposons.201606.gtf"




