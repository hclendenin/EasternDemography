###REMOVE THIS FROM PUBLIC REPOSITORY-- THIS SCRIPT DIDN'T OPERATE CORRECTLY


#!/bin/bash
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --job-name=create.pos
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=hrclndnn@memphis.edu
#SBATCH --output=create_pos_files.out
#SBATCH --error=create_pos_files.err

module load python/3.10.13/gcc.8.5.0

VCF=/scratch/hrclndnn/EasternDemo/GLEastern.ann.vcf
OUTDIR=/scratch/hrclndnn/EasternDemo/

mkdir -p "$OUTDIR"

declare -A BAMLISTS
BAMLISTS=(
  ["LARB"]="/home/puckett3/scripts/LARB.bamlist.txt"
  ["Tensas"]="/home/puckett3/scripts/Tensas.bamlist.txt"
  ["AppMtns"]="/home/puckett3/scripts/AppMtns.bamlist.txt"
  ["GL"]="/home/puckett3/scripts/GL.bamlist.txt"
)

echo "Generating .pos files from VCF..."
python3 <<EOF
import gzip
from collections import defaultdict

vcf_file = "$VCF"
bamlist_dict = {
    "LARB": "${BAMLISTS["LARB"]}",
    "Tensas": "${BAMLISTS["Tensas"]}",
    "AppMtns": "${BAMLISTS["AppMtns"]}",
    "GL": "${BAMLISTS["GL"]}"
}
output_prefix = "$OUTDIR"

effect_categories = {
    "synonymous": {"synonymous_variant"},
    "missense": {"missense_variant"},
    "LOF": {"start_lost", "stop_gained"}
}

def get_sample_names(bamlist):
    with open(bamlist, 'r') as f:
        return [line.strip().split('/')[-1].replace(".bam", "").split('.')[-1] for line in f]

pop_samples = {pop: set(get_sample_names(path)) for pop, path in bamlist_dict.items()}

output_files = {
    cat: {pop: open(f"{output_prefix}/{cat}.{pop}.pos", "w") for pop in pop_samples}
    for cat in effect_categories
}

open_func = gzip.open if vcf_file.endswith(".gz") else open
with open_func(vcf_file, "rt") as vcf:
    for line in vcf:
        if line.startswith("#CHROM"):
            header = line.strip().split("\t")
            vcf_samples = header[9:]
            sample_idx = {s: i for i, s in enumerate(vcf_samples)}
            continue
        elif line.startswith("#"):
            continue

        fields = line.strip().split("\t")
        if len(fields) < 10:
            continue

        chrom, pos, info = fields[0], fields[1], fields[7]
        genotypes = fields[9:]

        def parse_ann(info):
            for entry in info.split(";"):
                if entry.startswith("ANN="):
                    return [a.split("|")[1] for a in entry[4:].split(",")]
            return []

        effects = parse_ann(info)
        if not effects:
            continue

        for cat, targets in effect_categories.items():
            if not set(effects) & targets:
                continue

            for pop, samples in pop_samples.items():
                has_alt = any(
                    "1" in genotypes[sample_idx[s]].split(":")[0]
                    for s in samples if s in sample_idx
                )
                if has_alt:
                    output_files[cat][pop].write(f"{chrom}\t{pos}\n")

for cat_dict in output_files.values():
    for f in cat_dict.values():
        f.close()
EOF

echo "Done creating .pos files."
