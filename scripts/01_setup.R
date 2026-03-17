######################################################################
# Name: Santiago Calderón Angarita
# Course: 15111 - Applied Quantitative Research in International Relations
# Date of submission: 23.03.2026
######################################################################

## RQ: Does trade salience predict UNGA voting alignment between Colombia and the United States? ##
#--------------------------------------------------------------------------------------------- #

###########################
# Content of this R-script:
###########################

# (1) Install and load required packages

##########################################################################################
##########################################################################################
#                    (1) Install and load required packages
# -------------------------------------------------------------------------------------- #

pkgs <- c("tidyverse", "unvotes", "countrycode")
# tidyverse: data wrangling and visualization
# unvotes: UN General Assembly roll-call voting data
# countrycode: standardization of country identifiers

to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install) > 0) install.packages(to_install)

invisible(lapply(pkgs, library, character.only = TRUE))

##########################################################################################
# END
##########################################################################################