
setwd("/Users/hc/OneDrive - The University of Memphis/EasternDemo/Rxy_R/")

library(dplyr)
library(tidyr)
library(ggplot2)

#1. Define paths
freq_path <- "/Users/hc/Library/CloudStorage/OneDrive-TheUniversityofMemphis/EasternDemo/Rxy_R/GL_freq/"
chr_list <- "/Users/hc/OneDrive - The University of Memphis/EasternDemo/Rxy_R/chr_list.txt"

#2. Read chromosomes list (assumes one per row)
chr <- read.table(chr_list, header = FALSE) # chr$V1 contains chromosome names

#3. Function to load .freq files
load_freq <- function(pop, category) {
  path <- paste0(freq_path, pop, ".", category, ".freq")
  df <- read.table(path, header = TRUE)
  df
}

#4. Load frequency data for all populations and categories
populations <- c("CoastalLA","Tensas","Southeast", "GreatLakes")
categories <- c("LOF", "missense", "synonymous")

# Initialize an empty list to hold all frequency data
freq_data <- list()

# Loop over each population and category & store as nested list freq_data[[pop]][[category]]
for (pop in populations) {
  freq_data[[pop]] <- list()  # Initialize sublist for this population
  
  for (cat in categories) {
    freq_data[[pop]][[cat]] <- load_freq(pop, cat)
  }
}

#5. Define populations and categories (case-sensitive)
pops <- c("CoastalLA","Tensas","Southeast", "GreatLakes")

#6. Initialize (empty) output dataframe to hold jackknife Rxy values
rxy_jackknife <- data.frame(
  PopPairs = character(),
  Chrom = character(),
  Rlof = numeric(),   # LOF
  Rmis = numeric(),   # missense
  stringsAsFactors = FALSE
)

#7. Function to join frequencies by CHROM and POS
join_freqs <- function(df1, df2) {
  joined_df <- dplyr::inner_join(df1, df2, by = c("CHROM", "POS"))
  joined_df <- joined_df[, c("CHROM", "POS", "Alt_freq.x", "Alt_freq.y")]
  colnames(joined_df) <- c("Chrom", "Pos", "Pop1_altfreq", "Pop2_altfreq")
  
  # Convert to numeric explicitly
  joined_df$Pop1_altfreq <- as.numeric(as.character(joined_df$Pop1_altfreq))
  joined_df$Pop2_altfreq <- as.numeric(as.character(joined_df$Pop2_altfreq))
  
  # Filter out rows where both alt frequencies are zero
  joined_df <- joined_df[joined_df$Pop1_altfreq != 0 | joined_df$Pop2_altfreq != 0, ]
  
  return(joined_df)
}

#8. L (directional load) and Rxy ratio calculation functions
# Define L function
L <- function(df_cat, df_syn) {
  sum(df_cat$Pop1_altfreq * (1 - df_cat$Pop2_altfreq)) /
    sum(df_syn$Pop1_altfreq * (1 - df_syn$Pop2_altfreq))
}

# Define R function
R <- function(df_cat, df_syn) {
  l_xy <- L(df_cat, df_syn)
  # Swap Pop1 and Pop2 frequencies for reverse comparison
  df_cat_rev <- df_cat[, c("Chrom", "Pos", "Pop2_altfreq", "Pop1_altfreq")]
  colnames(df_cat_rev)[3:4] <- c("Pop1_altfreq", "Pop2_altfreq")
  
  df_syn_rev <- df_syn[, c("Chrom", "Pos", "Pop2_altfreq", "Pop1_altfreq")]
  colnames(df_syn_rev)[3:4] <- c("Pop1_altfreq", "Pop2_altfreq")
  
  l_yx <- L(df_cat_rev, df_syn_rev)
  
  rxy <- l_xy / l_yx
  return(rxy)
}

##############see sanity checks scripts#####################

# Initialize a list to collect jackknife results
results_list <- list()
result_index <- 1

# Generate all unique, unordered population pairs
pop_pairs <- combn(pops, 2, simplify = FALSE)
total_pairs <- length(pop_pairs)

# Loop through each pair
for (pair_index in seq_along(pop_pairs)) {
  pair <- pop_pairs[[pair_index]]
  pop1 <- pair[1]
  pop2 <- pair[2]
  pair_name <- paste0(pop1, "_vs_", pop2)
  
  message("Processing pair ", pair_index, " of ", total_pairs, ": ", pair_name)
  message("  Started at: ", format(Sys.time(), "%H:%M:%S"))
  
  # Join data
  lof <- join_freqs(freq_data[[pop1]][["LOF"]],        freq_data[[pop2]][["LOF"]])
  mis <- join_freqs(freq_data[[pop1]][["missense"]],   freq_data[[pop2]][["missense"]])
  syn <- join_freqs(freq_data[[pop1]][["synonymous"]], freq_data[[pop2]][["synonymous"]])
  
  if (nrow(lof) > 0 && nrow(mis) > 0 && nrow(syn) > 0) {
    for (chrom_excl in chr$V1) {
      lof_k <- lof[lof$Chrom != chrom_excl, ]
      mis_k <- mis[mis$Chrom != chrom_excl, ]
      syn_k <- syn[syn$Chrom != chrom_excl, ]
      
      # Skip if no variants left or no frequency variation
      if (
        nrow(lof_k) > 0 && nrow(mis_k) > 0 && nrow(syn_k) > 0 &&
        (any(lof_k$Pop1_altfreq != lof_k$Pop2_altfreq) ||
         any(mis_k$Pop1_altfreq != mis_k$Pop2_altfreq))
      ) {
        # Log number of variants after filtering
        message("    Variants after exclusion: LOF = ", nrow(lof_k),
                ", Missense = ", nrow(mis_k), ", Syn = ", nrow(syn_k))
        
        r_lof_k <- R(lof_k, syn_k)
        r_mis_k <- R(mis_k, syn_k)
        
        results_list[[result_index]] <- data.frame(
          PopPairs = pair_name,
          Chrom = chrom_excl,
          Rlof = r_lof_k,
          Rmis = r_mis_k,
          stringsAsFactors = FALSE
        )
        result_index <- result_index + 1
        
        # Save partial results every 100 iterations
        if (result_index %% 100 == 0) {
          saveRDS(results_list, file = "rxy_jackknife_partial.rds")
          message("  Saved partial results at iteration ", result_index)
        }
      }
    }
  } else {
    message("  → Skipped pair due to no overlapping variants.")
  }
}

# Combine all jackknife results
rxy_jackknife <- bind_rows(results_list)
saveRDS(rxy_jackknife, file = "rxy_jackknife_final.rds")
write.csv(rxy_jackknife, "rxy_jackknife_final.csv", row.names = FALSE)

# ─────────────────────────────────────────────────────────
# ▶ Rxy Summary Stats (mean, SE, 95% CI) for each pair
# ─────────────────────────────────────────────────────────
rxy_summary <- rxy_jackknife %>%
  group_by(PopPairs) %>%
  summarise(
    Rlof_mean = mean(Rlof),
    Rlof_se = sd(Rlof) / sqrt(n()),
    Rlof_lowerCI = Rlof_mean - 1.96 * Rlof_se,
    Rlof_upperCI = Rlof_mean + 1.96 * Rlof_se,
    
    Rmis_mean = mean(Rmis),
    Rmis_se = sd(Rmis) / sqrt(n()),
    Rmis_lowerCI = Rmis_mean - 1.96 * Rmis_se,
    Rmis_upperCI = Rmis_mean + 1.96 * Rmis_se,
    .groups = "drop"
  )

write.csv(rxy_summary, "rxy_summary_stats.csv", row.names = FALSE)

# ─────────────────────────────────────────────────────────
# Boxplot
# ─────────────────────────────────────────────────────────
rxy_long <- rxy_jackknife %>%
  pivot_longer(cols = c("Rlof", "Rmis"), names_to = "Category", values_to = "Rxy")

ggplot(rxy_long, aes(x = PopPairs, y = Rxy, fill = Category)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.8, position = position_dodge(width = 0.75)) +
  geom_jitter(size = 1, alpha = 0.4,
              position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75)) +
  labs(title = "Jackknife Rxy Estimates by Population Pair",
       y = "Rxy", x = "Population Pair") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "top")

ggplot(rxy_long, aes(x = PopPairs, y = Rxy, fill = Category, color = Category)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.8, position = position_dodge(width = 0.75)) +
  geom_jitter(size = 1, alpha = 0.4,
              position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75)) +
  labs(title = "Jackknife Rxy Estimates by Population Pair",
       y = "Rxy", x = "Population Pair") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "top")


