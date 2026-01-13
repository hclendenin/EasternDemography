#!/usr/bin/env python3

#import gzip
import re

#vcf_file = "/project/hrclndnn/EasternDemog/imputedEastern_pysam.ann.vcf"
#output_bed = "/project/hrclndnn/EasternDemog/imputedEastern_DNAzoo.ann.bed"

vcf_file = "/project/hrclndnn/EasternDemog/GLEastern.ann.vcf.gz"
output_bed = "/project/hrclndnn/EasternDemog/GLEastern_DNAzoo.ann.bed"

# Only these effects will be included
target_effects = {
    "frameshift_variant",
    "start_lost",
    "stop_gained",
    "missense_variant",
    "synonymous_variant"
}

def parse_ann_field(info):
    # Extracts all annotations from ANN=... field
    ann_match = re.search(r"ANN=([^;]+)", info)
    if not ann_match:
        return []
    annotations = ann_match.group(1).split(",")
    effects = [a.split("|")[1] for a in annotations if len(a.split("|")) > 1]
    return effects

with open(vcf_file, "rt") as vcf, open(output_bed, "w") as out:
    for line in vcf:
        if line.startswith("#"):
            continue
            
        fields = line.strip().split("\t")
        chrom, pos, var_id, info = fields[0], int(fields[1]), fields[2], fields[7]

        # Parse ID into scaffold and position
        id_match = re.match(r"(.+)_(\d+)$", var_id)
        if not id_match:
            continue  # skip if ID format is unexpected
        scaffold, id_pos = id_match.groups()

        # Get matching effects
        effects = parse_ann_field(info)
        matching_effects = [e for e in effects if e in target_effects]

        if matching_effects:
            # Output BED line (0-based start, 1-based end)
            bed_line = f"{scaffold}\t{int(id_pos)-1}\t{id_pos}\t{','.join(set(matching_effects))}\n"
            out.write(bed_line)
