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

There are four columns in ````DataPBDB```` relevant to the age of an organism: ````early_interval, late_interval, max_ma, and min_ma````. Because we rarely have a precise date, we generally give the age of an occurrence as a range. This range can be expressed with an interval name or with a number.

1) What do the max_ma and min_ma columns represent? If you do not intuitively know, you can always check the [Paleobiology Database API documentation](https://paleobiodb.org/data1.2/occs/list_doc.html).

2) What is oldest age of each genus? [[Hint](https://github.com/aazaff/startLearn.R/blob/master/intermediateConcepts.md#L244): Use the ````tapply(  )```` and ````max(  )```` functions we've used in previous labs]. Show the code you would use to find out.

3) What is the youngest age of each genus? [[Hint](https://github.com/aazaff/startLearn.R/blob/master/intermediateConcepts.md#L244): Use the ````tapply(  )```` and ````max(  )```` functions we've used in previous labs]. Show the code you would use to find out.

4) We probably 
