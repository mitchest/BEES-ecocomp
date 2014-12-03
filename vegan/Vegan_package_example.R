## Vegan stuff
# for more on vegan http://cc.oulu.fi/~jarioksa/opetus/metodi/vegantutor.pdf
# especially on the contrained ordination

## Libraries ----
library(vegan)
library(MASS)
library(nlme)
library(mgcv)

## Data input ----
load("soil.data.Rdata")

  # check the objects in the list, there are 3 objects, bacterial phylum counts
  # soil chemistry and experimental treatment information.
names(soil.data.list)

  # extract the objects for convenience  
data=soil.data.list$Phylum.counts
treatments=soil.data.list$Treatments
chemistry=soil.data.list$Plot.chemistry

## Data summaries ----
  # Summary of the data, chemistry and treatments
summary(data) # sufficiently full of data, expect this at phylum level
summary(treatments) # block design (x3) with charcoal (BC) and fertiliser (Fert) addition among 30 plots
summary(chemistry) # Some parameters measured from the soil

  # Row sums of data
plot(rowSums(data) # there are relatively similar - there was a standardisation performed at some stage
     
     
## Distance/Similarity measures ----
  # vegan has various measures, but you can also create your own if required
  # it is a good point to see how the different measures correlate with each other
  # e.g. Bray-curtis of standardised data equates to the manhattan distance
data.bc=vegdist(data, "bray") # this is the bray curtis dissimilarity, ranging from 0:1.
data.man=vegdist(data,"manhattan")
data.jac=vegdist(data,"jaccard")
data.euc=vegdist(data,"euc")
data.can=vegdist(data,"canberra")
data.bi=vegdist(data,"binomial")
data.dis=cbind(Bray=data.bc,Manhattan=data.man,Jaccard=data.jac,Euclidean=data.euc,Canberra=data.can,Binomial=data.bi)
pairs(data.dis,upper.panel=NULL)

## Cluster diagrams (dendrograms) ----
  # It is a good idea to get an understanding of the numbers in your distance matrix
  # a cluster diagram is a good first step.
  # Create cluster information with BC dissimilarity in %, using the average linkage method
data.clus=hclust(data.bc*100, "average")

  # Plot the hclust object
plot(data.clus) # Samples are generally quite similar to each other, all within 10 % dissimilarity (90 % similar)

  # Some options for a nicer plot:
  # plot without axis, axes=F
  # extend lines to 0, hang=-1
  # add treatment labels, labels=
plot(data.clus, hang=-1,axes=F,xlab="",ylab="dissimilarity (%)",main="",labels=treatments$BCTotalFert)
  # add custom axis
  # max distance is
max(data.clus$height)
  # add axis
axis(2, seq(0,12,12/6),las=2)

  # see http://rpubs.com/gaston/dendrograms for more on these

## nMDS ordination ----
  # A common method to visualise distance matrices is to use an ordination or map
  # where points are projected on to 2 or 3 dimensions. The closer points are to each other
  # the similar they are, and the further away the more dissimilar they are.

  # Method 1 - isoMDS (MASS package)
  # This only uses the dist object so is quite basic
  # Create the mds object
data.mds1=isoMDS(data.bc)
  # A basic plot of the points without much information
data.ord=ordiplot(data.mds1, type="p")
  # A stress plot compares the distances in the ordination vs the distances in the distance matrix
stressplot(data.mds1,data.bc)
  # Generally a stress of < 0.2 means the ordiation depicts the multidimensional data well
data.mds1$stress/100 # I think it is divided by 100 here(?)

  # To pretty up your nMDS, you need to build up the plot.
data.ord=ordiplot(data.mds1, type="none")

  # All 10 treatments - a bit of finess is required to make this look nice. This is a quick attempt
  # Increase colour palette
palette(rainbow(10))
  # Set pch and colours (set twice if you want to change either)
ord.pch=as.numeric(treatments$BCTotalFert)
ord.col=as.numeric(treatments$BCTotalFert)
points(data.ord, "sites", pch=ord.pch,col=ord.col)
legend("topleft",legend=unique(treatments$BCTotalFert),pch=as.numeric(unique(treatments$BCTotalFert)),col=as.numeric(unique(treatments$BCTotalFert)))
palette("default")

  # Fertiliser only - much easier to show nicely
data.ord=ordiplot(data.mds1, type="none")
ord.pch=as.numeric(treatments$Fert)+14
ord.col=as.numeric(treatments$Fert)
points(data.ord, "sites", pch=ord.pch,col=ord.col)

  # Method 2 - metaMDS (Vegan)
  # This method uses the raw data matrix and the object produce has many more features.
data.mds2=metaMDS(data) # This automatically transforms your data and does some other things!!
data.mds2
plot(data.mds2,type="t")
stressplot(data.mds2,data.bc)
data.mds2$stress

data.mds3=metaMDS(data, autotransform=F) # Without transformation
stressplot(data.mds3,data.bc)
data.mds3$stress # Similar to isoMDS

plot(data.mds3, type="t") # Transformation has a big impact on the ordination!
  # Fertilser nMDS
plot(data.mds3, "sites", type="none")
points(data.mds3, "sites", pch=ord.pch,col=ord.col)
legend("topright",legend=unique(treatments$Fert),pch=as.numeric(unique(treatments$Fert))+14,col=as.numeric(unique(treatments$Fert)))

## PCoA ----
  # The metric version of nMDS
  # It should aim to preserve the distance in the distance matrix
  # Useful for observing interactions between factors
data.pcoa=cmdscale(data.bc)
plot(data.pcoa,type="n")
points(data.pcoa, pch=ord.pch,col=ord.col)

## PCA ----
  # Supposed to be good for analysis of non-sparse (no zeros) and environmental data
  # Uses euclidean distance implicitly
  # A first step is to look at the correlations between your variables and look for co-linearity
pairs(chemistry, upper.panel=NULL) # EC (electrical conductivity) is highly correlated with NO3

# Create a PCA
chem.pca=rda(chemistry)
chem.pca

  # Plot the PCA
biplot(chem.pca) # Dominance of variables due to magnitude
sort(colSums(chemistry))# N03 and Col_P have the largest values and hence dominate the PCA

  # Variance explained by each axis is in $CA$eig
  # The total variance is shown in the call to the chem.pca 360.3
  # I rounded the numbers to 2 decimals
round(chem.pca$CA$eig/360.3*100,2)
  
# Variable positions along PC axes
round(chem.pca$CA$v.eig,2)

# Scaling the data results in a correlation based PCA
chem.pca1=rda(chemistry,scale=T)
chem.pca1
chem.pca1$CA$eig/8*100 # much less variance explained than above, harder now the variables are scaled.
biplot(chem.pca1)

  # But what if we want to change points to colours etc
biplot(chem.pca1, type=c("t","n"),col="blue")
points(chem.pca1,pch=ord.pch, col=ord.col)

## Vector fitting ----
  # Can fit environmental variables on to species ordination
vec.fits=envfit(data.mds3,chemistry,permu=100)
vec.fits

plot(data.mds3,"sites")
  # Add vectors with p value < 0.1
plot(vec.fits,p.max=0.1)

## Surface fitting ----
  # Supposedly gives a interpretation than vector since lines can curve
  # They show no curves in this instance (see vegan tutor)
sur.fit=envfit(data.mds3~pH+NO3,chemistry)
plot(data.mds3,"sites")
plot(sur.fit)
  # Can investigate the model fits if saved in an object
NO3.fit=with(chemistry,ordisurf(data.mds3,NO3,add=T))
NO3.fit
  # Or simply add to the plot
with(chemistry,ordisurf(data.mds3,pH,add=T,col="green"))

## Factor centroid fitting ----

fac.fit=envfit(data.mds3~BCTotal+Fert,permu=100,data=treatments)
fac.fit

plot(data.mds3,"sites",type="none")
points(data.mds3, "sites", pch=ord.pch,col=ord.col)
legend("topright",legend=unique(treatments$Fert),pch=unique(ord.pch),col=unique(ord.col))
  # Ploting the object will add both vectors and factors depending on what was in the formula
plot(fac.fit)
  # Or if you're interested in only the factor centroids
plot(data.mds3,"sites",type="none")
points(data.mds3, "sites", pch=ord.pch,col=ord.col)
points(fac.fit$factors$centroids,cex=2, pch=4)

 # Another way to add centroids
plot(data.mds3,"sites", type="p")
ordispider(data.mds3, treatments$Fert, label=T)
ordiellipse(data.mds3,treatments$Fert,kind="se")

## ANOVA on distance/similarity measures ----
  # Check our treatments are correct
str(treatments)
treatments$Array=factor(treatments$Array)
str(treatments)
  # Do an ANOVA on dissimilarities
data.aov=adonis(data~Array+BCTotal*Fert,data=treatments,permu=100)
data.aov
  # There are no pairwise comparisons in adonis
  # However, I was able to replicate PERMANOVA pairwise comparisons
  # It might involve some R jujitsu to get it done automatically
  # e.g for the comparison of BCtotal 0 vs 1.1, given we treated them as factors
  # Index out those response
bb=treatments$BCTotal%in%c(0,1.1)
  # Fit the full model
data.pw1=adonis(data[bb,]~as.factor(Array)+as.factor(BCTotal)*Fert,data=treatments[bb,],permu=100)
data.pw1
  # The sqrt of the F value for BCTotal (or the comparison you are doing)
  # is the t value seen in PERMANOVA
  # not sure on the P value, since it is permuted, but it comes out very similar
cbind("t value"=sqrt(data.pw1$aov.tab[2,4]),"P"=(data.pw1$aov.tab[2,6]))

## Homogeneity of groups, dispersion ----
  # Should aid in description of ADONIS results
data.disp=betadisper(data.bc,treatments$Fert, type = "centroid")
plot(data.disp)
boxplot(data.disp)

  # ANOVA of dispersions
anova(data.disp)

## Mantel tests ----
  # Mantel tests prodive a method to correlate 2 distance matrices
  # Thus we can check whether the distances between samples using the chemistry data
  # reflect those in the phylum data
  # Use a scaled euclidean distance matrix
chem.euc=vegdist(chemistry, "euc",scale=T)

  # Pearsons correlation (linear)
mantel(data.bc,chem.euc, permutations = 100) # pretty low correlation. P value?
plot(data.bc,chem.euc)
  # Spearman rank correlation (monotonic)
mantel(data.bc,chem.euc,method = "spearman") # low correlation here too. P value?
plot(rank(data.bc),rank(chem.euc))
