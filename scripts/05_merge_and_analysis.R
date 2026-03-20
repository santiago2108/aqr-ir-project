######################################################################
# Name: Santiago Calderón Angarita
# Course: 15111 - Applied Quantitative Research in International Relations
# Date of submission: 23.03.2026
######################################################################

## RQ: Does trade salience predict UNGA voting alignment between Colombia and the United States? ##
#--------------------------------------------------------------------------------------------- #

# Packages:
library(tidyverse)
# For data wrangling and visualization

###########################
# Content of this R-script:
###########################

# (1) Load data
# (2) Merge X and Y by year (analysis period: 1991-2019)
# (3) Check the merged dataset
# (4) Pearson correlation (bivariate analysis)
# (5) Scatter plot: trade salience and voting similarity
# (6) Box plot: distribution of both variables side by side
# (7) Save merged dataset

##########################################################################################
##########################################################################################
#                    (1) Load data
# -------------------------------------------------------------------------------------- #

alignment <- read_csv("data_clean/colombia_us_vote_similarity.csv")
trade     <- read_csv("data_clean/colombia_us_trade_salience.csv")

##########################################################################################
#                    (2) Merge X and Y by year (analysis period: 1991-2019)
# -------------------------------------------------------------------------------------- #

# inner_join retains only years present in both datasets
# The year filter further restricts to the overlapping analysis period
merged <- alignment |>
  inner_join(trade, by = "year") |>
  filter(year >= 1991, year <= 2019)

##########################################################################################
#                    (3) Check the merged dataset
# -------------------------------------------------------------------------------------- #

# How many observations - sample size:
glimpse(merged)

# Central tendency, dispersion, and missing values for all variables:
summary(merged)

##########################################################################################
#          (4) Pearson correlation (bivariate analysis)
# -------------------------------------------------------------------------------------- #

# Pearson r measures the strength and direction of the linear relationship
# between trade salience (X) and voting similarity (Y).
# Values range from -1 (perfect negative) to +1 (perfect positive).
cor_result <- cor(merged$trade_salience, merged$vote_similarity, use = "complete.obs")
cor_result
# --> Interpretation: goes into the essay-like document

##########################################################################################
#          (5) Scatter plot: trade salience and voting similarity
# -------------------------------------------------------------------------------------- #

# Each point represents one dyad-year observation.
# --> The interpretation of the figure goes into the essay-like document

p_scatter <- ggplot(merged, aes(x = trade_salience, y = vote_similarity)) +
  geom_point() +
  labs(
    title = "Trade Salience and UNGA Voting Similarity: Colombia-United States, 1991-2019",
    x     = "Trade salience (Colombia-US trade as share of Colombia's total trade)",
    y     = "UNGA voting similarity (share of identical votes)"
  )

p_scatter

png("outputs/scatter_trade_alignment.png", width = 9, height = 5,
    units = "in", res = 300)
print(p_scatter)
dev.off()

##########################################################################################
#          (6) Box plot: distribution of both variables side by side
# -------------------------------------------------------------------------------------- #

# Reshape to long format to allow a faceted comparison of the two variables
# --> The interpretation of the figure goes into the essay-like document

merged_long <- merged |>
  select(year, trade_salience, vote_similarity) |>
  pivot_longer(
    cols      = c(trade_salience, vote_similarity),
    names_to  = "variable",
    values_to = "value"
  ) |>
  mutate(variable = recode(variable,
                           "trade_salience"  = "Trade salience",
                           "vote_similarity" = "Voting similarity"
  ))

p_boxplot <- ggplot(merged_long, aes(x = variable, y = value)) +
  geom_boxplot(width = 0.4, outlier.color = "tomato", outlier.size = 2) +
  geom_jitter(width = 0.08, alpha = 0.5, size = 1.5) +
  labs(
    title = "Distribution of Trade Salience and Voting Similarity, 1991-2019",
    x     = NULL,
    y     = "Share (0-1)"
  )

p_boxplot

png("outputs/boxplot_trade_alignment.png", width = 7, height = 5,
    units = "in", res = 300)
print(p_boxplot)
dev.off()

##########################################################################################
#                    (7) Save merged dataset
# -------------------------------------------------------------------------------------- #

write_csv(merged, "data_clean/colombia_us_merged.csv")

##########################################################################################
# END
##########################################################################################