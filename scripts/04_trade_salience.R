# Script 04: Trade Salience Variable (X)
# Purpose: construct annual trade salience (Colombia-US trade / Colombia total trade)

library(tidyverse)
library(readxl)
library(wbstats)

# --------------------------------------------------
# 1. Read and combine all WITS files (bilateral trade)
# --------------------------------------------------

wits_files <- list.files(
  path       = "data_raw/wits",   
  pattern    = "WITS-Product_.*\\.xlsx",
  full.names = TRUE
)

bilateral_raw <- map_dfr(wits_files, ~ {
  df <- read_xlsx(.x, sheet = "Product")
  colnames(df) <- trimws(colnames(df))
  df |>
    filter(trimws(`Product Group`) == "All Products") |>
    select(year = Year,
           exports_to_us   = `Export (US$ Thousand)`,
           imports_from_us = `Import (US$ Thousand)`)
})

bilateral <- bilateral_raw |>
  mutate(trade_with_us = (exports_to_us + imports_from_us) * 1000) |>
  select(year, trade_with_us)

# --------------------------------------------------
# 2. Colombia total trade (World Bank)
# --------------------------------------------------

col_exports_total <- wb_data(
  indicator  = "TX.VAL.MRCH.CD.WT",
  country    = "COL",
  start_date = 1991,
  end_date   = 2023
) |> select(year = date, col_exports = TX.VAL.MRCH.CD.WT)

col_imports_total <- wb_data(
  indicator  = "TM.VAL.MRCH.CD.WT",
  country    = "COL",
  start_date = 1991,
  end_date   = 2023
) |> select(year = date, col_imports = TM.VAL.MRCH.CD.WT)

col_total <- col_exports_total |>
  left_join(col_imports_total, by = "year") |>
  mutate(colombia_total_trade = col_exports + col_imports) |>
  select(year, colombia_total_trade)

# --------------------------------------------------
# 3. Compute trade salience
# --------------------------------------------------

trade_year <- col_total |>
  left_join(bilateral, by = "year") |>
  mutate(trade_salience = trade_with_us / colombia_total_trade) |>
  select(year, trade_salience)

# --------------------------------------------------
# 4. Save
# --------------------------------------------------

write_csv(trade_year, "data_clean/colombia_us_trade_salience.csv")

# --------------------------------------------------
# 5. Plot
# --------------------------------------------------

p <- ggplot(trade_year, aes(x = year, y = trade_salience)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Trade Salience: Colombia-US trade as share of Colombia's total trade",
    x     = "Year",
    y     = "Trade salience (share)"
  )

p

png("outputs/colombia_us_trade_salience.png", width = 7, height = 5, units = "in", res = 300)
print(p)
dev.off()