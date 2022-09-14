#!/bin/sh -l

# commands modified from original Kover tutorial (https://aldro61.github.io/kover/doc_tutorials.html)

# commands were run on Purdue RCAC Bell cluster (https://www.rcac.purdue.edu/compute/bell) 

# each antibiotic is modeled separately

# example below uses danofloxacin files

# log time before start
echo "start KOVER" >> log
date >> log

# run commands

# create Kover dataset
kover dataset create from-tsv --genomic-data ../MS_KmerMatrix.tsv --phenotype-description "Danofloxacin at breakpoint MIC" --phenotype-metadata DANO_0_5BP.tsv --output DANO_0_5BP.kover --progress

# count genomes and kmers
kover dataset info --dataset DANO_0_5BP.kover --genome-count --kmer-count

# choose split percentage, validation, and set seed for reproducibility
kover dataset split --dataset DANO_0_5BP.kover --id DANO_0_5BP_split --train-size 0.666 --folds 5 --random-seed 72 --progress

# learn the model using conjunction/disjunction and
# various trade-off values to determine weight of classifications
kover learn scm --dataset DANO_0_5BP.kover --split DANO_0_5BP_split --model-type conjunction disjunction --p 0.1 0.178 0.316 0.562 1.0 1.778 3.162 5.623 10.0 --max-rules 5 --hp-choice cv --n-cpu 2 --progress

#log end time
echo "end KOVER" >> log
date >> log