# Selectivity patterns of mass extinctions

Today we will be learning how to test for selectivity patterns at mass extinctions using data from the [Paleobiology Database](https://paleobiodb.org).

## Tropical v. Extratropical Brachiopods
We will first work through an example at the Permo-Triassic boundary to calculate a simple odds ratio testing whether tropical or extratropical brachiopod genera were more likley to go extinct. You will then work through your own problem set dealing with selectivity patterns among Terrestrial vertebrates at the Triassic/Jurassic boundary.

#### Step 1
Load in the beta version of the [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R/blob/master/README.md#paleobiologydatabaser) package's [communityMatrix.R](https://github.com/aazaff/paleobiologyDatabase.R/blob/master/README.md#communitymatrixr) module.
````R
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/communityMatrix.R")
````

#### Step 2
Download a data set of Lopingian Brachiopods and post-permian Brachiopods.
````R
# Download the data
Lopingian<-downloadPBDB("Brachiopoda","Lopingian","Lopingian")
PostPermian<-downloadPBDB("Brachiopoda","Triassic","Neogene")

# Clean the data a bit
Lopingian<-cleanRank(Lopingian,"genus")
PostPermian<-cleanRank(PostPermian,"genus")
````

#### Step 3
Next we need to identify which Lopingian genera are Tropical and which are Extratropical. Many genera will have both tropical and extratropical occurrences. For simplicity, we want to look at **ONLY** genera that are restricted to one category or the other. For the purposes of this lab, we are going to define the tropics as between -23.5&deg; and 23.5&deg; degrees, and extratropical as outside of that range.

````R
# Subset to tropical occurrences
TropicalOccs<-subset(Lopingian,Lopingian[,"paleolat"] >= -23.5 & Lopingian[,"paleolat"] <= 23.5)
ExtraTropicalOccs<-subset(Lopingian,Lopingian[,"paleolat"] <= -23.5 | Lopingian[,"paleolat"] >= 23.5)

# Subset to only occurrences of genera that are UNIQUE to the Tropics or Extratropics
TropicalGeneraOccs<-subset(TropicalOccs,TropicalOccs[,"genus"]%in%ExtraTropicalOccs[,"genus"]!=TRUE)
ExtraTropicalGeneraOccs<-subset(ExtraTropicalOccs,ExtraTropicalOccs[,"genus"]%in%TropicalOccs[,"genus"]!=TRUE)
````

#### Step 4
Now let's extract of the unique Lopingian tropical and extratropical genera.
````R
TropicalGenera<-unique(TropicalGeneraOccs[,"genus"])
ExtraGenera<-unique(ExtraTropicalGeneraOccs[,"genus"])
````

#### Step 5
Now, let's sort both categories (Tropical and Extratropical) into survivors and victims of the Permo-Triassic extinction.

````R
# The intersect( ) function returns the elements of vector A that are present in vector B
TropicalSurvivors<-intersect(TropicalGenera,unique(PostPermian[,"genus"]))
# The setdiff( ) function returns the elemtns of Vector A that are absent in vector B
TropicalVictims<-setdiff(TropicalGenera,unique(PostPermian[,"genus"]))

ExtraSurvivors<-intersect(ExtraGenera,unique(PostPermian[,"genus"]))
ExtraVictims<-setdiff(ExtraGenera,unique(PostPermian[,"genus"]))
````

#### Step 6
Now, let's calculate the odds ratio of tropical survival to tropical victims. For a review of odds calculations, you can review this [previous lecture](http://teststrata.geology.wisc.edu/teachPaleobiology/LectureSlides/ExtinctionRisk02152016.pdf) from class. Remember, the key to finding the relative odds is to find the *odds ratio*. The odds ratio is the proportion of TRUE results over the proportion of FALSE results.

````R
# The odds of tropical survival
TropicalOdds<- (length(TropicalSurvivors)/length(TropicalGenera)) / (length(TropicalVictims)/length(TropicalGenera))

# The odds of extratropical survival
ExtraOdds<- (length(ExtraSurvivors)/length(ExtraVictims)) / (length(ExtraVictims)/length(ExtraGenera))

# Find the final odds ratio
OddsRatio<- TropicalOdds / ExtraOdds
[1] 1.617845
`````

#### Step 7
Now we need to interpret our odds ratio of 1.617845. Remember that even odds represent a ratio of 1:1. So the fact that our odds are greater than 1, means that our numerator (Tropical Survival) was more likely thatn our denominator (ExtratropicalSurvival). In other words, Tropical brachiopods were more likley to survive the end-Permian extinction that extratropical brachiopods. 

Remember that we can also look at the log-odds. The benefit of this is that this converts the odds ratio into a symmetric measure. A value of zero means no difference (because log(1)=0), positive values mean an advantage for Tropical brachiopods, and negative values mean an advantage for Extratropical brachiopods. 
````R
log(OddsRatio)
[1] 0.481095
````

Of course, both the log-odds and regular odds show the same result - it is just that some people consider log-odds to be more intuitive because of their symmetry.

#### Step 8
However, we should consider whether this effect is strong enough for us to take seriously. For this we will need to calculate a confidence interval. 

We have discussed confidence intervals in some of the other labs, but here is a referesher on the general formula. 
> ConfInt = PointEstimate &#177; Standard Error * Confidence Level. 

In this case, the log of the odds ratio ````log(1.617845)```` is the Point Estimate. The confidence level is 95%, which is equal to 1.96. This means that we need to solve for the Standard Error.

The formula for the standard error of a log-odds ratio is
&#8730;(1/A + 1/B + 1/C +1/D), where...

A = length(TropicalSurvivors)
B = length(TropicalVictims)
C = length(ExtraSurvivors)
D = length(ExtraVictims)

````R
# Find the Standard Error
StandardError<-sqrt(1/length(TropicalSurvivors) + 1/length(TropicalVictims) + 1/length(ExtraSurvivors) + 1/length(ExtraVictims))
StandardError
[1] 0.4461437

# Find the Upper 95% Confidence limit
UpperLimit<-log(OddsRatio) + (StandardError*1.96)
UpperLimit
[1] 1.355537

# Find lower Upper 95% confidence limit
LowerLimit<-log(OddsRatio) - (StandardError*1.96)
> LowerLimit
[1] -0.3933466
````

Notice that the Lower Limit of our confidence interval is negative! This means that we cannot rule out the possibility that there was not actually an advantage for extratropical taxa. In other words, our result is not "statistically significant".

## Problem Set 1

There is a longstanding story that Triassic Diapsids outcompeted Triassic Syanpsids. Let's see if Triassic Diapsids were more likley to survive the Traissic/Jurassic extinction than Synapsids.

#### Question 1
Download four data sets from the paleobiology database. First, a dataset of Anisian-Rhaetian Synapsids, name it ````TriassicSynapsids````. Second, a dataset of Anisian-Rhaetian Diapsids, name it ````TriassicDiapsids````. Third, a dataset of post-Triassic Diapsids, name it ````JurassicDiapsids````. Fourth, a dataset of post-Triassic Synapsids, name it ````JurassicSynapsids````. Show your code.

Hint:
+ Use the formal terms *Diapsida* and *Synapsida* when downloading the data.

#### Question 2
How many Diapsid genera were there in the Triassic dataset? How many Synapsid genera? Show your code.

Hint:
+ Remember, there is a difference between the number of genera and the number of occurrences.
+ Don't forget to clean up the genus names!

#### Question 3
How many Triassic Diapsid genera survived the Triassic/Jurassic transition? How many were victiims? How many Triassic Synapsid genera surivived the Triassic/Jurassic Transition? How many were victims? Show your code.

#### Question 4
Calculate the odds ratio and log-odds that Diapsid genera were more likely to survive the T/J transition than Synapsids

#### Question 5
Using a 95% confidence interval, can you say that this odds/ratio is "statistically significant"? Show your code.

## The Continous Case
The basic odds ratio that we've learned about so far is a little bit limiting, because you can only use it when you have a 2x2 system. What if you want to know if a *continuous* variable is related to the probability of extinction. You can use **logistic regression** in this case.

We won't go over the underlying theory of logistic regressions today other than to say that it is simply an extension of the same principles of odds-ratio calculation that we discussed in the previous section. Today, we are just going to learn how to perform a logistic regression. Our question is going to be whether the mean paleo-latitude of Lopingian brachiopod occurrences predicts whether a taxon was a survivor or victim of the Permo-Triassic extinction

#### Step 1
````R
# Find the mean paleolatitude of each genus's occurrences.
MeanLatitudes<-tapply(Lopingian[,"paleolat"],Lopingian[,"genus"],mean)
head(MeanLatitudes)
      Acosarina   Actinoconchus  Alatoproductus Alatorthotetina Alispiriferella    Allorhynchus 
      -15.20944         3.42000       -13.44000       -10.45625         0.92000       -30.53300
````

#### Step 2
Next, we need to find which genera were survivors and which were victims.
````R
# Find the Survivors
LopingianSurvivors<-subset(Lopingian,Lopingian[,"genus"]%in%unique(PostPermian[,"genus"])==TRUE)
LopingianSurvivors<-unique(LopingianSurvivors[,"genus"])
head(LopingianSurvivors)
[1] "Martinia"         "Acosarina"        "Dielasma"         "Lampangella"      "Spinomarginifera" "Araxathyris"  


# Find the Victims
LopingianVictims<-subset(Lopingian,Lopingian[,"genus"]%in%unique(PostPermian[,"genus"])!=TRUE)
LopingianVictims<-unique(LopingianVictims[,"genus"])
head(LopingianVictims)
[1] "Marginalosia" "Terrakea"     "Spiriferella" "Tomiopsis"    "Notospirifer" "Maorielasma" 
````

#### Step 3
We need to create a matrix, where each row represents a genus, one column denotes its mean latitude, and another column denotes status as a survivor or victim. There are many ways to achieve this, but are going to use the following approach. 

In this case, victims will be represented by a 0 and survivors by a 1.

````R
# We will create an array of zeroes, with the names of genera that were victims
PTVictims<-array(0,dim=length(LopingianVictims),dimnames=list(LopingianVictims))
head(PTVictims)
Marginalosia     Terrakea Spiriferella    Tomiopsis Notospirifer  Maorielasma 
           0            0            0            0            0            0 

# Next we will merge this new array with the MeanLatitudes vector we created in Step 1 using the merge( ) function
FinalMatrix<-merge(MeanLatitudes,PTVictims,all=TRUE,by="row.names")

head(FinalMatrix)
        Row.names         x  y
1       Acosarina -15.20944 NA
2   Actinoconchus   3.42000  0
3  Alatoproductus -13.44000  0
4 Alatorthotetina -10.45625  0
5 Alispiriferella   0.92000  0
6    Allorhynchus -30.53300  0
````

#### Step 4
Let's clean up this matrix so that it looks a bit nicer and it is clearer what is going on.

First, let's change the row.names column to actually be the rownames, and then delete the Row.names column. We'll use the ````transform( )```` function to do this. Note that this step is not necessary, per se.
````R
FinalMatrix<-transform(FinalMatrix,row.names=Row.names,Row.names=NULL)
````

Next, let's change the column names to be more meaningful
````R
colnames(FinalMatrix)<-c("MeanLatitudes","Survivor/Victim")

head(FinalMatrix)
                MeanLatitudes Survivor/Victim
Acosarina           -15.20944              NA
Actinoconchus         3.42000               0
Alatoproductus      -13.44000               0
Alatorthotetina     -10.45625               0
Alispiriferella       0.92000               0
Allorhynchus        -30.53300               0
````

#### Step 5
Notice that some genera - e.g., *Acrosarina* - have an NA for survivor/victim status. This is because although we assigned 0s to the victims, we did not assign anything to the survivors. What we want to do now is change all instances of NA to 1 in order to denote survivor status.

````R
FinalMatrix[is.na(FinalMatrix[,"Survivor/Victim"]),]<-1

head(FinalMatrix)
                MeanLatitudes Survivor/Victim
Acosarina             1.00000               1
Actinoconchus         3.42000               0
Alatoproductus      -13.44000               0
Alatorthotetina     -10.45625               0
Alispiriferella       0.92000               0
Allorhynchus        -30.53300               0
````

#### Step 6
Now we can perform our logistic regression using the ````glm(  )```` function. GLM stands for generalized linear model which is a broad family of regressions. Logistic regression is just one member of that family.

The basic formula for a regression in R is to put your outcome on the left and your input on the right, separated by a tilde - e.g., Outcome ~ Input.

In our case, the Outcome of our regression model is whether a genus is a Survivor or Victim, and the Input is the Mean Latitude of the genus.

````R
# Notice that we must specify family="binomial", because we are specifically using the logistic regression (binomial) member of the glm family.
Regression<-glm(FinalMatrix[,"Survivor/Victim"]~FinalMatrix[,"MeanLatitudes"],family="binomial")
````

#### Step 7
In order to see a summary of our regression we need to use the summary( ) function, which will allow us to interpret its results.

````R
summary(Regression)
Call:
glm(formula = FinalMatrix[, "Survivor/Victim"] ~ FinalMatrix[, 
    "MeanLatitudes"], family = "binomial")

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-1.0659  -0.5442  -0.4719  -0.3745   1.9619  

Coefficients:
                               Estimate Std. Error z value Pr(>|z|)    
(Intercept)                    -1.78469    0.15164 -11.769  < 2e-16 ***
FinalMatrix[, "MeanLatitudes"]  0.01783    0.00490   3.638 0.000275 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 311.04  on 406  degrees of freedom
Residual deviance: 297.48  on 405  degrees of freedom
AIC: 301.48

Number of Fisher Scoring iterations: 5
````

The most important information for you to understand from this output is the slope of the line that you just calculated, the "Estimate" - i.e, 0.01783. This is the slope of the log-odds relationship. In other words, for every one degree increase in the latitude of the genus, its (log) odds of having survived the P/T event increases by 0.01783.

In other words, genera with average latitudes in the  Northern hemisphere were more likely to survive the P/T than taxa from the Southern hemisphere.

## Problem Set 2

Let's apply the technique that you just learned the Triassic and Jurassic Diapsids and Synapsids.

#### Queston 1
Download a dataset of Anisian-Rhaetian Diapsids and Synapsids, and a dataset of post-Triassic Diapsids and Synapsids. Show your code.

#### Question 2
Find the mean latitude of each genus's occurrences in your Triassic dataset. Show your code.

#### Question 3
Find which Triassic genera were survivors and which were victims of the Triassic/Jurassic event. Show your code.

#### Question 4
Find which genera of your Triassic dataset were Diapsids and which were Synapsids. Show your code.

#### Question 5
Perform a logistic regression where the outcome variable is Survivor/Victim and the input variable is the mean latitude of each genus. Show your code. Which 

#### Extra Credit (6 Points)
Perform a *multiple* logistic regression where the outcome varaible is Survivor/Victim status and the input variables are the mean latitude of each genus ***and*** whether the gneus is a Diapsid/Synapsid. Is status as a Synapsid/Diapsid more or less important average paleolatitude of occurrences for survival? Show your code. 

Hint:
+ The general formula for a *multiple* logistic regression is: glm(Outcome ~ Variable1 + Variable2,family="binomial")
+ You'll want to represent Diapsids and Synapsids with 1s and 0s, similarly to how we did survivor and victim status
