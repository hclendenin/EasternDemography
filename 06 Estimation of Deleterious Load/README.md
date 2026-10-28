**<ins>Estimation of Deleterious Load:</ins>**
 - **SnpEff Annotation:**
    - VCF reformatting for HalLiftover
      - [Liftover pipeline](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/liftover_pipeline.sh)
      - [Liftover helper script](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/update_vcf_coordinates.py)
       - [HalLiftover script for SnpEff annotation (DNAzoo to NCBI)](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/halLiftover_DNAZooToNCBI.sh)
    - [SnpEff script](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/Eastern_snpEffannotate.sh)
    - Annotated VCF reformatting and liftover
       - [HalLiftover script for downstream analyses (NCBI to DNAzoo)](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/halLiftover_eastern_NCBItoDNAZoo.sh)
       - [Formatting an annotated VCF with lifted coordinates](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/ann.vcf_to_bed.py)

  
 - **Population comparisons with RXY:**
    - Generating input files from annotated VCF
       - [Script to generate freq files from VCF info](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/generate_all_freqs.sh)
         - [Python script for VCF processing & calculations for freq files](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/make_freq_by_popAllCalledVar.py)
          - [Submission script](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.generateFreqs.sh)
       - [Script to correctly generate LOF freq files from VCF info](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/generate_LOF_freqs.sh)
          - [LOF freq submission script](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.generateLOFFreqs.sh)
    - [RXY calculations & visualizations](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/rxy_pipeline.R)
      - [Additional RXY visualizations](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/Rxy_combinedPlots.R)
	- Upcoming revisions:
		- LOF is the only category with multiple effects; verify that sites annotated with multiple LOF effects are only counted once.
 		- LOF effects to be calculated with other categories rather than separately.
    	- RXY jackknifing to be revised to iterate over fixed lengths rather than scaffolds

    
 - **Allele frequency distributions with 2dSFS:**
    - ANGSD SFS for all Eastern populations
       - Sites file creation
          - [VCF to BED file](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/createSFSbeds_by_pop.py)
            - [Submission script](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.createSFSbeds_by_pop.sh)
          - [BED to POS file](hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.ConvertBed2Pos.sh)
          - [Index POS file](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/index_pos_files.sh)
      - [SFS and realSFS](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.SFS_indexedPosfiles.sh)
    - [realSFS 2D SFS for population pairs](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.2dSFS.sh)
    - Heatmap plots of 2D SFS
    - [Rerunning for UARB analyses](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.SFS_UARB_otherLA_noF1s.sh)
      


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
