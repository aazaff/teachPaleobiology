# Lab Exercise 6

Identifying and mapping out Lagerstätte in the [Paleobiology Database](https://paleobiodb.org/#/).

## Basic Concepts

Remember that we define a Lagerstätte based on several different criteria.

+ An atypically high quality of preservation
+ An atypically large quantity of fossil material
+ An atypically large number of rare or unique organisms

Today, we will see if, working backwards from the last of these three criteria, we can infer the geographic distribution of Cambrian aged (541-485 mys ago) lagerstätten.

#### Step 1:

Open R and load in the following modules of the beta version of the University of Wisconsion's [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R) package using the ````source( )```` function.

````R
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/communityMatrix.R")
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/cullMatrix.R")
````

#### Step 2:

Download a global dataset of platn and animal occurrences from the Cambrian Period using the ````downloadPBDB( )```` function

````R
# Download data from the Paleobiology Database
# This may take a couple of minutes.
DataPBDB<-downloadPBDB(Taxa=c("Plantae","Animalia"),StartInterval="Cambrian",StopInterval="Cambrian")

# Clean up bad genus names
DataPBDB<-cleanRank(DataPBDB)
````

#### Step 3:

We're going to match our Paleobiology Database occurrences to stratigraphic units in the [Macrostrat](https://macrostrat.org) database. Macrostrat's coverage is currently limited to only North America, but we (the Macrostrat development team here at UW-Madison) are doing our best to extend coverage to other countries and continents.

````R
# Download stratigraphic unit information from the Macrostrat database and match it to the PBDB data
MacroPBDB<-macrostratMatch(DataPBDB)
````

#### Problem Set 1

1) As part of our matching procedure between the Macrostrat database and the Paleobiology database, we lost some data - i.e., there was some Paleobiology Database occurrences that could not be matched to the Macrostrat database. How many occurrences were lost? Show your code.

2) Using what you know about the Macrostrat database can you speculate as to why so much data was lost?

#### Step 4:

We are going to convert our new database into several community matrices using the ````presenceMatrix( )```` function from Lab 4 and Lab 5, where the stratigraphic units ````unit_name```` are the rows. In one version, ````GenusMatrix````, the genera will be the columns. In the second version, ````OrderMatrix````, the orders will be the columns.

````R
# Stratigraphic units by genera
GenusMatrix<-presenceMatrix(MacroPBDB,SampleDefinition="unit_name",TaxonRank="genus")

# Stratigraphic units by order
OrderMatrix<-presenceMatrix(MacroPBDB,SampleDefinition="unit_name",TaxonRank="order")
````

#### Problem Set 2

1) A good candidate for classification as a lagerstätten should have high diversity of different taxnomic orders. Calculate the order-level richness of each stratigraphic formation. Find the top 10 candidate units by this criteria. State them and give the code you used. Also, create a **character** ````vector( )```` listing the names of these stratigraphic units. Name this vector ````CandidateUnits````.

##### Hints
1. Remember how to calculate the richness of a sample, and *apply* this to each sample of the ````OrderMatrix````.
2. If you do not remember how to calculate richness, consult the [previous lab](https://github.com/aazaff/teachPaleobiology/blob/master/LabExercise5.md#problem-set-2).
3. Use the ````sort( )```` function to put your richnesses in order.

2) A good candidate for classification as a lagerstätten should have a large number of genera that are relatively rare. Using the ````GenusMatrix```` column to find out how many samples each genus occurs in. Show the code you used. Name your output ````GenusFrequencies````.

3) What is the necessary code to make a [frequency barplot](https://github.com/aazaff/startLearn.R/blob/master/expertConcepts.md#describing-distributions-with-statistics) of the ````GenusFrequencies````?

4) After looking at this barplot, you should see a familiar paleobiological pattern. What do we call this type of curved distribution in paleobiology and ecology. [Hint: Think back to the lectures]

5) Subset your new vector ````GenusFrequences```` so that only those genera from the lower 50% of the distribution are present. In other words genera with occurrences <= to the ````median( )````. Show your code. Name this new subset vector as ````RareGenera````.

#### Problem Set 3

We will now take the list of rare genera you just made, ````RareGenera```` and see ***what percentage of genera in our top 10 candidate stratigraphic units ````CandiateUnits```` come from this list***. We will then decide which of our 10 candidate units is the most likely to be a Lagerstätte.

1) Subset ````GenusMatrix```` so that it only shows the 10 stratigraphic units we determined were potential candidates. Show your code and name your new matrix, ````CandidateMatrix````.

Load in the following code that I wrote for you. It will find the percentage of genera in each sample (stratigraphic unit) that occur in our vector of ````RareGenera````.

````R
# A function that I wrote just for you, don't you feel special?
percentRare<-function(CandidateUnit,RareGenera) {
    CandidateUnit<-CandidateUnit[CandidateUnit>0] # Limit the data only to taxa prensent (non-zero) in the unit
    PercentIn<-length(which(names(CandidateUnit) %in% names(RareGenera))) # Find the number of genera in the CandidateUnit that are in RareGenera
    TotalGenera<-length(CandidateUnit) # Find the total number of genera in the unit
    PercentShared<-PercentIn/TotalGenera
    return(PercentShared)
    }
    
# Apply the percentRare( ) function to each row of CandidateMatrix
PercentShared<-apply(CandidateMatrix,1,percentRare,RareGenera)
````

2) Based on the output of ````PercentShared```` and your answer to [Problem Set 2 - Question 1](#problem-set-2) - i.e., the ranking of candidate units based on the number of orders represented, which four units do you think are most likely to qualify as Lagerstätten? Explain your reasoning. 

3) Look closer into the into the four units you chose - using Google and information in the Paleobiology Database. One of these should be a very famous Lagerstätten. Which one? What is famous about it? What is its significance to Paleobiology?
