## Diversity Partitioning Across Mass Extinction Boundaries

Today we are going to look at Biodiversity Partitioning across mass extinction boundaries. We'll be using the Alpha, Beta, and Gamma framework that we discussed in [lecture](http://teststrata.geology.wisc.edu/teachPaleobiology/LectureSlides/Ordovician03282016.pdf). You can go back and review those slides if you have forgotten or you can read this [review paper](http://teststrata.geology.wisc.edu/teachPaleobiology/AdditionalReading/AlphaBetaGamma.pdf) in the [Additional Readings](https://github.com/aazaff/teachPaleobiology/blob/master/AdditionalReading/AdditionalReading.md#a-list-of-additional-readings) section. 

Be warned that the review paper discusses both **MULTIPLICATIVE** and **ADDITIVE** diversity partitioning. We are only interested in **ADDITIVE** partitioning today.

## Downloading the Data

#### Step 1:

Open R and load in the following modules of the beta version of the University of Wisconsion's [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R) package using the ````source( )```` function.

````R
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/communityMatrix.R")
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/cullMatrix.R")
````

#### Step 2:

Download a global dataset of animal occurrences from the Late Ordovician (Sandbian-Hirnantian) and Early Silurian (Llandovery-Wenlock) using the ````downloadPBDB( )```` function. We're going to begin by looking at biodiveristy partitioning before and after the end-Ordovician extinction.

````R
# Download data from the Paleobiology Database
# This may take a couple of minutes.
LateOrdovician<-downloadPBDB(Taxa="Animalia",StartInterval="Sandbian",StopInterval="Hirnantian")
EarlySilurian<-downloadPBDB(Taxa="Animalia",StartInterval="Llandovery",StopInterval="Wenlock")

# Clean up bad genus names
LateOrdovician<-cleanRank(LateOrdovician,"genus")
EarlySilurian<-cleanRank(EarlySilurian,"genus")

# Download the epoch level timescale from Macrostrat
Epochs<-downloadTime("international epochs")

# Constrain data to only occurrences limited to a single epoch
LateOrdovician<-constrainAges(LateOrdovician,Epochs)
EarlySilurian<-constrainAges(EarlySilurian,Epochs)
````

#### Step 3:

We're going to match our Paleobiology Database occurrences to stratigraphic units in the [Macrostrat](https://macrostrat.org) database. Macrostrat's coverage is currently limited to only North America, but we (the Macrostrat development team here at UW-Madison) are doing our best to extend coverage to other countries and continents.

````R
# Download stratigraphic unit information from the Macrostrat database and match it to the PBDB data
LateOrdovician<-macrostratMatch(LateOrdovician)
EarlySilurian<-macrostratMatch(EarlySilurian)
````

#### Step 4:

We are going to convert our new data sets into two community matrices using the ````presenceMatrix( )```` functions from Labs 4, 5 and 6, where the stratigraphic units ````unit_name```` are the rows.

````R
# Late Ordovician Stratigraphic units by Late Ordovician genera
OrdovicianMatrix<-presenceMatrix(LateOrdovician,SampleDefinition="unit_name",TaxonRank="genus")

# Stratigraphic units by order
SilurianMatrix<-presenceMatrix(EarlySilurian,SampleDefinition="unit_name",TaxonRank="genus")
````

#### Step 5:

Next we will cull out genera that occur in less than 2 stratigraphic units and stratigraphic units with less than 10 genera using the ````cullMatrix( )```` function.

````R
OrdovicianMatrix<-cullMatrix(OrdovicianMatrix,2,10)
SilurianMatrix<-cullMatrix(SilurianMatrix,2,10)
````

## Problem Set 1

1) What is the total biodiversity (generic richness) of ````OrdovicianMatrix```` and ````SilurianMatrix````? In the alpha, beta, and gamma **ADDITIVE** diveristy partitioning paradigm, does this number represent alpha, beta, or gamma biodiversity? Show your code.

2) What is the average biodiversity of all sample (stratigraphic units) in ````Ordovicianmatrix```` and ````SilurianMatrix````? In the alpha, beta, and gamma **ADDITIVE** diversity partitioning paradigm, does this number represent alpha, beta, or gamma biodiversity? Show your code.

3) What is the difference between the average biodiversity of all samples (stratigraphic units) in ````OrdovicianMatrix```` and the total biodiversity of ````OrdovicianMatrix````. What about for the Silurian? In the alpha, beta, and gamma **ADDITIVE** diveristy partitioning paradigm, does this number represent alpha, beta, or gamma biodiversity? Show your code.

4) Using the same **ADDITIVE** diversity partitioning schema, does alpha diveristy increase between the Ordovician and Silurian? Does beta diversity? Does gamma diversity? By how much?

5) Sampling is different between the Ordovician and Silurian, which makes a direct comparison of the numbers questionable. Sometimes we try to get around this by representing alpha and beta as percentages of gamma.

+ What is the alpha diveristy of ````OrdovicianMatrix```` and ````SilurianMatrix```` as a percentage of their respective gamma diversities?
+ What is the beta diversity of ````OrdovicianMatrix```` and ````SilurianMatrix```` as a percentage of their respective gamma diversities?
+ Does beta increase or decrease across the Ordovician Silurian boundary when measured as a percentage?
+ Conceptually does this mean that Silurian faunas are more cosmopolitan (found in more places around North America) or are less cosmopolitan (found in fewer places around North America) following the Ordovician/Silurian mass extinction. 
+ Does this match what we learned about Silurian cosmopolitanism in class?

6) What is one drawback of using percentages to compare chaging alpha, beta, and gamma biodiversity between two time intervals?

## Problem Set 2

1) Using what we did above as a guide, download comparable datasets for the End-Permian extinction and End-Cretaceous extinction and process them as we did above (Steps 2-5). Show your code.

+ Late Permian (Guadalupian-Lopingian)
+ Early Triassic (Induan-Ladinian)
+ Late Cretaceous (Santonian-Maastrichtian)
+ Early Paleogene (Danian-Lutetian)

2) What are the Alpha, Beta, and Gamma biodiversitites for each downloaded time-interval (not measured as a percentage)? Show your code.

3) What are the Alpha and Beta biodiversities for each downloaded time-interval (when measured as a percentage of gamma)? Show your code.

4) Does Alpha biodiversity increase or decrease after each extinction event (not measured as a percentage)? Show your code.

5) Does Alpha biodiversity increase or decrease after each extinction event (when measured as a percentage of gamma)? Show your code.

## Problem Set 3

It is also possible to measure biodiversity using metrics other than generic richness, such as exponentiated Shannon's Entropy. Let's see what the biodiversity pattern looks like when analyzed in this way.
+ Hint: You may use the ````vegan```` package of previous labs to calcualte Shannon's H

1) Using what we did above as a guide, download comparable datasets for the End-Ordovician, End-Permian, and End-Cretaceous extinctions and process them as we did above (Steps 2-5). **BUT**, this time, use the ````abundanceMatrix( )```` function instead of ````presenceMatrix( )````.

+ Late Ordovician (Sandbian-Hirnantian)
+ Early Silurian (Llandovery-Wenlock)
+ Late Permian (Guadalupian-Lopingian)
+ Early Triassic (Induan-Ladinian)
+ Late Cretaceous (Santonian-Maastrichtian)
+ Early Paleogene (Danian-Lutetian)

2) What are the Alpha, Beta, and Gamma biodiversity for each downloaded time-interval (not measured as a percentage) if biodiversity is measured as the exponentiated Shannon's Entropy? Show your code.

3) What are the Alpha, Beta, and Gamma biodiversity for each downloaded time-interval (when measured as a percentage of gamma) if biodiversity is measured as the exponentiated Shannon's Entropy? Show your code.

4) Does Alpha biodiversity increase or decrease after each extinction event (not measured as a percentage)? Show your code.

5) Does Alpha biodiversity increase or decrease after each extinction event (when measured as a percentage of gamma)? Show your code.

## Problem 4

Based on your results across problem sets 1, 2, and 3, do you believe that Beta diversity tends to increase, decrease, or neither after mass extinction events as a general rule?
