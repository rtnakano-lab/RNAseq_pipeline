#!/bin/bash
# config file for RNAseq_pipeline/1-QC_map_count.bash
# Originally by Ryohei Thomas Nakano, nakano@mpipz.mpg.de
# Last modified: 22 Sep 2021

# === Edit for each dataset === #
# path to raw fastq.gz data
export dat_dir="/biodata/dep_psl/common/Leonie/raw_data_old/mutants"

# path to the design file (a tab-deliminated file with a single-line header row, whose first column contains the list of library names)
export design_path="/biodata/dep_psl/grp_psl/ThomasN/RNAseq2/211220Leonie2-SRR2/original_data/design_add.txt"
export design_all_path="/biodata/dep_psl/grp_psl/ThomasN/RNAseq2/211220Leonie2-SRR2/original_data/design.txt"

# path to output directory where all intermediate and final data will be stored
export out_dir="/netscratch/dep_psl/grp_psl/ThomasN/RNAseq2/211220Leonie2-SRR2"


# === Normally you need to edit the followings only once === #
# path to softwares
export FASTP_PATH="/netscratch/dep_psl/grp_psl/ThomasN/tools"
export FEATURECOUNTS_PATH="/netscratch/dep_psl/grp_psl/ThomasN/tools/bin"

# path to directory you store the HiSAT2 index that you created
export HISAT2_INDEXES="/biodata/dep_psl/grp_psl/ThomasN/RNAseq_mapping/Hisat2/araport11" 

# path to the directory you store the GTF file you used to create the above HiSAT2 index
export anno_dir="/netscratch/dep_psl/grp_psl/ThomasN/resources/TAIR10/Araport11_GFF3_genes_transposons.201606.gtf"




