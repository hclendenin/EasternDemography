 
#!/usr/bin/env python3
import argparse, pysam, csv
from collections import defaultdict, Counter

def main():
    p = argparse.ArgumentParser()
    p.add_argument('--vcf', required=True)
    p.add_argument('--map', required=True)
    p.add_argument('--category', required=True)
    p.add_argument('--output', required=True)
    args = p.parse_args()

    # Read sample -> population map
    sample_to_pop = {}
#    with open(args.map) as f:
##        rdr = csv.DictReader(f, delimiter='\t')
#        rdr = csv.DictReader(f, delimiter=' ')
#        for row in rdr:
#            sample_to_pop[row['SampleID']] = row['PopName']
    with open(args.map) as f:
        next(f)  # skip header line
        for line in f:
            sample, pop = line.strip().split()
            sample_to_pop[sample] = pop

    pop_counts = {}  # key=(pop, chrom, pos, ref, alt) -> (ALT_COUNT, N_CHR)
    pop_total_counts = defaultdict(lambda: defaultdict(lambda: [0, 0]))  # pop -> variant count contexts

    vcf = pysam.VariantFile(args.vcf)
    #for rec in vcf.fetch():
    #    chrom, pos, ref = rec.chrom, rec.pos, rec.ref
    #    for allele, samples in rec.alleles, rec.samples.items():
    #        pass
    # Actually use alternative allele counting per sample
    for rec in vcf.fetch():
        chrom, pos, ref = rec.chrom, rec.pos, rec.ref
        alts = rec.alts
        if not alts:
            continue
        for sample in rec.samples:
            pop = sample_to_pop.get(sample)
            if not pop:
                continue
            gt = rec.samples[sample]['GT']
            if gt is None:
                continue
            # count ALT allele count
#            alt_count = sum(1 for x in gt if x and x > 0)
#            if alt_count == 0:
#                continue
            # always diploid
#            pop_total_counts[pop][(chrom, pos, ref, alts[0])][1] += 2  # N_CHR
#            pop_total_counts[pop][(chrom, pos, ref, alts[0])][0] += alt_count  # ALT count

            called_alleles = [x for x in gt if x is not None]

            if not called_alleles:
                continue

            alt_count = sum(1 for x in called_alleles if x > 0)
            n_chr = len(called_alleles)

            key = (chrom, pos, ref, alts[0])

            pop_total_counts[pop][key][0] += alt_count
            pop_total_counts[pop][key][1] += n_chr
            # examples:
            # 0/0 → ALT_COUNT +0, N_CHR +2
            # 0/1 → ALT_COUNT +1, N_CHR +2
            # 1/1 → ALT_COUNT +2, N_CHR +2

    # Now write freq files per population
    for pop, variants in pop_total_counts.items():
        outpath = f"{args.output}/{pop}.{args.category}.freq"
        with open(outpath, 'w') as fo:
            fo.write("CHROM\tPOS\tREF\tALT\tMAF\tAlt_freq\tN_CHR\n")
            for (chrom, pos, ref, alt), (alt_count, n_chr) in variants.items():
                maf = min(alt_count, n_chr - alt_count) / n_chr
                alt_freq = alt_count / n_chr
                fo.write(
                    f"{chrom}\t{pos}\t{ref}\t{alt}\t"
                    f"{maf:.4f}\t{alt_freq:.4f}\t{n_chr}\n"
                )

if __name__ == "__main__":
    main()
