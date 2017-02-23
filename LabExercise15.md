# Introduction
This lab exercise will challenge you to build a probabilistic matching algorithm to link articles in the [GeoDeepDive Library](https://www.geodeepdive.org) of machine-readable documents with entries in the [Neotoma Database](https://neotomadb.org) of paleoecoogical data.

## Table of Contents
+ [Defining the Problem](#defining-the-problem)
+ [Defining a Solution](#defining-a-solution)
+ [Identifying Obstacles and Solutions](#identifying-obstacles-and-solutions)
+ [The Example](#the-example)
+ [The Assignment](#the-assignment)

## Defining the Problem
Many databases extract different kinds of information from the same sources. For example, the [Paleobiology Database](https://www.paleobiodb.org) holds information on the geolocation, geologic age, environment, and taxonomy of marine fossil occurrences. The [Ocean Biogeographic Information System](https://www.iobis.org) contains geolocation and environment information for extant marine organisms. The [iDigBio Database](https://www.idigbio.org) records which museums currently hold different specimens, but does not store where the specimens were originally collected.

Imagine that a worker collected both living and fossil organisms off the coast of St. Croix. She placed information on the fossil collections in the Paleobiology Databse, information on the living specimens in OBIS, physically stored the specimens in the Cincinnati Natural History Museum, and published a paper on these data in the journal *Paleobiology*. Because each of these databases holds different kinds of information that are not linked to each other, it would be very difficult to extract all the information related to this project in a single go. How can we make that process easier?

## Defining a Solution
We can create a lookup table to define the relationships of data entries among different databases. Using the above example of a study in St. Croix, we would want our table to look like this.

GeoDeepDive Reference ID# | PBDB Collection ID# | OBIS Collection ID# | Museum Specimen ID#
--------- | ---------- | ---------- | ----------
58a57f3acf58f | 1023 | 098203 | UCIN-09372

With this information, we can easily search those databases for all of the information related to this single project. Now, how can we build such a lookup table? What are the obstacles to doing so?

## Identifying Obstacles and Solutions
#### The Many-To-One Problem
A database entry may be mapped to multiple references, or a single reference may map to multiple entries within the same database. How can we easily represent all of this information in a single lookup table?

We want our data to be "tidy". This means that every entry from each database is represented by its own unique row and column - i.e., no cells have more than one id. The upside to this is that the data is substantially easier to select and work with, but the downside is that the table will have substantially larger dimensions than if we concatenated id's into cells.

#### References may be formatted differently among databases
The Neotoma Database stores many of its older citations as a single string formatted like most bibliographies.


The Paleobiology Database and GeoDeepDive break down the citations into separate fields.


The iDigBio database doesn't record reference information at all!

The solution is that we'll need to use some intelligent regular expressions (regex) to parse citations into a *uniform* format allowing for comparison and matching.

#### Data Changes Over Time
Data becomes obsolete over time. For example, a fossil may be published in a paper and entered into the Paleobiology Database under the species name *Brontosaurus excelsus*, but a later paper may revise that name to *Apatosaurus excelsus*. This means that different databases may data from the same source entered under different names! Similarly, simple user error such as typos or character errors may lead to confusion when trying to match enries across databases.

The solution is to create a probabilistic model that allows "fuzzy" matching of entries across databases. We will measure a variety of factors that we think indicate a good match, then we will build a model (a multiple logistic regression) that determines how well these indicators predict whether a match is correct or false. This is essentially the precursor of machine-learning.

## The Example
Here is a fairly simple R script written with my intern, Erika Ito, that matches references in the Paleobiology Database with scientific documents in the GeoDeepDive corpus. We first determine the similarity of title, authorship, year, and publication between candidate references, then build a multiple linear logistic regression model that assigns a probability to the match.

The full script is included in the below link. You can dive right in and just follow the comments (it's fairly well documented) or work along with the step-by-step instructions. Be warned that the script version is parallelized, which means that it will run ***substantially faster***. However, the parallelization functions are only available for Mac and Linux users.

**Script**: [epandda.R](https://github.com/aazaff/portfolio/blob/master/epandda.R)

### Step 1:
Install R libraries if necessary and load them into the R environment

````R
# A package for downloading data from URL's
if (suppressWarnings(require("RCurl"))==FALSE) {
    install.packages("RCurl",repos="http://cran.cnr.berkeley.edu/");
    library("RCurl");
    }
   
# A package for reading JSON files into R
if (suppressWarnings(require("RJSONIO"))==FALSE) {
    install.packages("RJSONIO",repos="http://cran.cnr.berkeley.edu/");
    library("RJSONIO");
    }

# A package for measuring the similarity of character strings
if (suppressWarnings(require("stringdist"))==FALSE) {
    install.packages("stringdist",repos="http://cran.cnr.berkeley.edu/");
    library("stringdist");
    }
````

### Step 2:
Download a list of references from the Paleobiology Database. This lists all of the references underlying data entries in the Paleobiology Database. Since these references are already tied to PBDB collection id numbers, all we need to do is match these references to the GeoDeepDive library.

````R
# Increase the timeout option to allow for larger data downloads
options(timeout=300)

# Download references from the Paleobiology Database through its Web API
GotURL<-RCurl::getURL("https://paleobiodb.org/data1.2/colls/refs.csv?all_records")
PBDBRefs<-read.csv(text=GotURL,header=TRUE)

# Pull out only the needed columns and rename them
PBDBRefs<-PBDBRefs[,c("reference_no","author1last","pubyr","reftitle","pubtitle")]
colnames(PBDBRefs)<-c("pbdb_no","pbdb_author","pbdb_year","pbdb_title","pbdb_pubtitle")

# Change data types of PBDBRefs to appropriate types
PBDBRefs[,"pbdb_no"]<-as.numeric(as.character(PBDBRefs[,"pbdb_no"]))
PBDBRefs[,"pbdb_author"]<-as.character(PBDBRefs[,"pbdb_author"])
PBDBRefs[,"pbdb_year"]<-as.numeric(as.character(PBDBRefs[,"pbdb_year"]))
PBDBRefs[,"pbdb_title"]<-as.character(PBDBRefs[,"pbdb_title"])
PBDBRefs[,"pbdb_pubtitle"]<-as.character(PBDBRefs[,"pbdb_pubtitle"])

# Remove PBDB Refs with no title
PBDBRefs<-subset(PBDBRefs,nchar(PBDBRefs[,"pbdb_title"])>2)

# Convert the title and pubtitle to all caps, because stringsim, unlike grep, cannot distinguish between cases
PBDBRefs[,"pbdb_title"]<-tolower(PBDBRefs[,"pbdb_title"])
PBDBRefs[,"pbdb_pubtitle"]<-tolower(PBDBRefs[,"pbdb_pubtitle"])
````

### Step 3:
Download a list of references from the GeoDeepDive Library. This lists all of the references we currently have where the journal title is similar to the word "Paleontology".

````R
# Download the bibjson files from the GeoDeepDive API
# Because GDD contains several million documents, and this is only an example, we only download gdd documents
# Where the publication name holds some similarity to the string "Paleontology"
Paleontology<-fromJSON("https://geodeepdive.org/api/articles?pubname_like=Paleontology")
GDDRefs<-Paleontology[[1]][[2]]

# Extract authors, docid, year, title, journal, and publisher information from the BibJson List into vectors
gdd_id<-sapply(GDDRefs,function(x) x[["_gddid"]])
gdd_author<-sapply(GDDRefs,function(x) paste(unlist(x[["author"]]),collapse=" "))
gdd_year<-sapply(GDDRefs,function(x) x[["year"]])
gdd_title<-sapply(GDDRefs,function(x) x[["title"]])
gdd_pubtitle<-sapply(GDDRefs,function(x) x[["journal"]])
gdd_publisher<-sapply(GDDRefs,function(x) x[["publisher"]])
 
# Format the geodeepdive data frame identicaly to pbdb references
GDDRefs<-as.data.frame(cbind(gdd_id,gdd_author,gdd_year,gdd_title,gdd_pubtitle, gdd_publisher),stringsAsFactors=FALSE)
    
# Change data types of GDDRefs to appropriate types
GDDRefs[,"gdd_id"]<-as.character(GDDRefs[,"gdd_id"])
GDDRefs[,"gdd_author"]<-as.character(GDDRefs[,"gdd_author"])
GDDRefs[,"gdd_year"]<-as.numeric(as.character(GDDRefs[,"gdd_year"]))
GDDRefs[,"gdd_title"]<-as.character(GDDRefs[,"gdd_title"])
GDDRefs[,"gdd_pubtitle"]<-as.character(GDDRefs[,"gdd_pubtitle"])

# Convert the title and pubtitle to all caps, because stringsim, unlike grep, cannot distinguish between cases
GDDRefs[,"gdd_title"]<-tolower(GDDRefs[,"gdd_title"])
GDDRefs[,"gdd_pubtitle"]<-tolower(GDDRefs[,"gdd_pubtitle"])
````

### Step 4:
We will now do a preliminary matching process. This process will measure the similarity of the titles between each pairwise comparison of references in the Paleobiology Database and GeoDeepDive.

````R
# Write a functions that will
# find the best title match for each PBDB ref in GDD
matchTitle<-function(x,y) {
    Similarity<-stringdist::stringsim(x,y)
    MaxTitle<-max(Similarity)
    MaxIndex<-which.max(Similarity)
    return(c(MaxIndex,MaxTitle))
    }

# Find the best title matches
TitleSimilarity<-sapply(PBDBRefs[,"pbdb_title"],matchTitle,GDDRefs[,"gdd_title"])
# Reshape the Title Similarity Output
TitleSimilarity<-as.data.frame(t(unname(TitleSimilarity)))
    
# Bind Title Similarity by pbdb_no
InitialMatches<-cbind(PBDBRefs[,"pbdb_no"],TitleSimilarity)
InitialMatches[,"V1"]<-GDDRefs[InitialMatches[,"V1"],"gdd_id"]
colnames(InitialMatches)<-c("pbdb_no","gdd_id","title_sim")

# Merge initial matches, pbdb refs, and gdd refs
InitialMatches<-merge(InitialMatches,GDDRefs,by="gdd_id",all.x=TRUE)
InitialMatches<-merge(InitialMatches,PBDBRefs,by="pbdb_no",all.x=TRUE)

# Bind Title Similarity with pbdb_no
InitialMatches<-cbind(PBDBRefs[,"pbdb_no"],TitleSimilarity)
InitialMatches[,"V1"]<-GDDRefs[InitialMatches[,"V1"],"gdd_id"]
colnames(InitialMatches)<-c("pbdb_no","gdd_id","title_sim")

# Merge initial matches, pbdb refs, and gdd refs
InitialMatches<-merge(InitialMatches,GDDRefs,by="gdd_id",all.x=TRUE)
InitialMatches<-merge(InitialMatches,PBDBRefs,by="pbdb_no",all.x=TRUE)   
````

### Step 5:
Now that we have preliminarily found the best title matches for each PBDB reference within the GeoDeepDive Library, let's extract additional information that might indicate whether these are likely matches.
+ Is the first author's last name according to the PBDB reference information present anywhere in the list of author names accordinging to the GeoDeepDive bibliographic information?
+ Is the publication year identical between both references?
+ What is the similarity of the publication (e.g., journal) name between references?

````R
# A function for matching additional bibliographic fields between the best and worst match
matchAdditional<-function(InitialMatches) {
    # Whether the publication year is identical
    Year<-InitialMatches["pbdb_year"]==InitialMatches["gdd_year"]
    # The similarity of the journal names
    Journal<-stringsim(InitialMatches["pbdb_pubtitle"],InitialMatches["gdd_pubtitle"])
    # Whether the first author's surname is present in the GDD bibliography
    Author<-grepl(InitialMatches["pbdb_author"],InitialMatches["gdd_author"],perl=TRUE,ignore.case=TRUE)
    # Return output     
    FinalOutput<-setNames(c(InitialMatches["pbdb_no"],InitialMatches["gdd_id"],InitialMatches["title_sim"],Author,Year,Journal),c("pbdb_no","gdd_id","title_sim","author_in","year_match","pubtitle_sim"))
    return(FinalOutput)
    }

# Perform the additional matches
MatchReferences<-apply(InitialMatches, 1, matchAdditional)

# Reformat MatchReferences
MatchReferences<-as.data.frame(t(MatchReferences),stringsAsFactors=FALSE)
# Fix the data types for MatchReferences (to match the Training Set - next step)
MatchReferences[,"title_sim"]<-as.numeric(MatchReferences[,"title_sim"])
MatchReferences[,"pubtitle_sim"]<-as.numeric(MatchReferences[,"pubtitle_sim"])
MatchReferences[,"author_in"]<-as.logical(MatchReferences[,"author_in"])
MatchReferences[,"year_match"]<-as.logical(MatchReferences[,"year_match"])
````

### Step 6:
Now that created a list of candidate matches, we want to measure the probability that these matches are actually correct. For this we need a training set. A training set is a series of matches that we already know *ex ante* to be `TRUE` or `FALSE`. I have already prepared such a set for you.

````R
# Upload a training set of manually scored correct and false matches
TrainingSet<-read.csv("https://raw.githubusercontent.com/aazaff/portfolio/master/CSV/learning_set.csv",stringsAsFactors=FALSE)
````

### Step 7:
We are going to run a series of [multiple linear logistic regressions](/LabExercise12.md#selectivity-patterns-of-mass-extinctions) to fit a probability to our results.

````R
# Check the plausible regression models
Model1<-glm(Match~title_sim,family="binomial",data=TrainingSet)
Model2<-glm(Match~title_sim+author_in,family="binomial",data=TrainingSet)
Model3<-glm(Match~title_sim+author_in+year_match,family="binomial",data=TrainingSet)
Model4<-glm(Match~title_sim+author_in+year_match+pubtitle_sim,family="binomial",data=TrainingSet)

# Make predictions from the basic set
Probabilities<-round(predict(Model4,MatchReferences,type="response"),4)
    
# Make a table of the probabilities of matches to see how many matches we have
table(Probabilities)
````

## The Assignment
Your mission, if you choose to accept it, is to try and duplicate something *akin* to this process, but attempt to match references in [Neotoma](https://www.neotomadb.org) to GeoDeepDive.

There are a few things you should consider.
+ There is no "right" way to do this. There are many solutions that could be acceptable. The only criterion for success is if you have created a method that gives you correct matches when you taste it.
+ You will want to download Neotoma references using its API, just like how we downloaded data from the PBDB using its API. You can find documentation for the Neotoma API [here](http://api.neotomadb.org/doc/resources/publications). 
+ Neotoma references are formatted quite differently than in PBDB. This means that you could try a substantially different approach or try to convert the Neotoma data to be more like the PBDB. 
