# Colombia–US Trade Salience and UNGA Voting Similarity

Course project for **Applied Quantitative Research in International Relations** (15111)  
Ludwig-Maximilians-Universität München — WiSe 2025/26  
Supervisor: Maria Camila Atehortua Cardona

This repository examines whether the salience of the Colombia–United States trade relationship
is associated with non-directional voting similarity in UN General Assembly roll-call voting.

---

## Research question

How does trade salience in asymmetric commercial relationships relate to UNGA voting similarity?
(Illustrated with the Colombia–US dyad, 1991–2019.)

---

## Unit and level of analysis

- **Unit of analysis:** dyad–year (Colombia–US), annual observations
- **Level of analysis:** dyadic
- **Dependent variable (Y):** UNGA voting similarity — share of identical recorded votes per year
- **Independent variable (X):** trade salience — Colombia–US bilateral trade as a share of Colombia's total merchandise trade

---

## Data sources

### Y — UNGA Voting Similarity
Voting similarity is measured as the share of roll-call votes in a given year in which both Colombia and the United States cast identical votes (yes or no), conditional on both having a recorded vote. Abstentions are excluded.

Source: UNGA roll-call voting data via the R `unvotes` package. Data covers 1946–2019.

### X — Trade Salience
Trade salience is operationalized as:

```
trade_salience = (Colombia–US bilateral trade) / (Colombia total trade)
```

where bilateral trade is the sum of Colombian exports to and imports from the United States.

- **Bilateral trade (numerator):** World Bank WITS portal — 33 annual Excel files downloaded manually, covering 1991–2023.
- **Total trade (denominator):** World Bank Development Indicators via the R `wbstats` package (indicators TX.VAL.MRCH.CD.WT and TM.VAL.MRCH.CD.WT).

---

## How to reproduce the analysis

Run scripts **in order** from the project root:

```
Rscript scripts/01_setup.R
Rscript scripts/02_vote_similarity.R
Rscript scripts/03_plot_alignment.R
Rscript scripts/04_trade_salience.R
Rscript scripts/05_merge_and_analysis.R
```

### Expected outputs

| Script | Output |
|--------|--------|
| `02_vote_similarity.R` | `data_clean/colombia_us_vote_similarity.csv` |
| `03_plot_alignment.R` | `outputs/colombia_us_vote_similarity_trend.png` |
| | `outputs/colombia_us_vote_similarity_trend_restricted.png` |
| | `outputs/colombia_us_vote_similarity_nvotes.png` |
| | `outputs/colombia_us_vote_similarity_boxplot.png` |
| `04_trade_salience.R` | `data_clean/colombia_us_trade_salience.csv` |
| | `outputs/colombia_us_trade_salience_restricted.png` |
| | `outputs/colombia_us_trade_salience_boxplot.png` |
| `05_merge_and_analysis.R` | `data_clean/colombia_us_merged.csv` |
| | `outputs/scatter_trade_alignment.png` |
| | `outputs/boxplot_trade_alignment.png` |

### Notes
- Plots are saved using `png()` + `print()` + `dev.off()` rather than `ggsave()` due to a graphics device conflict on ChromeOS/Crostini.
- The `wbstats` and `map_dfr()` functions used in scripts 04 and 05 are not part of the course curriculum but were introduced out of necessity for data retrieval and combining.
- If the error `object 'merged' not found` appears in script 05, re-run all scripts in sequence from a clean R session.

---

## Key finding

The Pearson correlation between trade salience and UNGA voting similarity over the 1991–2019 period is **r = −0.042**, indicating no meaningful linear association between the two variables. The result is discussed in the accompanying paper.

---

## Repository structure

```
├── scripts/
│   ├── 01_setup.R               # Environment setup and package loading
│   ├── 02_vote_similarity.R     # Y variable construction via unvotes
│   ├── 03_plot_alignment.R      # Y variable visualizations
│   ├── 04_trade_salience.R      # X variable construction
│   └── 05_merge_and_analysis.R  # Merge, scatter plot, Pearson correlation
├── data_raw/
│   └── wits/                    # Raw WITS Excel files (not tracked by Git)
├── data_clean/                  # Derived CSVs used in analysis
├── outputs/                     # All figures used in the paper
└── docs/                        # Notes and progress log
```

---

## Contact

Santiago Calderón Angarita  
santiagocal09@gmail.com