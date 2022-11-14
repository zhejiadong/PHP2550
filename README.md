# PHP 2550 Final Project

Group Member: Abraham Liu, Asghar Shah, Zhejia Dong

This project focus on modeling foodborne illness outbreak by time series model and predicting futurn outbreaks.

Data source: This project use the dataset from the NCBI's publicly available adataset on foodborne illness outbreak reports: https://www.ncbi.nlm.nih.gov/pathogens/.  We restricted the dataset to only have listeria beakout reports.

The LitData.R code is for the data exploration part. We first change the mising values (Table 1 in report), and plot the the counts of the most popular sources for these outbreaks (Figure 1 in report). We then look at the isolation sources for the most common strains in the dataset (Figure 2 in report). We provide the distribution of "min.some" and  "min.diff" variables (Table 2 in report), and a plot of the mean of the "Min-same" and "Min-diff" variables
for each of the most popular strains (Figure 3 in report). 

The corresponding codes to generate tables and figures are all in LitData.R with clear notation.

The PHP2550_timeseries.Rmd is the rmarkdown file for the methods and nalysis plan.
