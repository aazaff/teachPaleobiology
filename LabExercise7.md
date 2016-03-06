## Introduction

Calculating stratigraphic ranges

## Basic Concepts

The easiest way to calculate the stratigraphic range of a fossil is to find the age of its oldest occurrence (sometimes called *First Occurrence*, **FO**) and its youngest occurrence (sometimes called *Last Occurrence*, **LO**).

#### Step 1

Open R and load in the following modules of the beta version of the University of Wisconsion's [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R) package using the ````source( )```` function.

````R
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/communityMatrix.R")
````

#### Step 2:

Download a global dataset of bivalve occurrences from the Cenozoic Eara using the ````downloadPBDB( )```` function

````R
# Download data from the Paleobiology Database
# This may take a couple of minutes.
DataPBDB<-downloadPBDB(Taxa=c("Bivalvia"),StartInterval="Cenozoic",StopInterval="Cenozoic")

# Clean up bad genus names
DataPBDB<-cleanGenus(DataPBDB)
````

#### Problem Set 1

There are four columns in ````DataPBDB```` relevant to the age of an organism: ````early_interval, late_interval, max_ma, and min_ma````. Because we rarely have a precise date, we generally give the age of an occurrence as a range. This range can be expressed by interval names or by numbers.

1) What do the max_ma and min_ma columns of ````DataPBDB```` represent? If you do not intuitively know, you can always check the [Paleobiology Database API documentation](https://paleobiodb.org/data1.2/occs/list_doc.html).

2) What is oldest age of each genus? [[Hint](https://github.com/aazaff/startLearn.R/blob/master/intermediateConcepts.md#direct-subsetting-with-functionals): Use the ````tapply(  )```` and ````max(  )```` functions we've used in previous labs]. Show the code you would use to find out.

3) What is the youngest age of each genus? [[Hint](https://github.com/aazaff/startLearn.R/blob/master/intermediateConcepts.md#direct-subsetting-with-functionals): Use the ````tapply(  )```` and ````max(  )```` functions we've used in previous labs]. Show the code you would use to find out.

4) Find which genus has the most occurrences in the dataset [Hint: Use the ````table( )```` function!]. What code did you use?

5) What is the stratigraphic range of this taxon (i.e., your answer to question 4). Show your code.

## Confidence intervals

In statistics we like to measure uncertainty. We often do this with something called a confidence interval. Google defines a confidence interval as, "a range of values so defined that there is a specified probability that the value of a parameter lies within it." In other words, a 95% confidence interval ranging from 0-10, means that there is a 95% probability that the true value of the parameter we are measuring lies somewhere between 0 and 10.

This definition and interpretation of confidence intervals has received extensive criticism in recent years. The criticism stems, partly, from a broader debate between two different statistical philosophies. Quite frankly, this debate has as much to do with semantics and polemics as it does with underlying mathematics. Because this is not a proper statistics course we will not dive into this debate, but I want to you to be aware that if you continue on as a statistician, you will likely encounter many statisticians with a deep disapproval of the definition given above. Nevertheless, it is the one we will use moving forward for this lab exercise.

##### Step 1

Let's find the average paleolatitude of the genus *Lucina*.

````R
# Subset the data so that we get the genus *Lucina*
Lucina<-subset(DataPBDB,DataPBDB[,"genus"]=="Lucina")

# Find the mean paleolat of all Lucina occurrences.
OriginalMean<-mean(Lucina[,"paleolat"])
OriginalMean
[1] 24.1997
````

##### Step 2

Let's put a 95% confidence interval around this value. We want to see if we randomly resampled from this underlying distribution, what the distribution of potential means would be.

````R
# Set a seed so that we get the same result
set.seed(100)

# A randomly resample the occurrences of Lucina, and find the mean latitude of our random resample
NewMean<-mean(sample(Lucina[,"paleolat"],length(Lucina[,"paleolat"]),replace=TRUE))
NewMean
[1] 22.84237
````

Notice that we got a lower mean, 22.84237, this time compared to our original mean, 24.1997.

##### Step 3

Now, remember the [Law of Large Numbers](https://github.com/aazaff/startLearn.R/blob/master/expertConcepts.md#the-law-of-large-numbers)? We need to repeat this process many times to converge on a long term solution. For that we'll need to use a ````for(  )```` loop.

````R
# Create a vector from 1 to 1,000, this is how many times we will repeat the resampling procedure
Repeat<-1:1000

# Create a blank array to store our answers in.
ResampledMeans<-array(NA,dim=length(Repeat))

# Use a for( ) loop to repeat the procedure
for (counter in Repeat) {
  ResampledMeans[counter]<-mean(sample(Lucina[,"paleolat"],length(Lucina[,"paleolat"]),replace=TRUE))
  }
  
# Take a peak at what Resampled Means looks like, the numbers should be the same. If not, go back and re-set your
# seed, and try again from that step onwards.
head(ResampledMeans)
[1] 24.46657 23.55738 26.87615 23.41481 26.23879 21.94562
````

#### Problem Set 2

1) Qualitatively describe what is happening in the following line of code. A good answer should identify what the different arguments are for each function, and what they are used for.

````R
mean(sample(Lucina[,"paleolng"],length(Lucina[,"paleolng"]),replace=TRUE))
````

2) Plot a [kernel density](https://github.com/aazaff/startLearn.R/blob/master/expertConcepts.md#describing-distributions-with-statistics) graph of ````ResampledMeans````. Show your code. Does the distribution look approximately Gaussian? Explain why you think it does or does not.

3) Find the mean of ````ResampledMeans````, is it similar to the mean of the original data?

4) Sort ````ResampledMeans```` from lowest to highest. [Hint: We learned how to sort a vector in [Lab 6](https://github.com/aazaff/teachPaleobiology/blob/master/LabExercise6.md#problem-set-2)].

5) Now that you have sorted ````ResampledMeans````, what is the 2.5th percentile of ResampledMeans and what is the 97.5th percentile of Resampled means. If you do not know what a percentile is, and how to calculate it, you can use google. Show your code. These numbers are the lower and upper confidence interval of the distribution.

## Confidence intervals of stratigraphic ranges

Finding the confidence intervals of stratigraphic ranges is somewhat more complicated than find the CI of a mean, so we will use a special equation by Strauss and Salder (1987).

#### Step 1

Load in the following function I wrote for you!

````R
# From Marshall's (1990) adaptation of Strauss and Sadler.
estimateExtinction <- function(OccurrenceAges, ConfidenceLevel=.95)  {
  # Find the number of unique "Horizons"
  NumOccurrences<-length(unique(OccurrenceAges))-1
  Alpha<-((1-ConfidenceLevel)^(-1/NumOccurrences))-1
  Lower<-min(OccurrenceAges)
  Upper<-min(OccurrenceAges)-(Alpha*10)
  return(setnames(c(Lower,Upper),c("Earliest","Latest"))
  }
````

#### Step 1

Let's find the extinction estimate extinction date for the genus *Lucina* using the ````estimateExtinction( )```` function.

````R
estimateExtinction(Lucina[,"min_ma"],0.95)
 Earliest    Latest 
 0.000000 -1.221208
````

#### Problem Set 3

1) Based on the confidence intervals given above, do you think it likely, or unlikely that *Lucina* is still alive?

2) Find the extinction confidence interval for the genus *Dallarca*.

3) A pure reading of the fossil record says that *Dallarca* went extinct at the end of the Pliocene Epoch. Based on its confidence interval, do you think it is possible that *Dallarca* is still extant (alive)?

4) In this case, should we trust the confidence interval or a pure reading of the fossil record? Explain your reasoning.

## Non-Uniform Recovery

The problem with the ````estimateExtinction(  )```` function is that it makes an important assumption that is unlikely to be true. 

It assumes randomly distributed fossils. In other words, the fossil occurrences of taxa are randomly distributed in time, and the likelihood of preservation does not change up or down a stratigraphic section.

For this reason, paleobiologists have developed more sophisticated versions of confidence interval analysis. However, for simplicity, we will stick with the Strauss and Sadler (1987) method. 

#### Problem Set 4

1) State one ecological reason why this assumption is unlikey to be true.

2) State one geological reason why this assumpiton is unlikely to be true.

## Testing Strauss and Sadler 

Let's take a list of bivalve genera that we know to be extant today, but are extinct according to the Paleobiology Database.

````R
# Load in a csv of extant bivalves
ExtantBivalves<-read.csv("https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/Lab7Figures/ExtantBivalves.csv",row.names=1,header=TRUE)

# Subset DataPBDB to find only occurrences of ExtantBivalves
ExtantData<-subset(DataPBDB,DataPBDB[,"genus"]%in%ExtantBivalves[,"Extant"]==TRUE)
````

#### Problem Set 5

1) How many occurrences are in ````DataPBDB````. How many are in ````ExtantData````? How many occurrences were lost by limiting our anaysis to only extant bivalves?

2) How many ````unique(  )```` genera were in ````DataPBDB```` and ````ExtantData````, respectively. Using this information, what percentage of Cenozoic bivalves in the PBDB are still extant today.

3) Find the stratigraphic range of fossil occurrences for each genus in the ````ExtantData```` dataset. If you do not remember how to do this, revisit [Problem Set 1](#problem-set-1) of this lab.

4) Using your answer to question 3, find which genera in ````ExtantData```` are not extant according to the PBDB - i.e., do not have a minimum min_age of zero. Show your code.

5) Calculate stratigraphic confidence intervals for the following genera (careful with your spelling!): *Scorbicularia*, *Meiocardia*, *Dimya*, *Digitaria*, *Cuspidaria*, *Arctica*, *Aloides*, and *Acrosterigma*. Show your code. What percentage of these taxa have confidence intervals indicating an extinction date <0?
