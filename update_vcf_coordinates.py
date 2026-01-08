import pysam

# Input files
vcf_in_path = "/project/hrclndnn/EasternDemog/GLEastern_with_ids.vcf.gz"
bed_path = "/project/hrclndnn/EasternDemog/lifted_nodups_GLEastern.bed"
vcf_out_path = "/project/hrclndnn/EasternDemog/lifted_GLEastern_pysam.vcf.gz"

# Step 1: Read lifted coordinates into a dictionary
# BED columns: chrom  start  end  ID
lifted_coords = {}
with open(bed_path) as bedfile:
    for line in bedfile:
        chrom, start, end, variant_id = line.strip().split('\t')
        lifted_coords[variant_id] = (chrom, int(start) + 1)  # VCF is 1-based

# Step 2: Open input VCF
vcf_in = pysam.VariantFile(vcf_in_path, "r")

# Step 2.5: Add missing contigs to input header BEFORE creating output VCF
existing_contigs = set(vcf_in.header.contigs)
needed_contigs = {chrom for chrom, _ in lifted_coords.values()}
for chrom in needed_contigs:
    if chrom not in existing_contigs:
        vcf_in.header.add_line(f"##contig=<ID={chrom}>")

# Step 3: Open output VCF with updated header
vcf_out = pysam.VariantFile(vcf_out_path, "w", header=vcf_in.header)

# Step 4: Update records
updated = 0
skipped = 0

for rec in vcf_in:
    variant_id = rec.id
    if variant_id in lifted_coords:
        new_chrom, new_pos = lifted_coords[variant_id]
        rec.chrom = new_chrom
        rec.pos = new_pos
        vcf_out.write(rec)
        updated += 1
    else:
        skipped += 1

vcf_in.close()
vcf_out.close()

print(f"Updated: {updated} variants")
print(f"Skipped (not found in BED): {skipped}")
