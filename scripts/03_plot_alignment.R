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
# (2) Compute long-run mean (full period)
# (3) Plot 1: Basic time-series of voting similarity (full period)
# (4) Plot 2: Voting similarity with vote-count cue (full period)
# (5) Restrict to overlapping analysis period (1991-2019)
# (6) Plot 3: Time-series restricted to 1991-2019
# (7) Plot 4: Box plot of voting similarity (1991-2019)

##########################################################################################
##########################################################################################
#                    (1) Load data
# -------------------------------------------------------------------------------------- #

alignment_year <- read_csv("data_clean/colombia_us_vote_similarity.csv")

##########################################################################################
#                    (2) Compute long-run mean (full period)
# -------------------------------------------------------------------------------------- #

mean_similarity <- mean(alignment_year$vote_similarity, na.rm = TRUE)

##########################################################################################
#                    (3) Plot 1: Basic time-series of voting similarity (full period)
# -------------------------------------------------------------------------------------- #

# --> The interpretation of the figure goes into the essay-like document

p1 <- ggplot(alignment_year, aes(x = year, y = vote_similarity)) +
  geom_line() +
  geom_smooth(
    method   = "loess",
    se       = FALSE,
    color    = "tomato",
    linetype = "dashed"
  ) +
  geom_hline(
    yintercept = mean_similarity,
    color      = "darkgreen",
    linetype   = "longdash",
    linewidth  = 0.8
  ) +
  geom_point() +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Colombia-US UNGA Voting Similarity Over Time",
    x     = "Year",
    y     = "Vote similarity (share of identical recorded votes)"
  )

p1

png("outputs/colombia_us_vote_similarity_trend.png",
    width = 7, height = 5, units = "in", res = 300)
print(p1)
dev.off()

##########################################################################################
#                    (4) Plot 2: Voting similarity with vote-count cue (full period)
# -------------------------------------------------------------------------------------- #

# Point color encodes n_votes as a coverage cue: darker = more paired roll calls
# --> The interpretation of the figure goes into the essay-like document

p2 <- ggplot(alignment_year, aes(x = year, y = vote_similarity)) +
  geom_line(linewidth = 0.6) +
  geom_point(aes(color = n_votes), size = 2.5) +
  geom_hline(
    yintercept = mean_similarity,
    linetype   = "dashed",
    linewidth  = 0.7,
    color      = "darkgreen"
  ) +
  scale_color_gradient(low = "lightblue", high = "darkblue") +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title    = "Colombia-US UNGA Voting Similarity Over Time",
    subtitle = "Point color indicates the number of paired roll-call votes (coverage)",
    x        = "Year",
    y        = "Vote similarity (share of identical recorded votes)",
    color    = "Paired votes (n)"
  )

p2

png("outputs/colombia_us_vote_similarity_nvotes.png",
    width = 8, height = 5, units = "in", res = 300)
print(p2)
dev.off()

##########################################################################################
#                    (5) Restrict to overlapping analysis period (1991-2019)
# -------------------------------------------------------------------------------------- #

# The analysis period is determined by the overlap between the UNGA voting data
# and the bilateral trade data (WITS). Both are available from 1991 to 2019.
alignment_restricted <- alignment_year |>
  filter(year >= 1991, year <= 2019)

mean_similarity_restricted <- mean(alignment_restricted$vote_similarity, na.rm = TRUE)

##########################################################################################
#                    (6) Plot 3: Time-series restricted to 1991-2019
# -------------------------------------------------------------------------------------- #

# --> The interpretation of the figure goes into the essay-like document

p3 <- ggplot(alignment_restricted, aes(x = year, y = vote_similarity)) +
  geom_line() +
  geom_smooth(
    method   = "loess",
    se       = FALSE,
    color    = "tomato",
    linetype = "dashed"
  ) +
  geom_hline(
    yintercept = mean_similarity_restricted,
    color      = "darkgreen",
    linetype   = "longdash",
    linewidth  = 0.8
  ) +
  geom_point() +
  scale_x_continuous(breaks = seq(1991, 2019, by = 4)) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Colombia-US UNGA Voting Similarity, 1991-2019",
    x     = "Year",
    y     = "Vote similarity (share of identical recorded votes)"
  )

p3

png("outputs/colombia_us_vote_similarity_trend_restricted.png",
    width = 7, height = 5, units = "in", res = 300)
print(p3)
dev.off()

##########################################################################################
#                    (7) Plot 4: Box plot of voting similarity (1991-2019)
# -------------------------------------------------------------------------------------- #

# Jitter overlaid on the box plot to show the distribution of individual observations
# --> The interpretation of the figure goes into the essay-like document

p4 <- ggplot(alignment_restricted, aes(x = "", y = vote_similarity)) +
  geom_boxplot(width = 0.4, outlier.color = "tomato", outlier.size = 2) +
  geom_jitter(width = 0.08, alpha = 0.5, size = 1.5) +
  labs(
    title = "Distribution of Colombia-US UNGA Voting Similarity, 1991-2019",
    x     = NULL,
    y     = "Vote similarity (share of identical recorded votes)"
  )

p4

png("outputs/colombia_us_vote_similarity_boxplot.png",
    width = 6, height = 5, units = "in", res = 300)
print(p4)
dev.off()

##########################################################################################
# END
##########################################################################################