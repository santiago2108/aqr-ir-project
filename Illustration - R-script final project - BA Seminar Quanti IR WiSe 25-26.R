# ** Illustration of the R-script structure for the final project ** #
#     *** Do not dierctly copy - this serves as an illustration only! You can use this as a template and adapt it to your own needs ***      # 
# Please comment your RScript such that I know what you are doing and the intention behind it.     
######################################################################
# Name: XXXXXXXXXXXXXX
# Matriculation Nr. 000000
# Date of submission: xx.03.2026
######################################################################

   ## RQ: How does the regime type of states impact their likelihood of waging war? ##
     #---------------------------------------------------------------------------- #

# Packages:
library(tidyverse)
# For data wrangling and description

library(peacesciencer)
# To access the data from the COW institute on the outbreak of interstate war, and the data of the Polity IV/V project for data on the regime type of states.
# The sample is also constructed via this package  

library(countrycode)
# For the standardization of states' identifiers (if necessary)

library(DescTools)
# For tabulation of categorical variables


###########################
# Content of this R-script:
###########################


# (1) xxxxxxxxx  

# (2) xxxxxxxxx

# (3) xxxxxxxxx

# (4) xxxxxxxxx

# (5) xxxxxxxxxx


##########################################################################################
##########################################################################################
#                    (1)  Sample construction via peacesciencer
# -------------------------------------------------------------------------------------- #



##########################################################################################
#                      (2)    Construction of ID variables
# -------------------------------------------------------------------------------------- #

# ----------------------------------------------------------- #
# Labelling the units of interest (dyads) with countrycode()  #
# ----------------------------------------------------------- #


# This would be the case if you have to merge data sources together:
#                      (1.1.)       Data Merging via ID varbs or which ever procedure you use
# -------------------------------------------------------------------------------------- #  




##########################################################################################
#                      (3)        Sample description
# -------------------------------------------------------------------------------------- #
# How many observations - sample size:

# Cross-sectional? Time-Series/Longitudinal? Panel? Cross-sectional:

# How many unique dyads


# How many unique years


# From when to when?


##########################################################################################
#          (4)        Description of variables of interest in the sample
# -------------------------------------------------------------------------------------- #

# Missings??
missings_by_columns  = # this is the name
  function(data_list) { # this is the input/argument
    lapply(data_list, function(df) colSums(is.na(df)))# this is the body (with an embedded function)
  }

# create list containing the data
dfs <- list(
  state = data_state_yrs,
  dyad  = data_un_dyad_yrs
)
# apply newly created function to the objects indexed in the list
missings_by_columns(dfs)
nrow(data_state_yrs) # 11,859



#######################################
# a. Variation in the DV: War outbreak
#######################################

# Central tendency: Median and Mode + substantial interpretation #

# How do we find the mode? (other r script)
# Frequency tables
dev.off()
tab1(data_state_yrs$nominal_variable, # The nominal variable in this example captures if the political system of the country is presidential with yes and no. 
     sort.group = "decreasing", 
     cum.percent = TRUE)


# d. Visualization: Illustrative examples #
# --> The intepretation of the figure goes into the essay-like document

#######################################
# b. Variation in the IV: Regime type
#######################################

# Central tendency: mean and median + substantial interpretation #


# Dispersion: Variance, Standard deviation + substantial interpretation # 
# Variance
var(data_state_yrs$interval_variable, na.rm=T) # 519.14
# Standard deviation (SD)
sd(data_state_yrs$ratio_variable, na.rm = T) # 22,543,472 Yuans
# Range
range(data_state_yrs$ratio_variable, na.rm=T) # 0 to 693,600,000 Yuans
# Interquartile range (IQR): A single numeric value representing Q3 - Q1
IQR(data_state_yrs$ratio_variable, na.rm = TRUE) # 751,445 Yuan


# ** How to export this information at once!
# Summary statistics tables:(https://cran.r-project.org/web/packages/vtable/vignettes/sumtable.html)
st(data_state_yrs)
# --> The table 'summarises' the information of the variables according to their levels of measurement and, importantly, according to the number of complete observations (non-missings). When you see the second column from right to left (N), the number of observations used to calculate each of the statistics in the table varies according to the missing structure of the variable that is being described.
# Furthermore, for the categorical variables (nominal_variable and ordinal_variable), the table shows us the distribution according to the categories in each of these variables AFTER removing missings. These categorical variables do not have SD, min, pctl. 25, pctl. 75 nor max. 

# d. Visualization: Illustrative examples #
# --> The intepretation of the figure goes into the essay-like document


##########################################################################################
#    (5)        Bivariate Analysis: Testing the relationship between regime type 
#                         and the outbreak of war between states
# -------------------------------------------------------------------------------------- #

############################################
# b. Categorical x Metric + Interpretation #
############################################

# Difference in means across groups

# Step 1
mean_metricvarb = mean(data_state_yrs$metric_variable2)
print(mean_metricvarb)


# Step 2
mean_metricvarb_cat1 = mean(data_state_yrs[data_state_yrs$categorical_variable2=="below OECD average",]$metric_variable2)
print(mean_metricvarb_cat1)

mean_metricvarb_cat2 = mean(data_state_yrs[data_state_yrs$categorical_variable2=="above OECD average",]$metric_variable2)
print(mean_metricvarb_cat2)

# Step 3
mean_metricvarb_cat1 - mean_metricvarb_cat2
# --> Interpretation: ** 


# Two-sample t-test: Are these differences stat. significant?
t.test(metric_variable2 ~ categorical_variable2, 
       data = data_state_yrs,
       var.equal = F) # var.equal = T  

# Simple box plot
boxplot(metric_variable2 ~ categorical_variable2, 
        data = data_state_yrs,
        xlab = "Horizontal inequality",
        ylab = "% of pop with internet access",
        col = c("steelblue", "tomato"),
        border = "darkgray")

# --> ** Interpretation: Goes into the essay-like document

##########################################################################################
# END
#########################################################################################