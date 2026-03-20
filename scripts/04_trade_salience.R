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

library(readxl)
# For reading the WITS bilateral trade Excel files

library(wbstats)
# For downloading Colombia's total trade from the World Bank API

###########################
# Content of this R-script:
###########################

# (1) Read and combine all WITS files (bilateral trade: Colombia-US)
# (2) Download Colombia's total trade from the World Bank
# (3) Compute trade salience (X variable)
# (4) Save clean output
# (5) Plot 1: Full-period time-series
# (6) Restrict to overlapping analysis period (1991-2019)
# (7) Plot 2: Restricted time-series with mean line and SD band
# (8) Plot 3: Box plot of trade salience (1991-2019)

##########################################################################################
##########################################################################################
#                    (1) Read and combine all WITS files (bilateral trade: Colombia-US)
# -------------------------------------------------------------------------------------- #

# One Excel file per year downloaded from the World Bank WITS portal.
# The sheet "Product" contains the aggregate trade values.
# trimws() removes whitespace from column names and values to prevent silent mismatches.
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

# Convert from thousands of USD to USD to match the World Bank denominator
bilateral <- bilateral_raw |>
  mutate(trade_with_us = (exports_to_us + imports_from_us) * 1000) |>
  select(year, trade_with_us)

##########################################################################################
#                    (2) Download Colombia's total trade from the World Bank
# -------------------------------------------------------------------------------------- #

# TX.VAL.MRCH.CD.WT: Merchandise exports (current USD)
# TM.VAL.MRCH.CD.WT: Merchandise imports (current USD)
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

##########################################################################################
#                    (3) Compute trade salience (X variable)
# -------------------------------------------------------------------------------------- #

# Trade salience: Colombia-US bilateral trade as a share of Colombia's total trade
# Values range from 0 (no trade with the US) to 1 (all trade is with the US)
trade_year <- col_total |>
  left_join(bilateral, by = "year") |>
  mutate(trade_salience = trade_with_us / colombia_total_trade) |>
  select(year, trade_salience)

##########################################################################################
#                    (4) Save clean output
# -------------------------------------------------------------------------------------- #

write_csv(trade_year, "data_clean/colombia_us_trade_salience.csv")

##########################################################################################
#                    (5) Plot 1: Full-period time-series
# -------------------------------------------------------------------------------------- #

# --> The interpretation of the figure goes into the essay-like document

p1 <- ggplot(trade_year, aes(x = year, y = trade_salience)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Trade Salience: Colombia-US trade as share of Colombia's total trade",
    x     = "Year",
    y     = "Trade salience (share)"
  )

p1

png("outputs/colombia_us_trade_salience.png", width = 7, height = 5, units = "in", res = 300)
print(p1)
dev.off()

##########################################################################################
#                    (6) Restrict to overlapping analysis period (1991-2019)
# -------------------------------------------------------------------------------------- #

# Analysis period defined by the overlap between WITS and UNGA data availability
trade_restricted <- trade_year |>
  filter(year >= 1991, year <= 2019)

# Descriptive statistics for the restricted period
mean_salience <- mean(trade_restricted$trade_salience, na.rm = TRUE)
sd_salience   <- sd(trade_restricted$trade_salience, na.rm = TRUE)

##########################################################################################
#                    (7) Plot 2: Restricted time-series with mean line and SD band
# -------------------------------------------------------------------------------------- #

# The shaded ribbon represents +/- one standard deviation around the mean
# --> The interpretation of the figure goes into the essay-like document

p2 <- ggplot(trade_restricted, aes(x = year, y = trade_salience)) +
  geom_ribbon(
    aes(ymin = mean_salience - sd_salience,
        ymax = mean_salience + sd_salience),
    fill  = "steelblue",
    alpha = 0.15
  ) +
  geom_hline(
    yintercept = mean_salience,
    color      = "steelblue",
    linetype   = "longdash",
    linewidth  = 0.8
  ) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = seq(1991, 2019, by = 4)) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Trade Salience: Colombia-US trade as share of Colombia's total trade, 1991-2019",
    x     = "Year",
    y     = "Trade salience (share)"
  )

p2

png("outputs/colombia_us_trade_salience_restricted.png", width = 9, height = 5, units = "in", res = 300)
print(p2)
dev.off()

##########################################################################################
#                    (8) Plot 3: Box plot of trade salience (1991-2019)
# -------------------------------------------------------------------------------------- #

# Jitter overlaid on the box plot to show the distribution of individual observations
# --> The interpretation of the figure goes into the essay-like document

p3 <- ggplot(trade_restricted, aes(x = "", y = trade_salience)) +
  geom_boxplot(width = 0.4, outlier.color = "tomato", outlier.size = 2) +
  geom_jitter(width = 0.08, alpha = 0.5, size = 1.5) +
  labs(
    title = "Distribution of Trade Salience, 1991-2019",
    x     = NULL,
    y     = "Trade salience (share)"
  )

p3

png("outputs/colombia_us_trade_salience_boxplot.png", width = 4, height = 5, units = "in", res = 300)
print(p3)
dev.off()

##########################################################################################
# END
##########################################################################################