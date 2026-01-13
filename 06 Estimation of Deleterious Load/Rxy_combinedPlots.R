# Rxy Visualization: Separate Plots for GL and Imputed Data
# ────────────────────────────────────────────────────────

setwd("/Users/hc/OneDrive - The University of Memphis/EasternDemo/Rxy_R/")

library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(gridExtra)
library(cowplot)
library(readxl)
library(egg)

# ─────────────────────────────────────────────
# Load and Filter Data
# ─────────────────────────────────────────────

#Load genotype likelihoods Rxy data
gl_data <- read_csv("rxy_jackknife_final.csv") %>%
  mutate(Source = "Genotype Likelihoods")

#Load imputed Rxy data
imp_data <- read_csv("Imputed_freq/imp_rxy_jackknife_final.csv") %>%
  mutate(Source = "Imputed")

#Define pop pairs of interest
target_pairs <- c("Tensas_vs_Southeast", "CoastalLA_vs_Southeast", "GreatLakes_vs_Southeast")

#Filter each dataset
gl_data <- gl_data %>% filter(PopPairs %in% target_pairs)
imp_data <- imp_data %>% filter(PopPairs %in% target_pairs)

#Reshape to long format
gl_long <- gl_data %>%
  pivot_longer(cols = c("Rlof", "Rmis"), names_to = "Category", values_to = "Rxy")

imp_long <- imp_data %>%
  pivot_longer(cols = c("Rlof", "Rmis"), names_to = "Category", values_to = "Rxy")

# ─────────────────────────────────────────────
# Generate Plots
# ─────────────────────────────────────────────

#Define a reusable custom plotting function
plot_rxy <- function(df, title) {
  # Reorder PopPairs for plotting
  df$PopPairs <- factor(df$PopPairs, levels = c(
    "GreatLakes_vs_Southeast",
    "CoastalLA_vs_Southeast",
    "Tensas_vs_Southeast"
  ))
  
  #Rename categories for legend labels
  df$Category <- recode(df$Category,
                        "Rlof" = "LOF",
                        "Rmis" = "Missense")
  
  #Set category colors
  category_colors <- c(
    "LOF" = "mediumorchid2",
    "Missense" = "grey70"
  )
  
  #Clean x-axis labels 
  x_labels <- c(
    "GreatLakes_vs_Southeast" = "Great Lakes",
    "CoastalLA_vs_Southeast" = "Coastal Louisiana",
    "Tensas_vs_Southeast" = "Tensas"
  )
  
  #Generate the plot
  ggplot(df, aes(x = PopPairs, y = Rxy, fill = Category, color = Category)) +
    geom_boxplot(outlier.shape = NA, alpha = 0.8, position = position_dodge(width = 0.75)) +
    geom_jitter(size = 1, alpha = 0.4,
                position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75)) +
    scale_fill_manual(values = category_colors) +
    scale_color_manual(values = category_colors) +
    scale_x_discrete(labels = x_labels) +
    labs(      
      title = expression(R[XY]~"(Genotype Likelihoods)"),
      y = expression(R[XY]),
      x = "Population"
    ) +    
    geom_hline(yintercept = 1, linetype = "dashed", color = "black", linewidth = 0.5) +  # Fixed geom_hline
      
    theme_bw(base_family = "Helvetica") +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 0, hjust = 0.5, size = 12, family = "Helvetica"),
      axis.text.y = element_text(size = 12, family = "Helvetica"),
      axis.title.x = element_text(size = 14, family = "Helvetica", face = "bold"),
      axis.title.y = element_text(size = 14, family = "Helvetica", face = "bold"),
      plot.title = element_text(size = 16, family = "Helvetica", face = "bold", hjust = 0.5),
      legend.title = element_text(size = 13, family = "Helvetica", face = "bold"),
      legend.text = element_text(size = 12, family = "Helvetica"),
      legend.position = "top"
    )
  
  
}



plot_gl <- plot_rxy(gl_long, "Jackknife Rxy (Genotype Likelihoods)")
plot_gl

ggsave("Rxy_GL_plot.pdf", plot_gl, width = 8, height = 6, dpi = 300)
ggsave("Rxy_GL_plot.png", plot_gl, width = 8, height = 6, dpi = 300)



# Plot for Imputed Data
plot_imp <- plot_rxy(imp_long, "Jackknife Rxy (Imputed Data)")
plot_imp

# ─────────────────────────────────────────────
# Display Plots
# ─────────────────────────────────────────────

print(plot_gl, )
print(plot_imp)
