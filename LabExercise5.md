# Lab Exercise 5

Measuring biodiversity, evenness, extinction, and origination rates.

## Calculating basic ecoinformatics

#### Step 1

Open R and load in the following modules of the beta version of the University of Wisconsion's [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R) package using the ````source( )```` function.

````R
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/communityMatrix.R")
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/cullMatrix.R")
````

#### Step 2

Download a dataset of bivalve (clams) and brachiopod fossils that range from the Ordovician through Pleistocene using the ````downloadPBDB( )```` function, this function is part of the [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R) package that you loaded in during Step 1. Next use the ````cleanGenus( )```` and ````constrainAges( )```` function to clean up the data. These are simply pre-made functions that automatically clean up data errors, and fossil occurrences that have poor temporal constraint (i.e., are of unceratain age).

````R
# Download data from the Paleobiology Database
# This may take a couple of minutes.
DataPBDB<-downloadPBDB(Taxa=c("Bivalvia","Brachiopoda"),StartInterval="Ordovician",StopInterval="Pleistocene")

# Remove occurrences not properly resolved to the genus level.
DataPBDB<-cleanGenus(DataPBDB)

# Download age definitions
# A necessary step for the constrainAges( ) function
Epochs<-downloadTime(Timescale="international epochs")

# Remove poorly constrained fossils
DataPBDB<-constrainAges(DataPBDB,Epochs)
````

#### Step 3

Let's subset ````DataPBDB```` into a ````Brachiopod```` dataset and a ````Bivalve```` dataset.

````R
# Create a Brachiopod matrix using the which function
Brachiopods<-DataPBDB[which(DataPBDB[,"phylum"]=="Brachiopoda"),]
# Create a Bivalve matrix using the which function
Bivalves<-DataPBDB[which(DataPBDB[,"class"]=="Bivalvia"),]
````

If you are a bit tired of using ````which( )````, you could alternatively use the ````subset( )```` function, which is just a *slighty* more convenient version of the which syntax above.

````R
# Create a Brachiopod matrix using the which function
Brachiopods<-subset(DataPBDB,DataPBDB[,"phylum"]=="Brachiopoda")
# Create a Bivalve matrix using the which function
Bivalves<-subset(DataPBDB,DataPBDB[,"class"]=="Bivalvia")
````

#### Step 4

Let's convert our two new datasets, ````Brachiopods```` and ````Bivalvia````, into two community matrices using the ````abundanceMatrix( )```` function of the PBDB package. This function requires that you define which column will count as samples. For now, let's use ````"early_interval"```` (i.e., geologic age) as the separator. 

````R
# Create an abundance community matrix
# This may take a couple of minutes
BrachiopodAbundance<-abundanceMatrix(Brachiopods,SampleDefinition="early_interval")
BivalveAbundance<-abundanceMatrix(Bivalves,SampleDefinition="early_interval")
````

#### Problem Set 1

You may not use ````vegan( )```` for this subsection.

1) What is Bivalve generic richness in the Miocene? What code did you use to find out?

2) What is the Berger-Parker Index of Brachiopods genera in the Pliocene? What code did you use to find out? [Hint: the function ````max( )```` may help you).

3) What is the Gini-Simpson Index of Brachiopods during the Late Ordovician? What code did you use to find out?

4) What is the Shannon's Entropy of Bivalves during the Late Cretaceous? What code did you use to find out?

5) What is the Shannon's Entropy of Bivalves during the Paleocene? What code did you use to find out?

6) What is the percent change in Shannon's Entropy between the Late Cretaceous and the Paleocene? Can you think of any major events that happened between the Late Cretaceous and Paleocene that might be relevant to biodiversity? [Hint: Use google if you don't know.] Is this reflected in this index?

7) What if you use the ````exp( )```` function to exponentiate the Shannon's Entropies you calculated in questions 4,5, and 6 (i.e., *e*^Shannon's Entropy)? What percent of diversity is gained/lost? Does this better reflect the change between the Late Cretaceous and Paleocene? Why or why not? 

#### Problem Set 2

Install (if you have not already) and load the vegan package into R. Read the help file for the ````diversity( )```` function - ````?diversity```` or ````help(diversity)````. You must have already loaded the vegan package in order for it to run.

1) Use the ````specnumber( )```` function (also from the ````vegan```` package) to find Bivalve richness in the Miocene. What code did you use to find out?

2) Use the ````diversity( )```` function to find the Gini-Simpson Index of Brachiopods during the Late Ordovician? What code did you use to find out?

3) Use the ````diversity( )```` function to find the Shannon's Entropy of Bivalves during the Late Cretaceous? What code did you use to find out?

4) Use the ````diversity( )```` function to find the Shannon's Entropy of Bivalves during the Paleocene? What code did you use to find out?

## Comparing Bivalves and Brachiopods

#### Step 1

Calculate the richness (however you choose) of bivalves in each epoch. Calculate the richness (however you choose) of brachiopods in each epoch. Ideally, these richness values should be expressed as **vectors** or as **1-dimensional arrays**.

#### Step 2

Put these richness values in temporal order. There are many ways to do this. Here is one way to reorder numbers.

````R
# A hypothetic example
OutOrder<-array(c(5,6,7,8,9,3,10),dimnames=list(c("First","Third","Fourth","Second","Seventh","Sixth","Fifth")))
OutOrder
  First   Third   Fourth  Second Seventh   Sixth   Fifth 
      5       6       7       8       9       3      10 

InOrder<-OutOrder[c("First","Second","Third","Fourth","Fifth","Sixth","Seventh")]
InOrder
  First  Second   Third   Fourth   Fifth   Sixth Seventh 
      5       8       6       7      10       3       9 
````

#### Step 3

This next step will use a **correlation coefficient** to determine whether changes in bivalve biodiversity are related to changes in brachiopod biodiversity. 

At its heart, correlation asks whether two sets of **continuous data** co-vary. Co-variance means that when values fluctuate in one dataset they also fluctuate in the other data set.  Correlation is a measurement of how strong covariance is. Most correlation metrics (all of the ones we will use today) range from -1 to 1. A value of -1 means that data is **negatively** correlated, such that when values go *up* in the first dataset, they go *down* in the second dataset. In other words, the two datasets show the opposite behavior. A correlation value of 1 indicates that the data is **positively correlated**, meaning both datasets show the same behavior. A correlation value of 0 means that they show no relationship. 

You can use the ````cor(x, y)``` function to find the correlation coefficient. Importantly, every data point in your first dataset (x) must be matched with a point in the second dataset (y). If the x coordinates and y coordinates are of unequal length, then you cannot perform a correlation.

````R
# Correlation example for two vectors that are positive correlated
# Both vectors go up by 1 in each step
Vector1<-c(1,2,3,4,5,6,7,8,9,10)
Vector2<-c(11,12,13,14,15,16,17,18,19,20)
cor(Vector1,Vector2)
[1] 1

# Correlation example for two vectors that are negatively correlated
Vector1<-c(1,2,3,4,5,6,7,8,9,10)
Vector2<-c(20,19,18,17,16,15,14,13,12,11)
cor(Vector1,Vector2)
[1] -1

# Correlation example for two vectors that are weakly correlated
Vector1<-c(1,2,3,4,5,6,7,8,9,10)
Vector2<-c(20,5,18,4,16,6,14,8,20,10)
cor(Vector1,Vector2)
[1] -0.04395502
````

For a more fundamental breakdown of the math behind correlation, you can consult this tutorial by [Steven M. Holland](http://strata.uga.edu/6370/lecturenotes/correlation.html). I recommend this if you find my explanation of correlation too confusing. 

#### Problem Set 3

1) Is brachiopod richness **positively**, **negatively**, or un-correlated with bivalve richness? Show your code?

2) Is brachiopod biodiversity **positively**, **negatively**, or un-correlated with bivalve biodiversity when using the Gini-Simpson index? Show your code?

3) Looking just at changes in brachiopod richness through time, when did the greatest drop in brachiopod richness occur (i.e., between what two consecutive epochs)? 

## Sampling standardization

Remember that richness can be an innaccurate measure of biodiversity because of the species-area effect (i.e., variable sampling intensity). We can correct for this by standardizing richness.

#### Step 1

Open R and load int the following function.

````R
# A function for resampling by a fixed number of individuals
subsampleIndividuals<-function(Abundance,Quota,Trials=100) {
	  Richness<-vector("numeric",length=Trials)
	  Abundance<-Abundance[Abundance>0]
	  Pool<-rep(1:length(Abundance),times=Abundance)
	  if (sum(Abundance) < Quota) {
		    print("Fewer Individuals than Quota")
		    return(length(unique(Pool)))
		    }
	  for (i in 1:Trials) {
		    Subsample<-sample(Pool,Quota,replace=FALSE)
		    Richness[i]<-length(unique(Subsample))
		    }
	  return(mean(Richness))
	  }
````

#### Step 2

Use the ````subsampleIndividuals( )```` function included in this module to find the subsampled diversity of each epoch. Standardizing your data to a set sample size (logically) requires you to pick a fixed sample size to standardize to. This number is usually the size of your smallest sample. Therefore we must find (1) find the samples with the smallest abundance and (2) use the ````subsampleIndividuals( )```` function.

````R
# Find the sample of the BivalveAbundance community matrix with the least total abundance
SampleAbundances<-apply(BivalveAbundance,1,sum)
SampleAbundances[which(SampleAbundances==min(SampleAbundances))]
Early Ordovician 
             124

# Subsample each interval down to 124 observed individuals to find the standardized richness
StandardizedRichness<-apply(BivalveAbundance,1,subsampleIndividuals,Quota=124)

# View the first 6 results
# Note, your numbers will be slightly different since subsampling is random.
StandardizedRichness[1:6]
Pennsylvanian Middle Ordovician   Late Ordovician        Llandovery           Wenlock            Ludlow 
        44.09             37.33             41.90             37.50             45.86             43.03 
````

#### Problem Set 4

1) Repeat the above steps, but for the ````BrachiopodAbundance```` community matrix. What is the standardized richness you got for brachiopods. Show your code.

2) How does the standardized brachiopod richness (previous question) compare to the unstandardized brachiopod richness from Problem Set 3? Show your code. Explain your reasoning. [Hint: Don't forget to put your biodiversities in temporal order]

3) Make a scatter plot of **standardized brachiopod richness** versus **standardized bivalve richness**. Make a second scatter plot of **unstandardized brachiopod richness** versus **unstandardized bivalve richness**. Compare and contrast the two plots. What are the differences or similarities? Does standardizing or not standardizing matter? Show your code and explain your reasoning in detail. [Hint: If you forgot how to plot, revist the [previous lab](https://github.com/aazaff/teachPaleobiology/blob/master/LabExercise4.md#step-3-advanced-plotting)]

4) Do you believe that there is any evidence in these analyses to support the idea that bivalves outcompeted brachiopods over time? Explain your reasoning.
