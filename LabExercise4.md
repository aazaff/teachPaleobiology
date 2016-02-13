# Lab Exercise 4

Modelling ecological niches using multivariate data analyses.

## Basic Concepts

Most data traditional data analyses are **univariate** or **bivariate**. A univariate analysis assesses a single variable, and a bivariate analysis compares two variables. For example, ````hist( )```` is a univariate analysis, a ````t.test( )```` is bivariate, and a scatter plot is bivariate.

Such analyses fall short when you want to analyze the relationships among many different variables - i.e., a **multivariate** dataset. In fact, there are a whole host of problems associated with applying multiple bivariate analyses to a multivariate dataset - i.e., just performing a bivariate analysis on every possible pair of combinations. The most famous of these is the [multiple comparisons problem](http://www.biostathandbook.com/multiplecomparisons.html), but there are many other drawbacks to such an approach.

One way to get around this is to try some type of multivariate analysis. Today, we are going to talk about a broad class of multivariate analyses known as ordinations. The driving principle behind these methods is to "*reduce the dimensionality*" of a multivariate dataset. In other words, to take a datset with many variables and summarize their relationships with only a few variables.

## Our first multivariate dataset

Let us load in data from the Paleobiology Database, and convert it into an analyzable format.

#### Step 1:

Open R and load in the following modules of the beta version of the University of Wisconsion's [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R) package using the ````source( )```` function.

````R
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/communityMatrix.R")
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/cullMatrix.R")
````

#### Step 2:

Download a dataset of bivalve (clams) and gastropod (snails) fossils that range from the Cambrian through Pleistocene using the ````downloadPBDB( )```` function. Next use the ````cleanGenus( )```` and ````constrainAges( )```` function to clean up the data. These are simply pre-made functions that automatically clean up data errors, and fossl occurrences that have poor temporal constraint (i.e., are of unceratain age).

````R
# Download data from the Paleobiology Database
# This may take a couple of minutes.
DataPBDB<-downloadPBDB(Taxa=c("Bivalvia","Gastropoda"),StartInterval="Cambrian",StopInterval="Pleistocene")

# Remove occurrences not properly resolved to the genus level.
DataPBDB<-cleanGenus(DataPBDB)

# Download age definitions
# A necessary step for the constrainAges( ) function
Epochs<-downloadTime(Timescale="international epochs")

# Remove poorly constrained fossils
DataPBDB<-constrainAges(DataPBDB,Epochs)
````

#### Step 3:

Let's turn our newly downloaded and cleaned PBDB data into a community matrix. A community matrix is one of the most fundamental data formats in ecology. In such a matrix, the rows represent different samples, the columns represent different taxa, and the cell valuess represent the abundance of the species in that sample.

Here are a few things to remember about community matrices.
1. Samples are sometimes called sites or quadrats, but those are sub-discipline specific terms that should be avoided. Stick with samples because it has a universally applicable.
2. The columns do not have to be species per se. Columns could be other levels of the Linnean Hierarchy (e.g., genera, families) or some other ecological grouping (e.g., different habits, different morphologies).
3. Since there is no such thing as a negative abundance, there should be no negative data in a Community Matrix.
4. Sometimes we may not have abundance data, in which case we can substitute presence-absence data - i.e, is the taxon present or absent in the sample. This is usually represented with a 0 for absent and a 1 for present.

Let's convert our PBDB dataset into a presence-absence dataset using the ````presenceMatrix( )```` function fo the PBDB package. This function requires that you define which column will count as samples. For now, let's use ````"early_interval"```` (i.e., geologic age) as the separator.

````R
# Create a PBDB collections by Taxa matrix
# This may take a couple of minutes
PresencePBDB<-presenceMatrix(DataPBDB,SampleDefinition="collection_no")

# In addition, let us clean up this new matrix and remove depauperate samples and rare taxa.
# We will set it so that a sample needs at least 24 reported taxa for us to consider it reliable,
# and each taxon must occur in at least 5 samples for us to keep it.
PresencePBDB<-cullMatrix(PresencePBDB,minOccurrences=5,minDiversity=24)
````

#### Problem Set I

1) How many genera are in the Miocene,Early Jurasic, Cretaceous, and Pennsylvanian epochs? What code did you use to find out?

2) How many geologic epochs in general are in this dataset? What code did you use to find out?

3) Which epochs contain specimens of the genus *Mytilus*? What code did you find out.

4) Look at the epochs in the [geologic timescale](https://en.wikipedia.org/wiki/Geologic_time_scale#Table_of_geologic_time). Using your answer to question 3, in which epochs can we infer that *Mytilus* was present, even though we have no record of them in the Paleobiology Database? How did you deduce this?

## Basic similarity indices

Many ordination techniques are based (either operationally or theoreticall) on the use of **similarity indices**. Such indices generally range from 0 to 1. In a **similarity index**, zero indicates complete dissimilarity and 1 indicates complete similarity. In a **dissimilarity** or **distance** index, zero indicates complete similarity and 1 indicates complete dissimilarity.

#### Problem Set II

The Jaccard index is the simplest Similarity index. It is the intersection of two samples divided by the union of two samples. In other words, the number of genera shared between two samples, divided by the total number of (unique) genera in both samples. 

1) Using your own custom R code, find the Jaccard similarity of the Pleistocene and Miocene "samples" in your PresencePBDB matrix. It is possible to code this entirely using only functions discussed in the [R Tutorial](https://github.com/aazaff/startLearn.R/blob/master/README.md), but here are some additional functions that *may* be helpful.

````R
# The match function
VectorA<-c("Bob","John","Jane")
VectorB<-c("Frank","Bob","Tim","Susan","John","Jose")
match(VectorA,VectorB)
[1]  2  5 NA

# The unique function
VectorC<-c("Bob","Bob","Tim","Tim","Tim","Susan")
unique(VectorC)
[1] "Bob"   "Tim"   "Susan"
````

2) How can you convert your similarity index into a **distance**?

3) Install and load the ````vegan```` package into R. Read the help file for the ````vegdist```` function - ````?vegdist```` or ````help(vegdist)````. Again, calculate the jaccard distance of the "Miocene" and "Pleistocene" samples of ````PresencePBDB````, but this time use the ````vegdist( )```` function. This should be an identical answer to what you got in question 2.

4) Using the ````vegdist( )```` function. Calculate the Jaccard distances of all the following epochs in ````PresencePBDB```` - the "Pleistocene", "Pliocene", "Miocene", "Oligocene", "Eocene", "Paleocene". What code did you use? Which two epochs are the most dissimilar?

## Polar Ordination

Polar ordination is the simplest form of ordination, and was originally invented here at the University of Wisconsin in the late 50s. In polar ordination you define two "poles" of the gradient - i.e., the two samples that you think are the most dissimilar. You think order the samples into a gradient based on how similar they are to each "pole". 

The definition of the poles can be based on the calculation of a simlarity index (e.g., Jaccard) or could be two samples you hypothesize are at the ends of a gradient. Both approaches are fairly crude, so this method of ordination has largely been abandoned. As far as I know, there are no longer any functions in R for calculating polar ordination.

#### Problem Set III

1) Create a subset of the ````PresencePBDB```` matrix which contains just the following rows - "Pliocene", "Oligocene", "Paleocene", "Early Cretaceous", "Late Jurassic", and "Middle Jurassic". Name this subset ````RandomEpochs````. Show your code.

2) Using ````vegdist( )```` find the dissimilarities of all the epochs in Random Epochs. Show your code.

3) Find the two epochs that are the most dissimilar and make them the poles. Now, using the dissimilarities, order (ordinate) the remaining epochs based on their similarity to the poles. State the order of your inferred gradient.

4) Can you deduce what "variable" is controlling this gradient (e.g., temperature, water depth, geographic distance)? [Hint: Check the [geologic timescale](https://en.wikipedia.org/wiki/Geologic_time_scale#Table_of_geologic_time)]. State your reasoning.

5). There is a relatively high dissimilarity between the Early Cretaceous and Paleocene epochs. Can you hypothesize why this is? Google these epochs if you need to.

## Correspondence Analysis

The next form of ordination is known as corresponence analysis, also known as reciprocal averaging. There are three primary varietys of correspondence analysis: correspondence analysis, detrended correspondence analysis, and canonical (constrained) correspondence analysis. 

Since we already explained the basics of reciprocal averaging in class, I will not go into further detail on the underlying theory behind correspondence analysis. Instead, let us examine the difference between correspondence analysis and detrended correspondence analysis.

#### Step 1

Identify which epochs of ````PresencePBDB```` belong to the Cambrian Period. Make a new copy of ````PresencePBDB```` named ````PostCambrian````, which does not include any Cambrian epochs. 

#### Step 2

Use the following code to perform and plot a basic correspondence analysis on PostCambrian. Note that this requires that the ````vegan```` package be loaded.

````R
# Run a correspondence analysis using the CCA( ) function of vegan
PostCambrianCCA<-cca(PostCambrian)

# Plot the inferred sites 
plot(PostCambrianCCA,display="sites)
````

Your final product should look like this.
