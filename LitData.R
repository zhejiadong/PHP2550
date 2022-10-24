library(tidyverse)
library(tableone)
library(stringdist)
library(knitr)
library(kableExtra)

## read data
food<- read.csv(file ="~/Library/CloudStorage/OneDrive-Personal/brown/PHP 2610 Casual inference
                /final report/isolates.csv" )

#create new dataset
df <- food
#change all empty values into NA
df$Organism.group[df$Organism.group == ""] = NA
df$Strain[df$Strain == ""] = NA
df$Isolate.identifiers[df$Isolate.identifiers == ""] = NA
df$Serovar[df$Serovar == ""] = NA
df$Isolate[df$Isolate == ""] = NA
df$Create.date[df$Create.date == ""] = NA
df$Location[df$Location == ""] = NA
df$Isolation.source[df$Isolation.source == ""] = NA
df$Isolation.type[df$Isolation.type == ""] = NA
df$SNP.cluster[df$SNP.cluster == ""] = NA
df$BioSample[df$BioSample == ""] = NA
df$Assembly[df$Assembly == ""] = NA
df$AMR.genotypes[df$AMR.genotypes == ""] = NA
df$Computed.types[df$Computed.types == ""] = NA


# Ensure all are factors
df[] <- lapply(df, function(x){return(as.factor(x))})

# Check missing values Table 1
apply(df, 2, function(x){return(sum(!is.na(x))/length(x))})  %>% kable(format = "latex",caption = "missing percentage", 
                                                                       booktabs=T, escape=T, align = "c") %>%
  kable_styling(full_width =FALSE, latex_options = c("hold_position"))%>%
  kable_material(c("striped", "hover", "condensed"))


### Preparing data for figure 1
isolation_sources <- unique(food$Isolation.source)
source_counts <- rep(0, length(isolation_sources))
for (i in 1:length(isolation_sources)){
  source_counts[i] <- sum(food$Isolation.source == isolation_sources[i])
}
isolation_frame <- data.frame(sources = isolation_sources, counts = source_counts)

top_sources <- isolation_frame$sources[isolation_frame$counts > 100]

###### Figure 1 count
ggplot(food[food$Isolation.source %in% top_sources,]) + 
  geom_bar(aes(x = Isolation.source)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  labs(title = "Counts For Each Isolation Source")

#######distance of isolation sources, which do not include in the report
distance_measures <- sapply(1:length(isolation_sources), function(x){
  stringdist(isolation_sources[1], isolation_sources[x], method = "cosine")
})
c(isolation_sources[11], isolation_sources[12])
stringdist(isolation_sources[11], isolation_sources[12], method ="cosine")
stringdist(isolation_sources[37], isolation_sources[38], method ="cosine")
stringdist(isolation_sources[41], isolation_sources[42], method ="cosine")
stringdist(isolation_sources[45], isolation_sources[14], method ="cosine")


strains <- unique(food$Strain)
strain_counts <- rep(0, length(strains))
for (i in 1:length(strains)){
  strain_counts[i] <- sum(food$Strain == strains[i])
}
strain_frame <- data.frame(strains, strain_counts)
top_strains <- strain_frame$strains[strain_frame$strain_counts > 3]

#remove missing strain observations
top_strains <- top_strains[c(1:2,4:11)]

####### Figure 2 counts
ggplot(food[food$Strain %in% top_strains,]) + 
  geom_point(aes(x = Strain, y = Isolation.source)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#get summary for min-same and min-diff Table 2
summary(food[,11:12]) %>% 
kable(format = "latex",caption = "summary statistics", booktabs=T, escape=T, align = "c") %>%
  kable_styling(full_width =FALSE, latex_options = c("hold_position"))%>%
  kable_material(c("striped", "hover", "condensed"))

### transfromation data for figure 3
strain_minsame <- rep(0, length(top_strains))
strain_mindiff <- rep(0, length(top_strains))
for (i in 1:length(top_strains)){
  strain_minsame[i] <- mean(food[food$Strain == top_strains[i], 11], na.rm=T)
  strain_mindiff[i] <- mean(food[food$Strain == top_strains[i], 12], na.rm=T)
}
minvals <- data.frame(strains = top_strains, minsame = strain_minsame, mindiff = strain_mindiff)
minvals_l <- minvals %>% pivot_longer(cols = c("minsame", "mindiff"), names_to = "Min_Value", values_to = "Average")


######## Figure 3 distribution
ggplot(minvals_l) + 
  geom_point(aes(x = strains, y = Average, color = Min_Value)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  labs(title = "Average Min Values For Each Strain")