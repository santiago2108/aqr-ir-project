# Script 02: UN Alignment Variable (Y)
# Purpose: construct non-directional dyad-year UNGA voting similarity (Colombia-US)

library(tidyverse)
library(unvotes)

# --------------------------------------------------
# 1. Load and join raw voting data
# --------------------------------------------------

votes_full <- un_votes |>
  left_join(un_roll_calls, by = "rcid")

# --------------------------------------------------
# 2. Extract Colombia and US votes separately
# --------------------------------------------------

co <- votes_full |>
  filter(country == "Colombia") |>
  select(rcid, date, vote_co = vote) |>
  distinct(rcid, .keep_all = TRUE)

us <- votes_full |>
  filter(country == "United States") |>
  select(rcid, vote_us = vote) |>
  distinct(rcid, .keep_all = TRUE)

# --------------------------------------------------
# 3. Pair votes and compute agreement
# --------------------------------------------------

paired <- co |>
  inner_join(us, by = "rcid") |>
  mutate(
    agree = as.integer(vote_co == vote_us),
    year  = lubridate::year(lubridate::as_date(date))
  )

stopifnot(nrow(paired) == n_distinct(paired$rcid))

# --------------------------------------------------
# 4. Aggregate to dyad-year level
# --------------------------------------------------

alignment_year <- paired |>
  group_by(year) |>
  summarise(
    vote_similarity = mean(agree, na.rm = TRUE),
    n_votes         = sum(!is.na(agree)),
    .groups         = "drop"
  )

# --------------------------------------------------
# 5. Save
# --------------------------------------------------

write_csv(alignment_year, "data_clean/colombia_us_vote_similarity.csv")