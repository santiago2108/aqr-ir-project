library(tidyverse)

# (Optional but recommended) clean environment
rm(list = ls())

# Ensure output folder exists
dir.create("outputs", showWarnings = FALSE)

# Load the cleaned dyad–year dataset (from Script 02)
alignment_year <- read_csv("data_clean/colombia_us_vote_similarity.csv")

# Defensive check (fails early if something is wrong)
stopifnot(all(c("year", "vote_similarity", "n_votes") %in% names(alignment_year)))

# Long-run mean of voting similarity
mean_similarity <- mean(alignment_year$vote_similarity, na.rm = TRUE)

# --------------------------------------------------
# Plot 1: Basic time-series of voting similarity
# --------------------------------------------------

p1 <- ggplot(alignment_year, aes(x = year, y = vote_similarity)) +
  geom_line() +
  geom_smooth(
    method = "loess",
    se = FALSE,
    color = "tomato",
    linetype = "dashed"
  ) +
  geom_hline(
    yintercept = mean_similarity,
    color = "darkgreen",
    linetype = "longdash",
    linewidth = 0.8
  ) +
  geom_point() +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Colombia–US UNGA Voting Similarity Over Time",
    x = "Year",
    y = "Vote similarity (share of identical recorded votes)"
  )

p1

ggsave(
  "outputs/colombia_us_vote_similarity_trend.png",
  plot = p1,
  device = grDevices::png,
  width = 7,
  height = 5,
  dpi = 300
)

# --------------------------------------------------
# Plot 2: Voting similarity with vote-count cue
# --------------------------------------------------

p2 <- ggplot(alignment_year, aes(x = year, y = vote_similarity)) +
  geom_line(linewidth = 0.6) +
  geom_point(aes(size = n_votes), alpha = 0.7) +
  geom_hline(
    yintercept = mean_similarity,
    linetype = "dashed",
    linewidth = 0.7,
    color = "darkgreen"
  ) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Colombia–US UNGA Voting Similarity Over Time",
    subtitle = "Point size indicates the number of paired roll-call votes (coverage)",
    x = "Year",
    y = "Vote similarity (share of identical recorded votes)",
    size = "Paired votes (n)"
  )

p2

ggsave(
  "outputs/colombia_us_vote_similarity_nvotes.png",
  plot = p2,
  device = grDevices::png,
  width = 8,
  height = 5,
  dpi = 300
)

