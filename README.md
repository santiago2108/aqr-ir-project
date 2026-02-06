# Colombia–US Trade Salience and UNGA Voting Similarity

Course project for “Applied Quantitative Research in International Relations” (15111).
This repository examines whether the salience of the Colombia–United States trade relationship
is associated with non-directional voting similarity with the United States in UN General Assembly roll-call voting.

## Research question
How does trade salience in asymmetric commercial relationships relate to UNGA voting similarity?
(illustrated with the Colombia–US dyad)

## Unit and level of analysis
- Unit of analysis: dyad–year (Colombia–US), annual observations
- Level of analysis: dyadic
- Dependent variable is non-directional voting similarity (not influence/compliance)

## Data
### UNGA voting similarity (Y)
Agreement is coded 1 when both countries cast the same vote (yes/no/abstain), 0 otherwise,
and aggregated to dyad–year as the share of identical votes.
Source: UNGA roll-call voting data via the R `unvotes` package.

### Trade salience (X) — planned
Trade salience is operationalized as the share of Colombia’s total trade (imports + exports)
conducted with the United States in a given year.
Planned sources: World Bank WITS / UN Comtrade.

## Reproduce Y workflow
Run scripts in order from the project root:
1. `scripts/01_setup.R`
2. `scripts/02_un_alignment_colombia.R`
3. `scripts/03_plot_alignment.R`

Expected outputs:
- `data_clean/colombia_us_vote_similarity.csv`
- `outputs/colombia_us_vote_similarity_trend.png`
- `outputs/colombia_us_vote_similarity_nvotes.png`

Note: plots are saved with `ggsave(..., device = grDevices::png)` due to graphics device issues on ChromeOS/Crostini.

## Repository structure
- `scripts/` — R pipeline scripts
- `data_raw/` — raw/large data (ignored)
- `data_clean/` — small, derived datasets used in analysis
- `outputs/` — figures used in the write-up
- `docs/` — notes and progress log

## Status
See `docs/progress.md` for milestone updates.

## Contact
Santiago Calderón Angarita
santiagocal09qgmail.com
