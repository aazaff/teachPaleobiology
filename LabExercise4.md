# Lab Exercise 4

Modelling ecological gradients using multivariate data analyses.

## Basic Concepts

Most data traditional data analyses are **univariate** or **bivariate**. A univariate analysis assesses a single variable, and a bivariate analysis compares two variables. For example, ````hist( )```` is a univariate analysis, a ````t.test( )```` is bivariate, and a scatter plot is bivariate.

Such analyses fall short when you want to analyze the relationships among many different variables - i.e., a **multivariate** dataset. In fact, there are a whole host of problems associated with applying multiple bivariate analyses to a multivariate dataset - i.e., just performing a bivariate analysis on every possible pair of combinations. The most famous of these is the [multiple comparisons problem](http://www.biostathandbook.com/multiplecomparisons.html), but there are many other drawbacks to such an approach.

One way to get around this is to try some type of multivariate analysis. Today, we are going to talk about a broad class of multivariate analyses known as ordinations. The driving principle behind these methods is to "*reduce the dimensionality*" of a multivariate dataset. In other words, to take a datset with many variables and summarize their relationships with only a few variables.

## Our first multivariate dataset

Let us load in data from the Paleobiology Database, and convert it into an analyzable format.

#### Step 1:

Open R and load the `velociraptr` r package.

````R
if (suppressWarnings(require("velociraptr"))==FALSE) {
    install.packages("velociraptr",repos="http://cran.cnr.berkeley.edu/");
    library("velociraptr");
    }
````

#### Step 2:

Download a dataset of bivalve (clams) and gastropod (snails) fossils that range from the Cambrian through Pleistocene using the ````downloadPBDB( )```` function, this function is part of the [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R) package that you loaded in during Step 1. Next use the ````cleanRank( )```` and ````constrainAges( )```` function to clean up the data. These are simply pre-made functions that automatically clean up data errors, and fossil occurrences that have poor temporal constraint (i.e., are of unceratain age).

````R
# Download data from the Paleobiology Database
# This may take a couple of minutes.
DataPBDB<-velociraptr::downloadPBDB(Taxa=c("Bivalvia","Gastropoda"),StartInterval="Cambrian",StopInterval="Pleistocene")

# Remove occurrences not properly resolved to the genus level.
DataPBDB<-velociraptr::cleanTaxonomy(DataPBDB,"genus")

# Download a matrix of geologic epoch definitions and metadata
# A necessary step for the constrainAges( ) function
Epochs<-velociraptr::downloadTime(Timescale="international epochs")

# Remove poorly constrained fossils
DataPBDB<-velociraptr::constrainAges(DataPBDB,Epochs)
````

#### Step 3:

Let's turn our newly downloaded and cleaned PBDB data into a community matrix. A community matrix is one of the most fundamental data formats in ecology. In such a matrix, the rows represent different samples, the columns represent different taxa, and the cell valuess represent the abundance of the species in that sample.

Here are a few things to remember about community matrices.

1. Samples are sometimes called sites or quadrats, but those are sub-discipline specific terms that should be avoided. Stick with samples because it is universally applicable.
2. The columns do not have to be species per se. Columns could be other levels of the Linnean Hierarchy (e.g., genera, families) or some other ecological grouping (e.g., different habits, different morphologies).
3. Since there is no such thing as a negative abundance, there should be no negative data in a Community Matrix.
4. Sometimes we may not have abundance data, in which case we can substitute presence-absence data - i.e, is the taxon present or absent in the sample. This is usually represented with a 0 for absent and a 1 for present.

Let's convert our PBDB dataset into a presence-absence dataset using the ````presenceMatrix( )```` function fo the PBDB package. This function requires that you define which column will count as samples. For now, let's use ````"early_interval"```` (i.e., geologic age) as the separator.

````R
# Create a PBDB occurrences by taxa matrix
# This may take a couple of minutes
PresencePBDB<-velociraptr::presenceMatrix(DataPBDB,Rows="early_interval",Columns="genus")

# In addition, let us clean up this new matrix and remove depauperate samples and rare taxa.
# We will set it so that a sample needs at least 24 reported taxa for us to consider it reliable,
# and each taxon must occur in at least 5 samples for us to keep it. These are common minimums for
# sample sizes in ordination analysis, though I've seen no quantiative proof that this is ideal.
PresencePBDB<-velociraptr::cullMatrix(PresencePBDB,Rarity=5,Richness=24)
````

#### Problem Set I

1) How many unique genera are in the Miocene, Early Jurasic, Late Cretaceous, and Pennsylvanian epochs (not total, each)? What code did you use to find out?

2) How many geologic epochs in general are in this dataset? What code did you use to find out?

3) Which epochs contain specimens of the genus *Mytilus*? What code did you find out.

4) Look at the epochs in the [geologic timescale](https://en.wikipedia.org/wiki/Geologic_time_scale#Table_of_geologic_time). Using your answer to question 3, in which epochs can we infer that *Mytilus* was present, even though we have no record of them in the Paleobiology Database? How did you deduce this?

## Basic similarity indices

Many ordination techniques are based (either operationally or theoretically) on the use of **similarity indices**. Such indices generally range from 0 to 1. In a **similarity index**, zero indicates complete dissimilarity and 1 indicates complete similarity. In a **dissimilarity** or **distance** index, zero indicates complete similarity and 1 indicates complete dissimilarity.

#### Problem Set II

The Jaccard index is the simplest Similarity index. It is the intersection of two samples divided by the union of two samples. In other words, the number of genera shared between two samples, divided by the total number of (unique) genera in both samples. Or put even another way, it is the percentage of genera shared between two samples. 

1) Using your own custom R code, find the Jaccard similarity of the Pleistocene and Miocene "samples" in your PresencePBDB matrix. It is possible to code this entirely using only functions discussed in the [R Tutorial](https://github.com/aazaff/startLearn.R/blob/master/README.md). The key is to use ````apply( )````, ````sum( )````, ````table( )````, and judicious use of matrix subscriptng.

2) How can you convert your similarity index into a **distance**?

3) Install and load the ````vegan```` package into R. Read the help file for the ````vegdist```` function - ````?vegdist```` or ````help(vegdist)````. You must have already loaded the ````vegan```` package in order for it to run.

Again, calculate the jaccard distance of the "Miocene" and "Pleistocene" samples of ````PresencePBDB````, but this time use the ````vegdist( )```` function. This should be an identical answer to what you got in question 2. [Hint: You will have to change **one** of the default settings of the function]

4) Using the ````vegdist( )```` function. Calculate the Jaccard distances of all the following epochs in ````PresencePBDB```` - the "Pleistocene", "Pliocene", "Miocene", "Oligocene", "Eocene", "Paleocene". What code did you use? Which two epochs are the most dissimilar?

## Polar Ordination

Polar ordination is the simplest form of ordination, and was originally invented here at the University of Wisconsin in the late 50s. In polar ordination you define two "poles" of the gradient - i.e., the two samples that you think are the most dissimilar. You then order the samples into a gradient based on how similar they are to each "pole". 

The definition of the poles can be based on the calculation of a simlarity index (e.g., Jaccard) or could be two samples you hypothesize are at the ends of a gradient. Both approaches are fairly crude, so this method of ordination has largely been abandoned. As far as I know, there are no longer any working functions in R for calculating polar ordination.

#### Problem Set III

1) Create a subset of the ````PresencePBDB```` matrix which contains just the following rows - "Pliocene", "Oligocene", "Paleocene", "Early Cretaceous", "Late Jurassic", and "Middle Jurassic". Name this subset ````RandomEpochs````. Show your code.

2) Using ````vegdist( )```` find the dissimilarities of all the epochs in Random Epochs. Show your code.

3) Find the two epochs that are the most dissimilar and make them the poles. Now, using the dissimilarities, order (ordinate) the remaining epochs based on their similarity to the poles. State the order of your inferred gradient.

4) Can you deduce what "variable" is controlling this gradient (e.g., temperature, water depth, geographic distance)? [Hint: Check the [geologic timescale](https://en.wikipedia.org/wiki/Geologic_time_scale#Table_of_geologic_time)]. State your reasoning.

5). There is a relatively high dissimilarity between the Early Cretaceous and Paleocene epochs. Can you hypothesize why this is? Google these epochs if you need to.

## Correspondence Analysis

The next form of ordination is known as corresponence analysis, also known as reciprocal averaging (like we discussed in [lecture](https://github.com/aazaff/teachPaleobiology/blob/master/LectureSlides/CommonDistributions02102016.pdf)). There are three primary varietys of correspondence analysis: correspondence analysis, detrended correspondence analysis, and canonical (constrained) correspondence analysis. 

Since we already explained the basics of reciprocal averaging in class, I will not go into further detail on the underlying theory behind correspondence analysis. Instead, let us examine the difference between correspondence analysis and detrended correspondence analysis.

#### Step 1 (Loading and Cleaning Data)

Rename ````PresencePBDB```` as ````PostCambrian````.

#### Step 2 (Initial Correspondence Analysis)

Use the following code to perform and plot a basic correspondence analysis on PostCambrian. Note that this requires that the ````vegan```` package be loaded.

````R
# Run a correspondence analysis using the decorana( ) function of vegan
# ira = 1 tells it to run a basic correspondence analysis rather than detrended correspondence analysis
PostCambrianCA<-vegan::decorana(PostCambrian,ira=1)

# Plot the inferred samples (sites).
# If you want to see the taxa, use display="species"
plot(PostCambrianCA,display="sites")
````

Your final product should look like this.

<a href="url"><img src="/Lab4Figures/Figure1.png" align="center" height="500" width="500" ></a>

#### Step 3 (Advanced Plotting)

You may also wish to make a more complex/detailed plot. R has a dizzying variety of plotting functions, but today we will only need two of the basic functions.

The first function is ````plot( )````, which you have used earlier in this lab and elsewhere in the course. It is a very versatile and easy to use function because it has many **methods** attached to it. Putting the technical definition of a **method** aside, a method is a set of pre-programmed settings or templates, that will make a different type of plot depending on what kind of data you give the function.

````R
# Use methods plot to see all the different types of methods
# You don't interact with the methods, the basic plot( ) function does it for you.
methods(plot)
````

The **generic** version of plot (i.e, the version of plot that does not use any methods) produces a basic [scatter plot](http://www.statmethods.net/graphs/scatterplot.html) - i.e., points along an x and y axis. The ordination plots we used above are an example of a scatter plot. What if we want more customization than the basic ````plot.decorana```` method/template gives us?

````R
# Use the scores( ) function if you want to see/use the numerical values of the inferred gradient scores
# Note that by scores we mean gradient values - e.g., a temperature of 5 degrees or a depth of 10m
PostCambrianSpecies<-scores(PostCambrianCA,display="species")

# This shows the weighted average of all species abundances along each inferred gradient axis.
# i.e., The weight-average of Amphiscapha is 5.22 along axis 1, and -3.799 along axis 2.
head(PostCambrianSpecies)
                    RA1       RA2       RA3        RA4
Amphiscapha    5.221689 -3.799051 -2.998689 1.27944155
Donaldina      5.460634 -1.936823 -1.439545 0.77634443
Euphemites     5.472197 -2.781106 -2.433943 0.04989632
Glabrocingulum 4.270209 -3.789545 -1.794858 1.37530975
Palaeostylus   5.322415 -3.151507 -2.536464 0.60251234
Meekospira     5.322415 -3.151507 -2.536464 0.60251234

# You can also do this for sample ("sites") scores as well.
PostCambrianSamples<-scores(PostCambrianCA,display="sites")

# Now that we know the [x,y] values of each point, we can plot them.
plot(x=PostCambrianSamples[,"RA1"],y=PostCambrianSamples[,"RA2"])
````

<a href="url"><img src="/Lab4Figures/Figure5.png" align="center" height="500" width="500" ></a>

It certainly works, but is a lot uglier than what the ````plot.decorana```` method came up with. Here are a few things that we can do to improve the plot.

````R
plot(x=PostCambrianSamples[,"RA1"],y=PostCambrianSamples[,"RA2"],pch=16,las=1,xlab="Gradient Axis 1",ylab="Gradient Axis 2",cex=2)
````

Plotting Arguments | Description
----- | -----
````pch=```` | Dictates the symbol used for the points - e.g., ````pch = 16```` gives a solid circle, ````pch = 15```` gives a solid square. Try out different numbers.
````cex=```` | Dictates the size of the points, the larger cex value the larger the points. Try out different values.
````xlab=```` | Dictates the x-axis label, takes a **character** string.
````ylab=```` | Dictates the y-axis label, takes a **character** string.
````las=```` | Rotates the y-axis or x-axis tick marks. Play around with it.
````col=```` | The col function sets the color of the points. This will take either a [hexcode](http://www.color-hex.com/) as a character string, ````col="#010101"```` or a [named color](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf) in R, ````col="red"````

There are a great many other arguments that can be given to the ````plot( )```` function, but we will discuss those as we need them.

Although this plot is prettier than what we had before, it would probably be better to have text names for the points, stating which point is which epoch (i.e., like in the ````plot.decorana```` method). To do this we can use the ````text( )```` function. Importantly, you cannot use ````text( )```` without making a ````plot( )```` first.

````R
# Create plot empty of points (but scaled to the data) by adding the type="n" argument.
plot(x=PostCambrianSamples[,"RA1"],y=PostCambrianSamples[,"RA2"],pch=16,las=1,xlab="Gradient Axis 1",ylab="Gradient Axis 2",type="n")

# The text( ) function takes [x,y] coordinates just like plot
# You also give it a labels= defintion, which states what text you want shown at those coordinates
# In this case, the rownames of the PostCambrianSamples matrix - i.e., the epoch names
text(x=PostCambrianSamples[,"RA1"],y=PostCambrianSamples[,"RA2"],labels=dimnames(PostCambrianSamples)[[1]])

# You can also give the text function many of the arguments that you give to plot( )
# Like cex= to increase the size or col= to change the color
text(x=PostCambrianSamples[,"RA1"],y=PostCambrianSamples[,"RA2"],labels=dimnames(PostCambrianSamples)[[1]],cex=1.5,col="dodgerblue3")
````

Coloring is a very powerful visual aid. We might want to subset the data into different groupings, and color those grouping differently to look for clusters in the ordination space. Let's try splitting the dataset into three parts: Cenozoic Epochs (1-66 mys ago), Mesozoic Epochs (66-252 mys), and the Paleozoic (252-541 mys), and plot each with a different color.

````R
# Create plot empty of points (but scaled to the data) by adding the type="n" argument.
plot(x=PostCambrianSamples[,"RA1"],y=PostCambrianSamples[,"RA2"],pch=16,las=1,xlab="Gradient Axis 1",ylab="Gradient Axis 2",type="n")

# Separate out the epochs
Cenozoic<-PostCambrianSamples[c("Pleistocene","Pliocene","Miocene","Oligocene","Eocene","Paleocene"),]
Mesozoic<-PostCambrianSamples[c("Late Cretaceous","Early Cretaceous","Late Jurassic","Early Jurassic","Late Triassic","Middle Triassic","Early Triassic"),]
Paleozoic<-PostCambrianSamples[c("Lopingian","Guadalupian","Cisuralian","Pennsylvanian","Mississippian","Late Devonian","Middle Devonian","Early Devonian","Pridoli","Ludlow","Wenlock","Llandovery","Late Ordovician","Middle Ordovician","Early Ordovician"),]

# Plot Cenozoic in gold
text(x=Cenozoic[,"RA1"],y=Cenozoic[,"RA2"],labels=dimnames(Cenozoic)[[1]],col="gold")
# Plot Mesozoic in blue
text(x=Mesozoic[,"RA1"],y=Mesozoic[,"RA2"],labels=dimnames(Mesozoic)[[1]],col="blue")
# Plot Paleozoic in dark green
text(x=Paleozoic[,"RA1"],y=Paleozoic[,"RA2"],labels=dimnames(Paleozoic)[[1]],col="darkgreen")
````

Your final output should look like this.

<a href="url"><img src="/Lab4Figures/Figure7.png" align="center" height="500" width="500" ></a>

#### Step 4 (Analysis)

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
PostCambrianDCA<-vegan::decorana(PostCambrian,ira=0)

# Plot the DCA
plot(PostCambrianDCA,display="sites")
````

Your final product should look like this.

<a href="url"><img src="/Lab4Figures/Figure2.png" align="center" height="500" width="500" ></a>

You will notice that the arch effect is gone! This is good, but the DCA is suffering from a new problem known as the **Wedge** effect. You can envision the wedge effect by taking a piece of paper and twisting it, such that axis 1 is preserved reasonably undistorted, but the second axis of variation is expressed on DCA axis 2 on one end and on DCA axis 3 at the opposite end. This produces a pattern consisting of a tapering of sample points in axis 1-2 space and an opposing wedge in axis 1-3 space.

Here, let's contrast our above DCA plot by plotting DCA Axis 1 and DCA Axis 3. Do you see another wedge running in the opposite direction?

````R
# Use the choices= argument to pick which ordination axes you want plotted.
plot(PostCambrianDCA,display="sites",choices=c(1,3))
````
<a href="url"><img src="/Lab4Figures/Figure3.png" align="center" height="500" width="500" ></a>

## Multi-dimensional Scaling

Because correspondence analysis suffers from the arch and detrended correspondence analysis can suffer from the wedge, many ecologists favour a completely different technique known as non-metric multi-dimensional scaling (NMDS). The underlying theory behind NMDS is quite different from correspondence analysis. If you want to learn more there is a good introduction by [Steven M. Holland](http://strata.uga.edu/software/pdf/mdsTutorial.pdf).

However, if you just want the highlights, here is what you need to know.

+ Most ordination methods result in a single unique solution. In contrast, NMDS is a brute force technique that iteratively seeks a solution via repeated trial and error, which means running the NMDS again will likely result in a somewhat different ordination.
+ NMDS, unlike correspondence analysis, is not based on weighted-averaging, but on the ecological distances (e.g., jaccard) of samples, similar to polar ordination.
+ The species scores presented by NMDS are just the weighted-average of the final NMDS sample scores.

Here is how you run an NMDS in R using the ````vegan```` package.

````R
PostCambrianNMDS<-metaMDS(PostCambrian)

# The plotting defaults for metaMDS output is not as good as for decorana( )
# We have to do some graphical fiddling.

# Create a blank plot by setting type= to "n" (for nothing)
plot(PostCambrianNMDS,display="sites",type="n")

# Use the text( ) function, to fill in our blank plot with the names of the samples
# Importantly, text( ) will not work if there is not already an open plot,
# hence why we needed to make the blank plot first. Notice that we did not define the coordinates for
# text( ). This is because by giving the text( ) function an NMDS output, 
# it knows to use the text.metaMDS method/template.
text(PostCambrianNMDS,display="sites")
````

Your final product should look like this.

<a href="url"><img src="/Lab4Figures/Figure4.png" align="center" height="500" width="500" ></a>

It's the Arch Effect again, just like in correspondence analysis!!! Despite the fact that many ecologists like to praise NMDS over CA and DCA, the differences between them are exaggerated. The reason for this is that all three are unreliable when there isn't a strong gradient to pick up in the first place.

In these data, there is a very strong "time" gradient that is picked up in the first axis of all four ordination (polar, corresondence, detrended, and multidimensional) techniques that we've used so far. However, there is no secondary gradient (or tertiary etc.) that is obvious in these data, hence why all of the methods make up these (ecologically) meaningless wedges and arches along the second, third, and so on axes.

Of the ordination methods covered here, I recommend sticking with DCA. It is fairly robust and easy to interpret, though *watch out for those wedges*!

#### Problem Set IV

1) Download a dataset from the paleobioogy database of all Ordovician aged animals (i.e., animalia) into R, and name the object ````Ordovician````. This may take a few minutes.  What R code did you use?

2) Clean up the poorly resolved genus names. What function/code did you use?

3) Turn your object ````Ordovician```` into a community matrix of samples by genera, where the samples are different ````geoplate```` codes. Geoplate codes denote different ancient paleocontinents - i.e., your community matrix will list which genera were present in which ancient paleocontinent. Cull this matrix so that each sample has a minimum of 25 taxa and each taxon occurs in at least two samples. Show your code.

4) Perform a DCA on your new community matrix. Analyze your new DCA with a plot. Do you think that the orientation of samples along either axis 1 or axis 2 is related to the average latitude or longitude of each plate in question? Explain how you figured this out. Show your code. [Hint: Information about the paleolatitude and paleolongitude of different geoplates is included in your originally downloaded data - i.e., the object ````Ordovician````.]

> I removed the former Question 5, you no longer need to do it.
