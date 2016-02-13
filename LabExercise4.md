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
# Run a correspondence analysis using the decorana( ) function of vegan
# ira = 1 tells it to run a basic correspondence analysis rather than detrended correspondence analysis
PostCambrianCA<-decorana(PostCambrian,ira=1)

# Plot the inferred samples (sites).
# If you want to see the taxa, use display="species"
plot(PostCambrianCA,display="sites")
````

Your final product should look like this.

<a href="url"><img src="/Lab4Figures/Figure1.png" align="center" height="450" width="500" ></a>

#### Step 3

There are a few things you should notice about the above graph. First, the first axis (i.e, the horizontal axis, the x-axis) of the ordination has ordered the samples in terms of their age. On the far right of the x-axis is the Ordovician (the oldest epoch) and on the far left is the Pleistocene (the youngest epoch). Therefore, we can infer that *time* is the primary gradient.

However, you may have also noticed two other patterns in the data. 

First, when the second axis (i.e., the vertical axis, the y-axis) is taken into account, an interesting **Arch** shape is apparent. This arch does not represent a true ecological phenomenon, per se, but is actually a mathematical artefact of the correspondence analysis method. Brocard et al. (2013) describe the formation of the arch thusly,

> Long environmental gradients often support a succession of species. [Since species tend to have unimodal distributions along gradients], a long gradient may encompass sites that, at both ends of the gradient, have no species in common; thus, their distance reaches a maximum value (or their simi-larity is 0). But if one looks at either side of the succession, contiguous sites continue to grow more different from each other. Therefore, instead of a linear trend, the gradient is represented on a pair of CA axes as an arch.

In other words, the Pleistocene and Early Ordovician have no species in common, thus they are on opposite ends of the first axis. However, they do share something in common, which is that they become progressively dissimilar from epochs further away from them. For this reason, the correspondence analysis plots them on the same end of the second axis, and the epochs that are at the midpoint between them (i.e., the Permo-Trissic boundary) on the other end of the second axis. This is not helpful information (in fact, it is just a geometrically warped restatement of the information conveyed in the first axis) and we want to eliminate it for something more useful.

The other thing you may have noticed is **compression** towards the ends of the gradient. Meaning that most of the Cenozoic epochs (i.e., Pleistocene, Pliocene, Miocene, Oligocene, and Eocene) are overlain closely on top of each other. So much so that you probably have a hard time reading their text. This is also an artefact of correspondence analysis, and not necessarily an indication that those epochs are more similar to each other, than say the (more legible) Early and Late Cretaceous epochs.

For these reasons, it is rare for people to still use correspondence analysis (reciprocal averaging). Though some scientists argue you should at least try correspondence analysis before turning to another technique (I am not one of them).

## Detrended Correspondence Analysis

The Arch effect and compression are both ameliorated by detrended correspondence analysis (DCA). DCA divides the first axis into a number of smaller segments. Within each segment it recalculates the second axis scores such that they have an average of zero.

You can perform a DCA in R using the ````decorana( )```` function of the ````vegan```` package.

````R
# Peform a DCA on the Post Cambrian Dataset
# ira = 0 is the default, so you do not need to put that part in.
PostCambrianDCA<-decorana(PostCambrian,ira=0)

# Plot the DCA
plot(PostCambrianDCA,display="sites")
````

Your final product should look like this.

<a href="url"><img src="/Lab4Figures/Figure2.png" align="center" height="450" width="500" ></a>

You will notice that the arch effect is gone! This is good, but the DCA is suffering from a new problem known as the **Wedge** effect. You can envision the wedge effect by taking a piece of paper and twisting it, such that axis 1 is preserved reasonably undistorted, but the second axis of variation is expressed on DCA axis 2 on one end and on DCA axis 3 at the opposite end. This produces a pattern consisting of a tapering of sample points in axis 1-2 space and an opposing wedge in axis 1-3 space.

Here, let's contrast our above DCA plot by plotting DCA Axis 1 and DCA Axis 3. Do you see another wedge running in the opposite direction?

````R
# Use the choices= argument to pick which ordination axes you want plotted.
plot(PostCambrianDCA,display="sites",choices=c(1,3))
````
<a href="url"><img src="/Lab4Figures/Figure3.png" align="center" height="450" width="500" ></a>

## Multi-dimensional Scaling

Because of correspondence analysis suffers from the arch and detrended correspondence analysis can suffer from the wedge, many ecologists favour a completely different technique known as multi-dimensional scaling.

