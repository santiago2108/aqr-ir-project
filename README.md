# Colombia–US Trade Salience and UNGA Voting Similarity

Course project for “Applied Quantitative Research in International Relations” (15111).
This repository examines whether the salience of the Colombia–United States trade relationship
is associated with Colombia’s voting similarity with the United States in the UN General Assembly.

## Research question
How does trade salience in commercial relationships relate to political alignment in the United Nations General Assembly? (Colombia–US dyad) 

## Unit of analysis
Dyad–year, focusing on the Colombia–United States relationship observed annually over time.

## Data
### UNGA voting similarity (dependent variable)
Political alignment is operationalized as non-directional voting similarity between Colombia and the United States in the UN General Assembly.
Agreement is coded 1 when both cast the same vote (yes/no/abstain), 0 otherwise, and aggregated to dyad–year as the share of identical votes.
Source: UNGA roll-call voting data via the R `unvotes` package.

### Trade salience (independent variable)
Trade salience is operationalized as the share of Colombia’s total trade (imports + exports) conducted with the United States in a given year.
Planned sources: World Bank WITS / UN Comtrade (annual bilateral trade flows).

### Data storage policy
Raw/large data files are NOT stored in this GitHub repository.
They are kept in Google Drive and linked locally via `data/`.

## Empirical strategy (planned)
1. Construct dyad–year dataset (UNGA voting similarity + trade salience).
2. Descriptive time-series plots for both variables.
3. Explore covariation with scatter plots, correlations, and simple bivariate regressions.
Interpretation is descriptive/exploratory (no causal claims).

## Repository structure
- `src/`     – scripts (run in order)
- `data/`    – Google Drive link (ignored by Git)
- `docs/`    – notes / write-up material
- `output/`  – generated tables/figures (ignored by Git)

## Reproducibility
- R project workflow
- Recommended: `renv` for package reproducibility

## Status
- UNGA alignment variable constructed at dyad–year level; descriptive statistics and time-series plot produced.
- Next steps: obtain/clean annual bilateral trade data; construct trade salience; merge; explore covariation.

## Contact
Santiago Calderón Angarita
