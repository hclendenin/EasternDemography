#!/usr/bin/env python3

import gzip
from collections import defaultdict

#Input files and config
vcf_file = "/scratch/hrclndnn/EasternDemo/GLEastern.ann.vcf"
output_prefix = "/project/hrclndnn/EasternDemog/GLEastern_DNAzoo"

bamlist_dict = {
    "LARB": "/home/puckett3/scripts/LARB.bamlist.txt",
    "Tensas": "/home/puckett3/scripts/Tensas.bamlist.txt",
    "AppMtns": "/home/puckett3/scripts/AppMtns.bamlist.txt",
    "GL": "/home/puckett3/scripts/GL.bamlist.txt"
}

effect_categories = {
    "synonymous": {"synonymous_variant"},
    "missense": {"missense_variant"},
    "LOF": {"start_lost", "stop_gained"}
}

#Get sample names per population
def get_sample_names(bamlist):
    with open(bamlist, 'r') as f:
        return [line.strip().split('/')[-1].replace(".bam", "").split('.')[-1] for line in f]

pop_samples = {pop: set(get_sample_names(path)) for pop, path in bamlist_dict.items()}

#Prepare output file handles
output_files = {
    category: {
        pop: open(f"{output_prefix}.{category}.{pop}.bed", "w")
        for pop in pop_samples
    }
    for category in effect_categories
}

#Parse ANN field
def parse_ann_field(info):
    for entry in info.split(";"):
        if entry.startswith("ANN="):
            annotations = entry[len("ANN="):].split(",")
            return [a.split("|")[1] for a in annotations if len(a.split("|")) > 1]
    return []
