install.packages("reshape2")
install.packages("plyr")
install.packages("dplyr")
install.packages("ggvis")

library(plyr)
library(dplyr)
library(reshape2)
library(ggvis)


# for a tutorial on dplyr basics:
# http://rpubs.com/hadley/dplyr-intro

# then try:
#reshape package -  I use these alot- I mainly use them to 
#melt()
#cast()
#e.g. load a multivariate abundance dataset (from package mvabund)
library(mvabund)
data(Tasmania)
dat = tbl_df(data.frame( Tasmania$copepods)) 
dat = dat %>%
mutate(Site = rownames(dat), Treatment = Tasmania$treatment)

#Now I want the matrix in long form (for whatever reason- I frequently need to do this kind of transformation)
dat %.%
  melt(id.vars=c("Site", "Treatment"), variable.name = "Species", value.name = "abund") %>%
  group_by(Species, Treatment) %>%
  summarise (mean_abundance = mean(abund))

#Seamless visualisation using ggvis

dat %.%
  melt(id.vars=c("Site", "Treatment"), variable.name = "Species", value.name = "abund") %>%
  group_by(Species, Treatment) %>%
  summarise (mean_abundance = mean(abund)) %>%
  ggvis(~Treatment, ~mean_abundance, fill = ~Species) %>% layer_points()

#WHAT ARE THE ADVANTAGES OF ALL THIS

#FAST! Allegedly much much faster than plyr and standard R operations like []. It's writting using Rcpp, meaning all the heavy stuff is done in C. 

#If you use sql databases, you can dplyr in similar ways- it can process data in remote places. This is a tale for another day, as I don't use databases.

#The %>% notation is preetty and so are the functions (though many of these available in plyr).

#Talks to ggvis....but at the moment ggvis lacks all the functionality of ggplot. E.g. Can't do facet plots. This should change...
