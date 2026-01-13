# Scripts for file processing, analyses, and visualization for *Population specific bottlenecks inflated differentiation measures of Louisiana black bear and negate subspecific status* 

**<ins>01 Whole Genome Sequencing and Variant Calling</ins>**	
- [Creating ancestral reference as precursor to ANGSD processes](https://github.com/hclendenin/EasternDemography/blob/main/01%20Whole%20Genome%20Sequencing%20and%20Variant%20Calling/ancANGSD.sh)
- Imputation
- [Genotype likelihoods](https://github.com/hclendenin/EasternDemography/blob/main/01%20Whole%20Genome%20Sequencing%20and%20Variant%20Calling/angsd_Dec18_2024.sh)


**<ins>02 Population Structure</ins>**
- [Filtering, PCA, & Admixture](https://github.com/hclendenin/EasternDemography/blob/main/02%20Population%20Structure/admixture.sh)
- [Treemix](https://github.com/hclendenin/EasternDemography/blob/main/02%20Population%20Structure/treemix.sh)
- [Pairwise FST](https://github.com/hclendenin/EasternDemography/blob/main/02%20Population%20Structure/fst.pop.sh)



**<ins>03 Change in Population Size Through Time</ins>**
- [Single Population Site Frequency Spectra (GLs)](https://github.com/hclendenin/EasternDemography/blob/main/03%20Change%20in%20Population%20Size%20Through%20Time/stairwaySFS.sh)
- [Stairway](https://github.com/hclendenin/EasternDemography/blob/main/03%20Change%20in%20Population%20Size%20Through%20Time/stairway.sh)
-   - [Visualization (Stairway Plots)](https://github.com/hclendenin/EasternDemography/blob/main/03%20Change%20in%20Population%20Size%20Through%20Time/stairway.R)
- GONE
  - [Subsetting to pops of interest, run temp VCF through Plink for filtering, reformat map file, runs Plink & concatenates 50 independent runs](https://github.com/hclendenin/EasternDemography/blob/main/03%20Change%20in%20Population%20Size%20Through%20Time/gone.east.sh)
  - [Visualization](https://github.com/hclendenin/EasternDemography/blob/main/03%20Change%20in%20Population%20Size%20Through%20Time/gone.east.R)



**<ins>04 Population Divergence Timing</ins>**
  - Input:
    - MSMC2
    - [Masking with SNPable](https://github.com/hclendenin/EasternDemography/blob/main/04%20Population%20Divergence%20Timing/SNPable.sh)
 - [MSMC-IM](https://github.com/hclendenin/EasternDemography/blob/main/04%20Population%20Divergence%20Timing/eastern.msmcIM.sh)

**<ins>05 Inbreeding and Genetic Diversity</ins>**
  - [Runs of Homozygosity (ROH)](https://github.com/hclendenin/EasternDemography/blob/main/05%20Inbreeding%20and%20Genetic%20Diversity/Identifying%20Runs%20of%20Homozygosity%20(ROHs))
  - [Observed Heterozygosity (HO)](https://github.com/hclendenin/EasternDemography/blob/main/05%20Inbreeding%20and%20Genetic%20Diversity/Estimating%20Observed%20Heterozygosity%20(HO))


**<ins>06 Estimation of Deleterious Load:</ins>**
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
          - [Submission script](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.generateFreqs.sh)
       - [Script to correctly generate LOF freq files from VCF info](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/generate_LOF_freqs.sh)
          - [LOF freq submission script](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.generateLOFFreqs.sh)
    - [RXY calculations & visualizations](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/rxy_pipeline.R)
      - [Additional RXY visualizations](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/Rxy_combinedPlots.R)

    
 - **Allele frequency distributions with 2dSFS:**
    - ANGSD SFS for all Eastern populations
       - Sites file creation
          - [VCF to BED file](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/createSFSbeds_by_pop.py)
            - [Submission script](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.createSFSbeds_by_pop.sh)
          - [BED to POS file](https://github.com/hclendenin/EasternDemography/blob/main/06%20Estimation%20of%20Deleterious%20Load/job.ConvertBed2Pos.sh)
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

**<ins>07 Geographic Patterns of Adaptation:</ins>**
-  **RDA:**
    - Inputs:
      - [Genetic data into .raw file](https://github.com/hclendenin/EasternDemography/blob/main/07%20Geographic%20Patterns%20of%20Adaptation/eastern.RDA.dataprep.sh)
      - Environmental data (all processed in ArcPro)
    - Analytical scripts
      - [dbMEMs](https://github.com/hclendenin/EasternDemography/blob/main/07%20Geographic%20Patterns%20of%20Adaptation/dbMEM.R)
      - [RDA scripts (full and partial)](https://github.com/hclendenin/EasternDemography/blob/main/07%20Geographic%20Patterns%20of%20Adaptation/easternRDA.R)
      - Variance partitioning/ANOVAs
    - Visualization
      - RDA spatial visulizations and projections all done in ArcPro
      - [dbMEM visualization](https://github.com/hclendenin/EasternDemography/blob/main/07%20Geographic%20Patterns%20of%20Adaptation/FigureS9-dbMEM.R)   


**<ins>08 Selection and Diversification Scans:</ins>**
 - [Sliding window FST](https://github.com/hclendenin/EasternDemography/blob/main/08%20Selection%20and%20Diversification%20Scans/fst.eastern.sh)
 - [selscan for iHS and iHH12](https://github.com/hclendenin/EasternDemography/blob/main/08%20Selection%20and%20Diversification%20Scans/ihs_ihh12.eastern.sh)

    - Listed Item
 - **Subheading:**
    - Listed Item
  
- [Example link](https://example.com/)
- [Example link](https://example.com/)
