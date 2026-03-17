######################################################################
# Name: Santiago Calderón Angarita
# Course: 15111 - Applied Quantitative Research in International Relations
# Date of submission: 23.03.2026
######################################################################

## RQ: Does trade salience predict UNGA voting alignment between Colombia and the United States? ##
#--------------------------------------------------------------------------------------------- #

# Packages:
library(tidyverse)
# For data wrangling and manipulation

library(unvotes)
# For UN General Assembly roll-call voting data

###########################
# Content of this R-script:
###########################

# (1) Load and join raw voting data
# (2) Extract Colombia and US votes separately
# (3) Pair votes and compute agreement
# (4) Aggregate to dyad-year level (Y variable)
# (5) Save clean output

##########################################################################################
##########################################################################################
#                    (1) Load and join raw voting data
# -------------------------------------------------------------------------------------- #

votes_full <- un_votes |>
  left_join(un_roll_calls, by = "rcid")

##########################################################################################
#                    (2) Extract Colombia and US votes separately
# -------------------------------------------------------------------------------------- #

co <- votes_full |>
  filter(country == "Colombia") |>
  select(rcid, date, vote_co = vote) |>
  distinct(rcid, .keep_all = TRUE)

us <- votes_full |>
  filter(country == "United States") |>
  select(rcid, vote_us = vote) |>
  distinct(rcid, .keep_all = TRUE)

##########################################################################################
#                    (3) Pair votes and compute agreement
# -------------------------------------------------------------------------------------- #

# Inner join retains only roll calls where both countries cast a vote
paired <- co |>
  inner_join(us, by = "rcid") |>
  mutate(
    agree = as.integer(vote_co == vote_us),  # 1 = identical vote, 0 = diverging
    year  = lubridate::year(lubridate::as_date(date))
  )

# Verify that each roll call appears only once
stopifnot(nrow(paired) == n_distinct(paired$rcid))

##########################################################################################
#                    (4) Aggregate to dyad-year level (Y variable)
# -------------------------------------------------------------------------------------- #

# vote_similarity: share of paired roll calls in which Colombia and the US voted identically
# n_votes: number of paired roll calls per year (used as a coverage cue in plots)
alignment_year <- paired |>
  group_by(year) |>
  summarise(
    vote_similarity = mean(agree, na.rm = TRUE),
    n_votes         = sum(!is.na(agree)),
    .groups         = "drop"
  )

##########################################################################################
#                    (5) Save clean output
# -------------------------------------------------------------------------------------- #

write_csv(alignment_year, "data_clean/colombia_us_vote_similarity.csv")

##########################################################################################
# END
##########################################################################################