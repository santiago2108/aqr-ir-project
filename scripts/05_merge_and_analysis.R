# Script 05: Merge X and Y, scatter plot and correlation
# Purpose: explore covariation between trade salience and UNGA voting similarity

library(tidyverse)

# --------------------------------------------------
# 1. Load data
# --------------------------------------------------

alignment <- read_csv("data_clean/colombia_us_vote_similarity.csv")
trade     <- read_csv("data_clean/colombia_us_trade_salience.csv")  

# --------------------------------------------------
# 2. Merge by year
# --------------------------------------------------

merged <- alignment |>
  inner_join(trade, by = "year")

# --------------------------------------------------
# 3. Check the merged dataset
# --------------------------------------------------

glimpse(merged)
summary(merged)

# --------------------------------------------------
# 4. Scatter plot
# --------------------------------------------------

p_scatter <- ggplot(merged, aes(x = trade_salience, y = vote_similarity)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "tomato") +
  labs(
    title = "Trade Salience and UNGA Voting Similarity: Colombia–United States",
    x     = "Trade salience (Colombia–US trade as share of Colombia's total trade)",
    y     = "UNGA voting similarity (share of identical votes)"
  )

p_scatter

png("outputs/scatter_trade_alignment.png", width = 7, height = 5,
    units = "in", res = 300)
print(p_scatter)
dev.off()

# --------------------------------------------------
# 5. Correlation
# --------------------------------------------------

cor(merged$trade_salience, merged$vote_similarity, use = "complete.obs")

# --------------------------------------------------
# 6. Save merged dataset
# --------------------------------------------------

write_csv(merged, "data_clean/colombia_us_merged.csv")