**<ins>Estimation of Deleterious Load:</ins>**
 - **SnpEff Annotation:**
    - VCF reformatting for HalLiftover
      - [Liftover pipeline](https://github.com/hclendenin/EasternDemography/blob/main/liftover_pipeline.sh)
      - [Liftover helper script](https://github.com/hclendenin/EasternDemography/blob/main/update_vcf_coordinates.py)
       - [HalLiftover script for SnpEff annotation (DNAzoo to NCBI)](https://github.com/hclendenin/EasternDemography/blob/main/halLiftover_DNAZooToNCBI.sh)
    - [SnpEff script](https://github.com/hclendenin/EasternDemography/blob/main/Eastern_snpEffannotate.sh)
    - Annotated VCF reformatting and liftover
       - [HalLiftover script for downstream analyses (NCBI to DNAzoo)](https://github.com/hclendenin/EasternDemography/blob/main/halLiftover_eastern_NCBItoDNAZoo.sh)
       - [Formatting an annotated VCF with lifted coordinates](https://github.com/hclendenin/EasternDemography/blob/main/ann.vcf_to_bed.py)

  
 - **Population comparisons with RXY:**
    - Generating input files from annotated VCF
       - [Script to generate freq files from VCF info](https://github.com/hclendenin/EasternDemography/blob/main/generate_all_freqs.sh)
         	-[Python script to for VCF processing & calculations for freq files](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/make_freq_by_popAllCalledVar.py)
          - [Submission script](https://github.com/hclendenin/EasternDemography/blob/main/job.generateFreqs.sh)
       - [Script to correctly generate LOF freq files from VCF info](https://github.com/hclendenin/EasternDemography/blob/main/generate_LOF_freqs.sh)
          - [LOF freq submission script](https://github.com/hclendenin/EasternDemography/blob/main/job.generateLOFFreqs.sh)
    - [RXY calculations & visualizations](https://github.com/hclendenin/EasternDemography/blob/main/rxy_pipeline.R)
      - [Additional RXY visualizations](https://github.com/hclendenin/EasternDemography/blob/main/Rxy_combinedPlots.R)

    
 - **Allele frequency distributions with 2dSFS:**
    - ANGSD SFS for all Eastern populations
       - Sites file creation
          - [VCF to BED file](https://github.com/hclendenin/EasternDemography/blob/main/createSFSbeds_by_pop.py)
            - [Submission script](https://github.com/hclendenin/EasternDemography/blob/main/job.createSFSbeds_by_pop.sh)
          - [BED to POS file](hclendenin/EasternDemography/blob/main/job.ConvertBed2Pos.sh)
          - [Index POS file](https://github.com/hclendenin/EasternDemography/blob/main/index_pos_files.sh)
      - [SFS and realSFS](https://github.com/hclendenin/EasternDemography/blob/main/job.SFS_indexedPosfiles.sh)
    - [realSFS 2D SFS for population pairs](https://github.com/hclendenin/EasternDemography/blob/main/job.2dSFS.sh)
    - Heatmap plots of 2D SFS
    - [Rerunning for UARB analyses](https://github.com/hclendenin/EasternDemography/blob/main/job.SFS_UARB_otherLA_noF1s.sh)
      


 - **Variant distributions across subpopulations:**
    - Annotated alleles fixed across all Eastern lineage samples
    - Annotated alleles shared across all Eastern lineage samples
    - Euler plot for the Great Lakes, UARB, and other LA populations
    - Frequency of alleles shared between UARB and other LA populations
		- Rerunning for UARB analyses
	-	Variant distributions across subpopulations:
		- Annotated alleles fixed across all Eastern lineage samples
		- Annotated alleles shared across all Eastern lineage samples
		- Euler plot for the Great Lakes, UARB, and other LA populations
		- Frequency of alleles shared between UARB and other LA populations
