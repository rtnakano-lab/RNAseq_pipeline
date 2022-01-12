# RNAseq_pipeline  

Thie is a pipeline that processes raw RNAseq reads for subsequent statistical analyses.

INPUT: raw fastq.gz files (de-multiplexed)  
OUTPUT: count_table.txt (gene-wise)

Algorithms:
- QC: FASTP
- mapping: HiSAT2
- read counting: featureCounts

The example scripts use th Arabidopsis thaliana genome annotation (araport11), guided by splicing sites and exon positions, which can be easily modified and adapted to your own reference sequences/annotations.

##### [1-QC_map_count.bash](1-1-QC_map_count.bash)  
For single-end read data.  
It should come along with 0-config.bash

##### [1-QC_map_count-PE.bash](1-1-QC_map_count-PE.bash)  
For paired-end read data.  
It should come along with 0-config.bash

##### [1-QC_map_count_add.bash](1-1-QC_map_count_add.bash)  
For additing additional samples into already-processed samples.
Optimized for single-end read data.  
It should come along with 0-config_add.bash

-----

### Usage (example)  
```
# normal use:
./1-QC_map_count.bash ./0-config.bash

# in case of running it on a LSF cluster management system:
bsub \
  -J [job_name] \
  -q multicore40 \
  -R "rusage[mem=6400] span[hosts=1]" \
  -M 12800 \
  ./1-QC_map_count.bash ./0-config.bash
```




