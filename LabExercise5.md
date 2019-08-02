## Table of Contents
- [Configuring R Environment](#configure-r)
- [Richness I: Introduction](#richness-introduction)
  - [Richness I: Questions I](#richness-questions-i)
  - [Richness I: "Downside"](#richness-downside)
  - [Richness I: Questions II](#richness-questions-ii)
- [Frequency Distributions: Introduction](#frequency-distribution-introduction)
  - [Frequency Distributions: Questions I](#frequency-distribution-questions-i)
  - [Frequency Distributions: Proper Visualization](#frequency-distribution-proper-visualization)
  - [Frequency Distributions: Questions II](#frequency-distribution-questions-ii)
- [Evenness: Introduction](#evenness-introduction)
  - [Evenness: Questions](#evenness-questions)
- [Probability of Encounter: Introduction](#probability-of-encounter-introduction)
  - [Probability of Encounter: Questions](#probability-of-encounter-questions)
- [Entropy: Introduction](#entropy-introduction)
  - [Entropy: Questions](#entropy-questions)
- [Hill Numbers: Introduction](#hill-numbers-introduction)
  - [Hill Numbers: Questions](#hill-numbers-questions)
- [Frequency Distributions II: Linear Models](#frequency-distributions-ii-linear-models)
  - [Frequency Distributions II: Questions I](#frequency-distributions-ii-questions-i)
- [Sampling Standardization: Introduction](#sampling-standardization-introduction)
  - [Sampling Standardization: Questions I](#sampling-standardization-questions-i)
  - [Sampling Standardization: Area Revisited](#sampling-standardization-area-revisited)
  - [Sampling Standardization: Subsampling](#sampling-tandardization-Subsampling)
  - [Sampling Standardization: Questions II](#sampling-standardization-questions-ii)
- [Extrapolation: Richness](#extrapolation-richness)
  - [Extrapolation: Questions I](#extrapolation-questions-i)
  - [Extrapolation: Frequency Distributions](#extrapolation-frequency-distributions)
  - [Extrapolation: Questions II](#extrapolation-questions-ii)
  - [Extrapolation: Richness](#extrapolation-richness-ii)
  - [Extrapolation: Questions III](#extrapolation-questions-iii)
- [Temporal Dynamics: Introduction](#temporal-dynamics-introduction)
  - [Temporal Dynamics: Cohort Analysis](#temporal-dynamics-cohort-analysis)
  - [Temporal Dynamics: Questions I](#temporal-dynamics-questions-i)
  - [Temporal Dynamics: Turnover Rates](#temporal-dynamics-turnover-rates)
  - [Temporal Dynamics: Questions II](#temporal-dynamics-questions-ii)
- [Spatial Dynamics: Introduction](#spatial-dynamics-introduction)
  - [Spatial Dynamics: Questions I](#spatial-dynamics-questions-i)
  - [Spatial Dynamics: Beta Diversity](#spatial-dynamics-beta-diversity)
  - [Spatial Dynamics: Questions II](#spatial-dynamics-beta-diversity)
  - [Spatial Dynamics: Polar Ordination](#spatial-dynamics-polar-ordination)
  - [Spatial Dynamics: Questions III](#spatial-dynamics-questions-iii)
  - [Spatial Dynamics: Correspondence Analysis](#spatial-dynamics-correspondence-analysis)
  - [Spatial Dynamics: Detrended Correspondence Analysis](#spatial-dynamics-detrended-correspondence-analysis)
  - [Spatial Dynamics: Multi-Dimensional Scaling](#spatial-dynamics-multi-dimensional-scaling)

## Configure R
Download the `velociraptr` package from CRAN and change the download timeout. You can always check your currently active libraries with `installed.packages()` or `sessionInfo()`. Also, note the difference between `require()` and `library()` and how this is used in the configuration script.

````R
# This will check if you have the velociraptr package installed
# It not, it will download, install, and activate it
# If you already have it installed, then it will simply activate it.
if (suppressWarnings(require("velociraptr"))==FALSE) {
    install.packages("velociraptr",repos="http://cran.cnr.berkeley.edu/");
    library("velociraptr");
    }

# vegan is a popular ecoinformatics package
if (suppressWarnings(require("vegan"))==FALSE) {
    install.packages("vegan",repos="http://cran.cnr.berkeley.edu/");
    library("vegan");
    }

# DescTools is an extemely popular package of cross-disciplinary summary statistics
if (suppressWarnings(require("DescTools"))==FALSE) {
    install.packages("DescTools",repos="http://cran.cnr.berkeley.edu/");
    library("DescTools");
    }

# sf is an extemely popular package for geographic (GIS) analysis
if (suppressWarnings(require("sf"))==FALSE) {
    install.packages("sf",repos="http://cran.cnr.berkeley.edu/");
    library("sf");
    }

# Change the maximum timeout t0 300 second. This will allow you to download larger datafiles from 
# the paleobiology database.
options(timeout=300)

# Functions are camelCase. Variables and Data Structures are PascalCase
# Fields generally follow snake_case for better SQL compatibility
# Dependency functions are not embedded in master functions
# []-notation is used wherever possible, and $-notation is avoided.
# []-notation is slower, but is explicit about dimension and works for atomic vectors
# External packages are explicitly invoked per function with :: operator
# Explict package calls are not required in most cases, but are helpful in tutorials
````

## Richness: Introduction
The simplest and most common biodiveristy metric is *richness*. Richness is applicable to any categorical dataset, and is simply the total number of categories. Let's begin by downloading a dataset of all Pleistocene mammal genera in the Paleobiology Database.

````R
# Download all representatives of mammalia that are withint he Pleistocnee boundary
Mammals = velociraptr::downloadPBDB(Taxa="Mammalia",StartInterval="Pleistocene",StopInterval="Pleistocene")
````

Take some time to examine this dataset. It is always worth taking time to familiarize yourself with a dataset *before* you commit
to an analysis. Here are some functions that you may find useful for quickly perusing the data: `head()`, `dim()`, `table()`, `subset()`, and `unique()`. Remember, you can always learn more about a particular funciton by using `help()` or `?`.

### Richness: Questions I
1. How many fossil occurrences are in this dataset? 
2. How many paleobiology database collections are in this dataset?
3. What is the species richness, genus richnss, and family richness of this dataset?
4. What is the species richness of the family Vespertilionidae?
5. Which family has the highest genus richness? - hint: look at the function `tapply()`
6. Closely inspect the text values in the family, genus, and accepted_name fields. Can you see any problems with the quality of these data?

## Richness: "Downside"
One significant "downside" of richness is that it is very sensitive to sampling *effort*. The more effort one spends to identify species within a sample, the more species that are likely to be found. This, by itself, really isn't really a problem since this will be true for any statistical sample of a population; however, there are two properties of taxonomic data that make it difficult to correct for this problem.

1. The relationship of richness to sampling effort is *non-linear* and unique to each sample. This means that it is potentially *very* inaccurate to standardize sampling effort using a constant. For example, you cannot simply divide the richness of samples by their respective weights because the expected number of new species per unit of weight is not constant within or among samples.
2. Consistent data on the sampling effort used to collect data within samples is rarely (almost never) collected or reported. This gnerally means that an assumed proxy for sampling effort must be used (e.g., the number of individuals collected per sample, the areal extent of samples). Unfortunately, the actual relationship of these proxies to sampling effort will vary from sample to sample. For example, just because Sample A was collected over a larger area than Sample B, does not necessarily mean that more *effort* was spent cataloguing the species in Sample A than B.

Let's simulate some data to understand the basic difficulties of measuring richness.

````R
# Set the seed for your randomization procedure, this way everyone will get the exact same
# result, even though we are technically "randomly" sampling
set.seed(42)

# Use the sample() function to randomly sample letters from the alphabet
# The letters variable comes preloaded in r.
Fake = sample(letters, 26, replace=TRUE)

# Display the unique letters sampled
unique(Fake)

# Display how many of each letter was sampled
table(Fake)
````

Notice that even though we sampled from a [discrete uniform distribution](https://en.wikipedia.org/wiki/Discrete_uniform_distribution) of letters - i.e., all letters had an equal probability of being sampled - we did not sample all 26 letters of the alphabet. Furthermore, some letters were sampled multiple times, giving the impression that some letters (species) are more abundant than others dsepite all letters actually being equally abundant.

**We will revisit this problem and discuss some solutions in a later exercise.**

### Richness: Questions II

Let's consider what would happen if we assumed that our sample was actually an accurate representation of the underlying frequency distribution of letters in the population, and we used that data to power an analysis.

````R
set.seed(88)

# Create a new distribution to sample from, see the previous code-block to see where the object Fake comes from.
Resample = rep(x=names(table(Fake)),times=table(Fake))

# Sample 26 times from the new distribution, as we did previously
DoubleFake = sample(Resample, 26, replace=TRUE)
````

1. The varaible Resample was created using the functions `rep()`, `names()`, and `table()`. Additionally, the function `rep()`, used the arguuments `x` and `times`. Can you describe the role of these functions and arguments in this script?
2. What was the richness and the frequency distribution of the new sample DoubleFake? How did this compare to the original population?
3. What is the probability that if we sample 26 letters with replacement, that we will sample all 26 letters?

We will talk about the problem of richness more in depth in a later exercise, and ~~better~~ common methods to account for the sampling effort problem.

## Frequency Distribution: Introduction
As you may have seen from the previous exercise, even very small changes in the frequency distribution (i.e., how often each species occurs in the dataset) can dramatically impact estimated richness. More abundant taxa are more likely to be sampled and less abundant taxa are less likely to be sampled. Therefore, it is often worth analyzing the frequency distribution.

Let's start by creating a few fake datasets for comparison. **We'll talk about more robust ways to create fake datasets and various random distributions in a later exercise.**

````R
# Discrete Uniform
Uniform = letters

# Power distribution
Power = rep(letters, times=(1:26)^2)

# Linear Distribution
Linear = rep(letters,times=1:26)
````

### Frequency Distribution: Questions I
1. Take a randomized "samples" of each of the three populations using the `sample()` function. Let your sample size be 52 for each.
2. Use the following functions, `density()` and `hist()` to view the [frequency distributions](https://www.statmethods.net/graphs/density.html) of each sample. Describe the general shape of each.
3. Which of your samples gave the most accurate view of the true richness, which gave the least? Why do you think that is?
4. Calculate basic summary statistics for each of your random samples - mean, median, standard deviation, variance, skew, and kurtosis.
5. If you were only given the moments for each of your sampled distributions, could you infer the shape of the original distribution? Which moments would you need at minimum?

## Frequency Distribution: Proper Visualization
Kernel density (`density()` and histograms (`hist()`) are extremely popular for analyzing frequency distributions, but suffer from some clear problems. Namely, they both apply an arbitrary binning of the data. The [most robust methods](http://brian-mcgill-4.ums.maine.edu/sad_review.pdf) for plotting frequency distribution in ecological data are Rank Abundance Diagrams (RADs) and Lorenz Curves.

Let's make a simple RAD and a simple Lorenz Curve

````R
# Let's use some real data this time
Bryozoa = velociraptr::downloadPBDB(Taxa="Bryozoa",StartInterval="Bartonian",StopInterval="Priabonian")
# Clean out the subgenera and blanks
Bryozoa = cleanTaxonomy(Bryozoa,Taxonomy="genus")

# Create a frequency distribution of the genus occurrences with table(), and sort() it from most abundant to 
# least abundant. Note, that some workers prefer to sort from least abundant to most when plotting.
Frequencies = sort(table(Bryozoa[,"genus"]),decreasing=TRUE)

# Make a rank abundance diagram. 
plot(y=as.vector(Frequencies),
	x=1:length(Frequencies),
	xlab="order from most abundant to least abundant",
	ylab="genus frequency",
	las=1,xaxs="i",yaxs="i",pch=16,cex=1.5,
	xlim=c(0,length(Frequencies)),ylim=c(0,50)
	)	
````

Notice that the shape of the diagram is *strongly* non-linear. There are only a handful of very abundant genera, and many very rare genera. This distribution of few abundant taxa and many rare taxa is colloquially known as a "hollow curve" and is *ubiquitous* in ecological datasets. It can be found in almost any type of ecological data: marine, terrestrial, vertebrate, invertebrate, plant, micro, macro, fossil, modern, fine-scale, or broad-scale data. 

**We'll talk more about the theory of why this is the case in a later exercise.**

````R
# Create a Lorenz Curve of the genus occurrences
# Unlike a RAD, the x-axis of the Lorenz is ALWAYS sorted from least to most abundant
Frequencies = sort(table(Bryozoa[,"genus"]),decreasing=FALSE)

# Plot a Lorenz Curve
plot(y=cumsum(Frequencies)/sum(Frequencies),
	x=1:length(Frequencies)/length(Frequencies),
	xlab="percentile",
	ylab="cumulative frequency as percentile",
	las=1,xaxs="i",yaxs="i",pch=16,cex=1.5,
	xlim=c(0,1),ylim=c(0,1)
	)

# Add a 45° line.
abline(a=0,b=1,col="red",lwd=2)	
````
A Lorenz curve is essentially a special form of RAD. It shows for the bottom x% of species, what percentage (y%) of the total population they have. 

### Frequency Distribution: Questions II
1. The Lorenz curve was actually borrowed from the field of economics, where it is usually used to describe income inequality. If you've ever heard someone talk about how the X% holds Y% of the wealth, those statistics ultimately come from a Lorenz curve. Create your own fictional dataset of 100 species where the top 20% of species have 80% of the total sample population.
2. Plot out your fictional dataset as a RAD and as a Lorenz curve.
3. Create a perfectly equitable distribution of 100 species (discrete uniform), where every species has the same abundance. Plot it as a RAD and a Lorenz curve.

## Evenness: Introduction
It would be extremely convenient if the information contained in frequency distributions could be distilled into a single summary number. However, just like trying to describe any other distribution with a summary statistic - e.g., mean, median, variance - you need to determine what *aspect* of the distribution you are really trying to understand.

In biodiversity sciences, many workers are especially concerned with the idea of *Evenness*, what would be called *Inequality* in other disciplines (also rarely called Heterogeneity or Heterozygosity... don't get me started). An ecological example of a perfectly *even* community is one where all species have the same frequencies/abundance/population size, and a perfectly *uneven* community is one where all species are rare except one. Many workers equate the idea of evenness/inequality rather than richness, with biodiversity. We will discuss why this is in the next session.

The most common index used to characterize Evenness/Inequality is the Gini Coefficient or Gini Index (not to be confused with the Gini-Simpson Index), which is derived from the Lorenz Curve.

![GINI INDEX IMAGE](Lab5Figures/gini.png)

There are a few different ways to calculate Gini. Let's try some.

````R
# We will use the same information we used to calculate the Lorenz Curve in the previous example
X = 1:length(Frequencies)/length(Frequencies)
Y = cumsum(Frequencies)/sum(Frequencies)

# Remember that the area under the Lorenz Curve is B in our Gini Formulas
# Let's use the AUC (area-under-curve) function in DescTools to find B 
B = DescTools::AUC(X,Y,method="spline")

# Calculate the GINI coefficient using the formula
GINI = 1-2*B

# Let's check our results using an analytical solution from DescTools Gini function
GINI2 = DescTools::Gini(Freqeuncies)

# The Results are slightly different because GINI2 uses an anlytical solution, whereas
# GINI uses a geometric approximation - i.e., AUC is approximate
GINI - GINI2
````

### Evenness: Questions
1. Download a datset of Priabonian Bivalves from the Paleobiology Database and calculate the genus-level Gini.
2. The Gini coefficient was originally designed by economists to study income inequality. Can you see a difference between income and species abundance that might affect the calculation of Gini?

## Probability of Encounter: Introduction
Another method to try and summarize the frequency distribution in terms of the probability of a certain outcome. For example, what is the probability that if you drew any two species from your species pool that you would get two members of the same species? Two members of different species? 

This is known as the Probabiliy of Interspecific Encounter, Simpson's Diversity, Gini-Simpson Index, Simpson's D, or the Herfindahl-Hirschman Index.

````R
# We'll use the same Bryozoan dataset from before. First let's calcualte the Simpson diversity using
# the vegan package. vegan is a popular (though somewhat long in the tooth) package for calcualting ecological metric.
Simpson = vegan::diversity(Frequencies,"simpson")

# Sometimes people prefer to express the Simpson index where 0 means no diversity and 1 means fully diverse.
# Subtract from one to switch between scales. Just don't forget what scale you're using!
Inverted = 1 - Simpson

# Now that we know our answer, let's try and manually calculate the data accordingly.
# First we will need to convert our Abundances into proportions
Proportions = Frequencies/sum(Frequencies)
HillGini = sum(Proportions^2)^(1/(1-2))

# Simply invert the result and you should get the same exact value you got from vegan.
HillGini = 1/(1-HillGini)
````
### Probability of Encounter: Questions
Let's see if we can empirically recreate this probability estimate. We can use a `for()` statement to repeatedly `sample()` from our previous distribution. This will let us collect a frequency for how often we draw two fossil occurrences of the same genus from our dataset.

````R
# A function to take 2 species from our underlying frequency distribution
resample = function(Data, Iterations=10000) {
	Output = matrix(NA,nrow=Iterations,ncol=2) # Create a 2-column table to to store the genera taken in each draw
	colnames(Output) = c("genus_1","genus_2") # name the columns. Always use lower snake_case for field names
	for (iteration in seq_len(Iterations)) {
		Output[iteration,] = sample(Data,2,replace=TRUE)
		}
	return(Output)
	}

# Set the seed so we all get the same results
set.seed(108) 

# Create an empirical frequency distribution
Empirical = resample(Data = Bryozoa[,"genus"], Iterations = 10000)
````

1. Calculate the number of times you drew 2 members of the same genus. You may find the functions `apply()` and `which()` helpful. How did this compare with the analytic solutions for Simpson's D we calculated earlier?
2. Try running the experiment 10 times and take the average outcome, is that closer to the analytic solution we calculated? (Make sure you are *not* resetting the seed to 108 each time, or you will always get the same result.)

## Entropy: Introduction
A similar, and very popular concept, is the idea of entropy. Entropy is another measure of "probability of encounter", but in this case, it is when *all* species are equally likely to encounter each other. The most common way to measure entropy in ecological data is Shannon's Entropy, which is a specific case of the more general [Rényi Entropy](https://en.wikipedia.org/wiki/R%C3%A9nyi_entropy).

The basis of Shannon's entropy is the *bit*. Just like a computer bit, an information bit has a value of **TRUE** or **FALSE**. Shannon's Entropy asks how many bits does it take to find what species we have drawn from the pool.

![Huffman Coding](Lab5Figures/shannon.png)

It is very easy to do this manually when your genus pool can be expressed in base-2, but it gets a lot harder to manually draw out for other distributions. Luckily, there is a formula that we can use.

````R
# A simple formula for calculating Shannon's entropy
shannon = function(Taxa) {
	Frequencies = as.vector(table(Taxa))
	Probabilities = Frequencies/sum(Frequencies)
	Shannon = sum(Probabilities * log(1/Probabilities,2))
	return(Shannon)
	}

# Let's calculate Shannon's H for the pool in the above figure. Let's see if we also
# calculate Shannon's H as 2.
shannon(Pool)

# Let's try a more complex distribution of genera
Complex = c("Hebertella","Hebertella","Hebertella","Onniella","Onniella","Turritella","Abra","Favosites","Cladopora")
shannon(Complex)
````

You may have noticed that unlike Gini-Simpson and the Gini-Index, Shannon's H is "unbounded" in the sense that it does not always scale from 0 to 1 - instead, the maximum valude of Shannon's H will always be `log(richness,2)`. You can divide Shannon's H by `log(richness,2)` so that Entropy is expressed as a scale from 0 (no entropy) to 1 (maximum possible entropy). Rescaled Shannon's H is known as Pielous's Measure of Species Evenness or Pielou's J.

### Entropy: Questions
1. If you increase the size of the species pool - i.e., richness - will Shannon go up or go down?
2. If you increase the inequality/unevenness of the species pool - i.e., Gini Coefficient goes up - will Shannon go up or go down?
3. Try to manually calculate Shannon - i.e., by drawing branching diagram like the above figure - for a taxonomic pool with the following probabilities.

Genus | Probabilitiy
---- | ----
Hebertella | 0.5
Abra | 0.25
Favosites | 0.125
Chione | 0.125

4. Try checking your work with `vegan::diversity(x, "shannon")`. Uh-oh! Looks like you don't get the same answer as our shannon function. Take a look at the `help()` file for `vegan::diversity()`, can you guess why our calculations come out differently?

5. You may have noticed that Evenness, Entropy, and Probability of Encounter are extraordinarily similar. This is becuase they are all ultimately ways of asking about the shape of the frequency distributon. If the frequency distribution is flat - i.e., discrete uniform distribution - and all species are equally abundant then Gini = 0, Gini-Simpson ≈ 0, and Pielou = 1. If the frequency distribution consists of only one species - i.e., degenerate distribution - then Gini = 1, Gini-Simpson = 1, and Pielou = 0. However, just because the maximums and minimums are the same, does not mean that they are perfectly interchangable. Calculate the Gini, Gini-Simpson (Inverse), Shannon's H, and Pielou's J for each of the following distributions, and compare how they differ (or are the same).

````R
# Set the seed
set.seed(125)

# Short Uniform
ShortUniform = 1:10

# Long Uniform
LongUniform = 1:100

# Pseudo Half-Normal
Half = ceiling(abs(rnorm(30,mean=0,sd=10)))

# Lognormal Distribution
Lognormal = ceiling(rlnorm(30))

# Another lognormal distribution
Lognormal2 = ceiling(rlnorm(30))

# Exponential Distribution - third power
Exponential = ceiling(rexp(30,3)*10)
````

6. Last, let's try a practical example with real data from the end-Cretaceous mass extinction. Download a dataset of Maastrichtian (latest Cretaceous) Bivalves and a dataset of Danian (earliest Paleocene) Bivalves from the Paleobiology Database. Calculate the pre- and post- K/T boundary diversity in terms of Richness, Shannon's H, Pielous J, Gini, and Gini-Simpson. How did choosing different metrics of "biodiversity" shape how you viewed changes in genus diversity across this major extinction boundary?

## Hill Numbers: Introduction
The Hill Number paradigm essentially places all biodiversity indices - Richness, Shannon's H, Gini-Simpson, Berger-Parker Index - on a sliding scale from zero to infinity. When the scale is closer to 0 then the metric more closely reflects the influence of the size of a frequency distribution (richness). As the scale moves closer to infinity the metric more closely reflects the shape of the frequency distributions (evenness).

![HILLNUMBERFIGURE](Lab5Figures/hill.png)

````R
# The basic Hill-Number formula, where Frequencies is a frequency distribution
# q = 0, richness, q->1 is Shannon's H, q=2 is Gini Simpson, q=inf is Berger-Parker.
Proportions = Frequencies/sum(Frequencies)
HillGini = sum(Proportions^q)^(1/(1-q))
````

While Hill Numbers have some pretty interesting mathematical properties, and help us to put the competing influences of evenness and richness in better context, it doesn't actually solve any of the problems that come with trying to summarize all properties of a frequency distribution in a single number. Importantly, We still cannot tell, for any given metric, how much an increase or decrease in "diversity" was driven by changes in richness vs. evenness. This is an inherent difficulty of trying to summarize a non-isometric entity with only one number.

![ISOMETRY_FIGURE](Lab5Figures/rectangle.png)

## Hill Numbers: Questions
1. Consider the following five ecological communities. Without running any calculations, can you intuitively order them from least to most diverse?

````R
# 99 species with an abundance of 10, and one species with an abundance of 30
First = c(rep(10, times=99),30)
# 98 species with an abundance of 10, and two species with an abundance of 15 each
Second = c(rep(10,times=98),15,15)
# 97 species with an abundance of 10, and one species with an abundance of 11
Third = c(rep(10,times=97),11)
# 97 species with an abundance of 10, and three species with an abundance of 5
Fourth = c(rep(10,times=97),5,5,5)
# 100 species with an abundance of 10, and one species with an abundance of 50
Fifth = c(rep(10,times=100),50)
````

2. Calculate the Hill Number Diversity for each of the five distributions where q = 0, q = 0.99, q=2, q=3, q=5, q=10, q=100 and store the results.
3. Create a plot where the x-axis is q and the y-axis is the Hill number diversity. Add curves for each of the above five distributions to this plot. How does the diversity order compare with your original guess?

## Frequency Distributions II: Linear Models
Instead of applying a single summary statistics to our data, it is arguably preferable to simply provide a function that characterizes the frequency distribution. The benefit of a function is that you can derive any number of summary statistics from it. Unfortunately, there are *many* functions that roughly approximate the "hollow-curved" shape of ecological frequency distributions.

The art of regression is attempting to find the function that fits our data, in this case, the shape of our frequency distribution. Let's go back to one of the frequency distribution RADs that we plotted earlier and see if we can try and fit a few different curves.

````R
# Let's use some real data this time
Bryozoa = velociraptr::downloadPBDB(Taxa="Bryozoa",StartInterval="Bartonian",StopInterval="Priabonian")
# Clean out the subgenera and blanks
Bryozoa = cleanTaxonomy(Bryozoa,Taxonomy="genus")

# Create a frequency distribution of the genus occurrences with table(), and sort() it from most abundant to 
# least abundant.
Y = as.vector(sort(table(Bryozoa[,"genus"]),decreasing=TRUE))
X = 1:length(Y)

# Let's try a straight line y=ax+b
# Notice that you don't need to specify any constants or parameters
# You only need to specify  predictor terms (X) and the response (Y)
Line = lm(Y ~ X)

# Let's try a quadratic equation. Notice that you have to use the I( ) function.
Quadratic = lm(Y ~ X + I(X^2))

# Let's try a loglinear equation
Loglinear = lm(Y ~ log(X))

# And finally, let's plot them all up
plot(y=Y,x=X,xlab="order from most abundant to least abundant",ylab="genus frequency",las=1,pch=16,cex=1.5)

# We can use the fitted() function to get the predicted y values of each of our models, and visually
# analyze how they fit our original data
lines(y=fitted(Line),x=X,col="red",lwd=3)
lines(y=fitted(Quadratic),x=X,col="blue",lwd=3)
lines(y=fitted(Loglinear),x=X,col="darkgreen",lwd=3)

# We can also use the summary() function to get a report on the quality of our model fit
summary(Line)
summary(Quadratic)
summary(Loglinear)
````

![SUMMARYOUTPUT](Lab5Figures/summary.png)

You've likely noticed that all of our models are "significant" based on the p-values given in `summary()`. However, we can also easily tell that one model is substantially better than the others, just from the visual fit and also from the much better *R<sup>2</sup>* value. 

Nevertheless, none of the models looks particularly good. Let's try a power law model. Power law models are *extremely popular* in ecology, and are frequently proposed as one of the most common fits for RAD's and other hollow-curved distributions. The one thing we have to be careful of though is that a Power Law model is non-linear (i.e., it has more than one parameter per term), so we have to use the `nls()` function instead.

````R
# Perform a power law regression
# Notice that for nls() you need to give some guesses for good starting values
Power = nls(Y ~ b * X ^ Z,start=list(b=1,z=1))

# Add the power law line to the previous plot
lines(y=fitted(Power),x=X,col="darkorange",lwd=3)

# Check the model fit statistics with summary()
summary(Power)
````

We can see right away from the plot that it is a better fit visually, and we can also see from `summary()` that our parameters are statistically significant. However, you may have noticed that the output does not give us an R<sup>2</sup> value or any kind of equivalent. This is because R<sup>2</sup> is *only valid for linear models*. There is a family of so-called pseudo-R<sup>2</sup> measures that can be used for nonlinear models, but they are not very robust and it is best to avoid them if possible. Therefore, a better work around is to try and use algebra to make our non-linear model into linear model...

### Frequency Distributions II: Questions I
1. Try and re-express our power law function as a linear model, and run the regression again using `lm()`. (Hint: All you need is some clever use of `log()`). Is the result exactly the same as what you got with `nls()`?
2. Download a Bryozoan datasets for each [stage in the Paleogene](https://en.wikipedia.org/wiki/Paleogene). 
3. Calculate the Gini Coefficient, Pielou's J, Shannon's H, richness, and Gini-Simpson index for the genus frequency distribution of each dataset.
3. Fit a power law function to the RAD for each Paleogene stage using the linear model form.
4. Using `plot()`, `lm()`, `cor.test()` or other statistical methods, describe the qualitative relationship between the coefficient of your power-law function and Gini Coefficient, Pielou's J, richness, Shannon's H, and Gini-Simpson.

## Sampling Standardization: Introduction
Let us assume that now we have a sufficient understanding of many different definitions of diversity and have chosen one that we feel is appropriate for our hypothesis. The next step we have to check is whether our data is of sufficient quality for us to accurately estimate the diversity of the population. [As we discussed earlier](#richness-downside), the most common quality-control problem in *comparative diversity analysis* (i.e., comparing diversity among different samples) is variable sampling effort. As a general rule, the greater the effort, the greater the diversity.

This is usually best visualized with something called an Accumulation Curve or Collector's Curve. An accumulation curve is any curve where the X-axis is some measure of sampling effort (e.g., Area Sampled, Time spent sampling, number of workers) and where the Y-axis is the [*expected value*](https://en.wikipedia.org/wiki/Expected_value) of some measure of diversity (almost always richness) at that sampling intensity. A collector's curve (sometimes called a rarefaction curve) is a specific type of accumulation curve where the measure of effort (i.e., the x-axis) is the number of individuals encountered. 

![VEGANACCUMULATION](Lab5Figures/accumulation.png)

Accumulation curves are mostly useful because they illustrate that expected number of species added to your pool grows non-linearly per unit effort (area). This is important when attempted to standardize for effort, because you cannot simply standardize at a constant rate because *the slope changes depending where you are on the x-axis*. Therefore, seeing if your collector's curve has begun to level off (begun to show diminishing returns) is a good way to see how thoroughly you have sampled the population, and how much more effort you may need to put in. (Warning: what counts as leveled off is highly arbitrary... and we will see the consequences of this [later]())

## Sampling Standardization: Accumulation Curves
Let's try and build an accumulation curve that measures expected richness as a function of number of samples. Download a dataset of bivalve (clams) and gastropod (snails) fossils that range from the Eocene through Oligocene using the `downloadPBDB( )`. Next use the `cleanRank( )` and `constrainAges( )` function to clean up the data. These are simply pre-made functions that automatically clean up data errors, and fossil occurrences that have poor temporal constraint (i.e., are of unceratain age).

````R
# Download data from the Paleobiology Database
# This may take a couple of minutes.
ClamSnails = velociraptr::downloadPBDB(Taxa=c("Bivalvia","Gastropoda"),StartInterval="Eocene",StopInterval="Oligocene")
 
# Remove occurrences not properly resolved to the genus level.
ClamSnails = velociraptr::cleanTaxonomy(ClamSnails,"genus")

# Download a matrix of geologic epoch definitions and metadata
# A necessary step for the constrainAges( ) function
Epochs = velociraptr::downloadTime(Timescale="international epochs")

# Remove fossils with poorly constrained temporal resolution - i.e., the age uncertainty is greater than the epoch level.
ClamSnails = velociraptr::constrainAges(ClamSnails,Epochs)
````

Let's turn our newly downloaded and cleaned PBDB data into a community matrix. A community matrix is one of the most fundamental data formats in ecology. In such a matrix, the rows represent different samples, the columns represent different taxa, and the cell valuess represent the abundance of the species in that sample.

Here are a few things to remember about community matrices.

1. Samples are sometimes called sites or quadrats, but those are sub-discipline specific terms that should be avoided. Stick with samples because it is universally applicable.
2. By unspoken convention, the rows are always the samples/sites/quadrats and the columns are always the species/genera/taxa.
3. The columns do not have to be species per se. Columns could be other levels of the Linnean Hierarchy (e.g., genera, families) or some other ecological grouping (e.g., different habits, different morphologies).
4. Since there is no such thing as a negative abundance, there should be no negative data in a Community Matrix.
5. Sometimes we may not have abundance data, in which case we can substitute presence-absence data - i.e, is the taxon present or absent in the sample. This is usually represented with a 0 for absent and a 1 for present.

Let's convert our PBDB dataset into a community matrix using `abundanceMatrix()`. This function requires that you define which column will count as samples. For now, let's use `"collection_no"` (i.e., a paleobiology database sample) as as our sample.

````R
# Create a PBDB occurrences by taxa matrix
# This may take a couple of minutes
Community = velociraptr::abundanceMatrix(ClamSnails,Rows="collection_no",Columns="genus")

# In addition, let us clean up this new matrix and remove depauperate samples and rare taxa.
# We will set it so that a sample needs at least 24 reported taxa for us to consider it reliable,
# and each taxon must occur in at least 5 samples for us to keep it. These are common minimums for validating the
# sample size in a community matrix, though I've seen no quantitative proof that this is necessary or even beneficial.
Community = velociraptr::cullMatrix(Community,Rarity=5,Richness=24)
````

Now, we want to begin plotting our collector's curve. Remember that the x-axis is number of sampls, and y-axis the average diversity found in x-sample (i.e., the expected value). We can empirically derive this by *randomly* taking *n* samples and calculating the diversity of those samples. Let's try it now, and try to find the average expected richness if we took three samples at random.

````R
# Set a seed so that we get the same result
set.seed(888)

# Create a vector from 1 to 1,000, this is how many times we will repeat the resampling procedure
Repeat = seq_len(1000)

# Create a blank array to store our answers in.
Expected = array(NA,dim=length(Repeat))

# Use a for( ) loop to repeat the procedure
for (counter in Repeat) {
    # Randomly select 3 samples from the community matrix
    Draw = Community[sample(1:nrow(Community),3,replace=TRUE),]
    # Calculate the richness of all three samples
    Expected[counter] = length(unique(which(Draw>0,arr.ind=TRUE)[,"col"]))
    }

# Find the average expected number of samples for three samples
mean(Expected)
````

It's worth noting that it is not always advantageous to randomize the order of the samples, particularly if the order of your samples has some ecological or environmental meaning. For example, if you collect samples along an onshore-offshore or ubran-rural gradient.

### Sampling Standardization: Questions I
1. Create a function or script that will calculate an accumulation curve for the ClamSnails dataset. Make it into a plot.
2. Modify your script/workflow so that the measure of effort (x-axis) is the number of individuals sampled.
3. Modify your script/workflow so that the measure of effort (x-axis) is the number of references (`reference_no`). Make it into a plot.
4. Modify your script/workflow so that the measure of effort (x-axis) is the number of tectonic plates sampled (`geoplate`). Make it into a plot.
5. Contrast all your different accumulation curves, which measure of effort most rapidly "levels off"?
6. Verify that your accumulation curves were correct using `vegan::specaccum()` (Hint: Don't forget you can use `help()`)

## Sampling Standardization: Area Revisited
You will frequently see people refer to accumulation curves with area on the x-axis as an "Species-Area-Curve", "Species-Area-Effect", or "Species-Area-Relationship". While technically correct, the species-area-effect is most appropriately used in reference to a *specific* hypothesis in [Island Biogeography](https://en.wikipedia.org/wiki/The_Theory_of_Island_Biogeography) that islands accumulate species faster as the area of the island increases than equivalent area increases on the mainlaind. A species-area-effect can be *demonstrated* by contrasting the shape of mainland vs. island accumulation curves, but the curve itself is *not* the effect. This is important because this has led to the false impression that if there are two samples of unequal size, the larger sample will always have more species - this is *not* correct. Consider for example the plant diversity of 10 Hectares of Saharan desert versus 1 Hectare of the Malaysian rainforest.

That said, the area and richness relationship is probably the most theoretically important of all possible relationships you might want to illustrate with an accumulation curve. To that end, let's try and make some more area-richness plots.

````R
# Download a dataset of Silurian Anthozoans from the PBBD
Silurian = velociraptr::downloadPBDB("Anthozoa","Silurian","Silurian")[,c("genus","paleolng","paleolat")]
# Once again, let's clean up the taxonomy a bit
Silurian = velociraptr::cleanTaxonomy(Silurian,"genus")
# We can turn our dataframe into a "spatial" (GIS) object, this makes it friendlier for things like
# map projection and other geospatial analyses
Silurian = sf::st_as_sf(Silurian,coords=c("paleolng","paleolat"))
# Specify the coordinate system as WGS 84, which is the lat, lng you normally encounter
sf::st_crs(Silurian) = 4326

# Let's download a paleogeographic map of the Silurian
Map = velociraptr::downloadPaleogeography(Age=430)

# When plotting maps in base r, it is often best to set the margins, plot size, and aspect ratio in advance
Width <- Map@bbox[3] - Map@bbox[1]
Height <- Map@bbox[4] - Map@bbox[2]
Aspect <- Height / Width
quartz(width = 10, height = 10*Aspect)
par(mar = rep(0, 4), xaxs='i', yaxs='i')
# Plot the map of Silurian continent positions
plot(Map,col="darkgrey",lty=0)

# Lets add points to represent our coral occurrences to the map
plot(Silurian,add=TRUE,col="dodgerblue",pch=16)

# Let's overlay an equal-area grid on to this map
# This is actually a poorly made equal area grid, but let's ignore that for the moment
Grid = sf::st_read("https://macrostrat.org/api/v2/grids/longitude?latSpacing=5&cellArea=500000&format=geojson_bare")
plot(sf::st_cast(Grid,"MULTILINESTRING"),col="black",lwd=0.5,add=TRUE)
````

![SILURIANBRYOS](Lab5Figures/silurian.png)

````R
# Let's find which Silurian genera intersect with which grids
Intersects = which(sf::st_intersects(Silurian,Grid,sparse=FALSE),arr.ind=TRUE)

# Let's create a character matrix where the first column is the fossil occurence, and the second column is the grid it occurs in
GeneraGrids = cbind(genus=as.character(as.data.frame(Silurian)[Intersects[,"row"],"genus"]),grid=Intersects[,"col"])

# Let's turn it into a presence/absence matrix, where the columns are each a genus, the rows are an equal-area grid, and the cells are
# the number of individuals of that genus in that grid.
GeneraGrids = velociraptr::presenceMatrix(GeneraGrids,Rows="grid",Columns="genus")
# Then we will want to cull out grids where there are no genera found
GeneraGrids = velociraptr::cullMatrix(GeneraGrids,1,1)

# Finally, we can use the specaccum() function from the vegan package to calculate and plot our accumulation curve
plot(vegan::specaccum(GeneraGrids,"random"))
````

## Sampling Standardization: Subsampling
The same resampling principles used to generate accumulation curves can be leveraged to help "standardize" sampling effort between two or more compared ecological communities so that you can make comparisons about the diversity between the two. The basic theory here is to ask what if we randomly reduced (subsampled) each community down to the same amount of effort. In other words, what if we derive an accumulation curve for each community and a pick constant sample size (x-value) to calculate diversity?

![rarefaction](/Lab5Figures/rarefaction.png)

Using individuals as the measure of effort for subsampling procedures is by-and-far the most popular approach, but this brings us back to an old problem...

### Sampling Standardization: Questions II
1. Create accumulation curves (abundance based) for Furongian, Early Ordovician, Middle Ordovician, Late Ordovician, Silurian, and Early Devonian trilobite genus richness. Pick an appropriate standard sample size, and order each of these time-intervals from least to most diverse. Would a different sample size have changed your order?
2. Recreate the accumulation curves, but this time add 95% confidence intervals to the curves. Which intervals can be said to have statistically different trilobite richness?
3. Calculate the Gini coefficient for each of your time-intervals and compare that with your accumulation curves, is there any relationship between accumulation curve shape and Gini?

## Extrapolation: Introduction
Rather than subsampling all acumulation curves *down* to a uniform size, you might consider extrapolating all accumulation curve *out* to some uniform sample size. In other words, you might want to build a regression model that fits your accumulation curve, then predict the value for some larger sample size. This has been a dream among ecologists for a long time, but unfortunately it doesn't really work.

````R
# Let's download a dataset of Lower Miocene gastropods
LowerMiocene = velociraptr::downloadPBDB("gastropoda","Aquitanian","Burdigalian")
# Clean up that nasty genus column
LowerMiocene = velociraptr::cleanTaxonomy(LowerMiocene,"genus")

# Extrapolation test, create two versions of the dataset, one that includes all of the data, and one that includes only 75%
Smaller = LowerMiocene[1:ceiling(0.8*nrow(LowerMiocene)),]
All = LowerMiocene

# Turn each into a community matrix with abundance values
Smaller = velociraptr::abundanceMatrix(Smaller,"class","genus")
All = velociraptr::abundanceMatrix(All,"class","genus")

# Plot up the rarefation curve for all of the data
plot(y=vegan::rarefy(All,seq_len(ncol(All))),x=seq_len(ncol(All)),xlab="randomly sampled individuals",ylab="expected richness",col="darkblue",lwd=5,type="l",las=1)
# Plot up the rarefaction curve for the smaller dataset
lines(y=vegan::rarefy(Smaller,seq_len(ncol(Smaller))),x=seq_len(ncol(Smaller)),lwd=5,col="darkgreen")
# Plot up the "extrapolated" rarefaction of the smaller dataset
lines(y=vegan::rarefy(Smaller,seq_len(ncol(All))),x=seq_len(ncol(All)),lwd=2,col="darkgreen",lty=3)
````

### Extrapolation: Questions I
1. Revisit the same datasets of Paleozoic trilobites that you used in [Sampling Standardization: Questions II](#sampling-standardization-questions-ii), but this time create two plots. One plot where you've subsampled down to a common smaller sample size (Hint: use `rarefy()`), and one plot where you've extrapolated the accumulation curves out to a common larger sample size (Hint: use `rarefy()`). How does the relative diveristy among geologic intervals compare when calculated among these two methods.

## Extrapolation: Frequency Distributions
Although not truly "extrapolation" there are models for simulating frequency distributions. Let's go through some of the most common and how you can use them in R to generate a RAD based on a theoretical model.

### Uniform 
A discrete uniform distribution assumes that species are using resources independently of one another and to an equal degree. In other words, species are completely interchangable from an ecological/functional sense. Be warned that you should NOT use `runif()`, which is a continuous uniform distribution, not a discrete uniform distribution. ~~`Uniform = runif(5,1,5)`~~

![uniform](/Lab5Figures/uniform.png)

````R
# You can create a RAD from a discrete uniform distribution by using sample(),
Uniform = sample(1:5,replace=TRUE)
````

### Geometric Series
A geometric series assumes that each species arrives at regular time intevals and claims a constant proportion (k) of the total number of individuals in the community. Thus if k is 0.5 (e.g., think about half-life), the most common species would represent half of the individuals in the community (50%), the second most common species would represent half of the remaining half (25%), the third, half of the remaining quarter (12.5%) and so forth. This is good for modelling expected diversity relative to some limiting resource. Be warned that the `rgeom()` (random geometric) is a completely different geometric function and unrelated.

![geometric](/Lab5Figures/geometric.png)

````R
# The specific formula for a geometric series is kind of complicated, but you can easily approximate it for N taxa as 
# an exponential decay function, which is any exponential funciton y=k^i, where k is the propotion (0<k<1) and i the
# the species number. So for 5 species, the geometric distribution is. 
Geometric = k ^ (1:5)
````

### Broken Stick
A one dimensional resource axis is simultaneously and randomly partioned by N species. Notice that this is essentially a variation of the [discrete uniform distribution](#uniform). 

Broken stick refers to a very specific equation (as seen above), but you can create many "broken-stick variants" by altering the underlying probability distribution for the draws. Its flexibility and simplicity tends to make it very popular for modelling experiments, and it dovetails very nicely with single axis gradient analyses (see Ordination), but nobody seriously argues that it is actually how the real world works.

![broken](/Lab5Figures/broken.png)


````R
# Assuming we divide a population of 100 intervals into 12 species we would get the following abundances for species 1-10
Broken = (100/12)*cumsum(1/12:1)
````

### Fisher's Log Series
Logseries is a big deal, and is one of the most popular/studied/used models for explaining the frequency distribution of an ecological community. Unlike the other functions that we covered above, it does not give an estimated abundance for an individual species. Instead, it gives an estimate for how many species are expected to have a particular abundance. For example, how many species do we expect to have 10 individuals?

The theory behind this is that each species arrives at random time intervals and seizes control of a *constant* fraction of the remaining resources - similar in concept to the broken stick model.

Although there is no analytic solution for calculating x, it is almost always 0.9 < x < 1.

![logseries](/Lab5Figures/logseries.png)

````R
# You can use vegan::fisherfit to get a logseries estiamte for your data
help(vegan::fisherfit)

````

### Preston's Lognormal 
The lognormal function is also extremely popular in ecology, and fights over whether logseries or lognormal better describe empirical data are still somewhat common - though ultimately irrelevant, as we will discuss later.

The general theory behind this model is that the most rare taxa are usually unobserved, thus truncating the bell-curve predicted by the [central limit theorem](https://en.wikipedia.org/wiki/Central_limit_theorem) and making it appear to be a "hollow-curve". The prediction is that if we continued sampling until all species were observed, the distribution would indeed be (log)normal.

![lognormal](/Lab5Figures/lognormal.png)

````R
# You can use vegan::prestonfit to get a logseries estiamte for your data
help(vegan::prestonfit)


# You can also get random lognormal values using the build int rlnorm() function
help(rlnorm)
````

### Yule-Simpson Model
Sometimes called the Galton-Watson branching process, this model estimates the number of species based on the number of genera. This is essentially a model of evolution, more so than it is a model of RADS, but it does also predict a hollow-curve RAD, so can be used in that context. 

The assumptions of the Yule-Simpson model are as follows.
1. Always start with one genus.
2. Every time-step adds one new species.
3. A new species either founds a new genus with probability (g) or joins an existing genus with probability (1-g).
4. IF: a new species is NOT a new genus, it is assigned to an existing genus with a probability proporitional to the number of species already within that genus - i.e., more speciose genera are more likely to get additional species.

![YULE](/Lab5Figures/yule.png)

We've only covered a*small* portion of all hypothesized models for generating RADs. [Brian Mcgill](http://brian-mcgill-4.ums.maine.edu/sad_review.pdf) named at least 27 different models in his excellent review paper. The major reason why so many different models persist is because they all produce similar results (i.e., a hollow-curved shape of some kind), and it is impossible to go backwards from the outcome to mechanism when multiple mechanisms predict the same outcome. The issue of what dynamics (if any) generate RADs remains unsolved, and is possibly unsolvable. There is a good quote from Jeff Gore at MIT, "This is maybe one of those patterns in ecology that tells us more about math than biology." Indeed, a hollow-curved distribution is actually predicted in ecological data purely by the [Central Limit Theorem](https://projecteuclid.org/download/pdf_1/euclid.ss/1177009869), and is sometimes called the Significant-Digit Law, Benford's Law, or the Newcomb-Benford's law.

### Frequency Distributions III: Questions I
1. Qualitatively explain why the Yule-Simpson birth-process model will eventually converge on a power-law distribution after a large number of species are added?
2. Download a dataset of Jurassic dinosaurs and Cretaceous dinosaurs from the paleobiology database. Crate and plot family-level RADs for both the Jurassic and Cretaceous data.
3. Create a function or script that will iteratively solve for the Fisher's logseries *x* for the Jurassic and Cretaceous RADs.
4. Try fitting your Jurassic and Cretaceous RADS to any of the various models we have discussed thus far. Which models give the best fit? is it the same model for both the Jurassic and Cretaceous?

## Extrapolation: Richness II
Although using accumulation curves to extrapolate diversity [doesn't work](#extrapolation-introduction). There are other ways to extrapolate "missing" diversity. Many of these are built upon the same theoretical models for generating RADs taht we just discussed. 

### Fisher's Alpha
Fisher's Alpha is actually a parameter of the log-series equation we used earlier. Where `alpha = richness*(1-x)/x`. I won't say much about this other than that it has some interesting relationships to the Zero-Sum Multinomial distribution predicted by Hubell's Unified Neutral Theory. It is much less frequently used than other diversity metrics these days, though it will still crop up from time to time. One thing to watch out for from a theoretical standpoint is that you might want to at least check if the underlying Frequency Distribution is log-series before using this as a measure of diversity. You may also hear occasional outlandish claims that Fisher's Alpha is insensitive to unequal sampling, but that is not correct.

````R
# You can calculate Fisher's alpha through the vegan package
help(vegan::fisher.alpha)
````

### Chao Estimators
Another family of extrapolation methods is centred around the idea of "singletons" and "doubletons". A singleton is a taxon that is only observed once, and a doubleton is a taxon that is observed at least twice. The idea behind these estimator is that if a community is being sampled, and rare species (singletons) are still being discovered, then there are no more rare species to be found. If all species have been recovered at least twice, then there are likely no more rare species left. In other words, the Chao is basically just a weight proportion of singletons to doubletons.

![CHAO](/Lab5Figures/chao.png)

A few warnings: 

1. It is debatable whether the theoretical assumption that complete sampling would result in doubletons is justified in studies of the fossil record. A completely sampled area may still result in left-over singletons.
2. ~~Chao is strongly downwards biased and almost always underestimates diversity.~~ (This is often brought up as a drawback of the Chao family, but it is true of most, or even all, diversity metrics, so this complaint comes off as a bit of a cheap shot.)
3. There are quite a few variations of the Chao formula, and the appropriate one to use depends on certain properties of the data. I've only discussed the basic formula here.

````R
# You can use vegan::estimateR to get Chao extrapolated diversity estimate
# Vegan also supports other variants of Chao
help(vegan::estimateR)
````

### Capture-Mark-Recapture Approaches
Most of the metrics we have discussed are trying to get around the problem of unequal sampling effort among multiple samples. What if, however, we feel confident that we have fairly sampled among fossil localities? Even in these cases, the nature of the fossil record is such that we are *guaranteed* to miss some taxa that lived at that location, either because they were not preserved or because we simply did not find them. 

Capture-mark-recapture (CMR) methods attempt to address this issue probabilistically. Let's say that **Taxon X** is not found in **Location A**. We know that **Taxon X** occurs in similar, nearby fossil localities. What is the probability, then, that **Taxon X** did live at **Location A**, and we have simply failed to sample it due to random chance? (Note, you could theoretically do this in reverse and calculate the probability that observed taxa do not really belong in a locality (misidenitfied? transported?), but nobody seems interested in that.)

In order to do this, you need some measure of the relative probability of failed sampling. Luckily, this is relatively easy to calculate in the fossil record when dealing with temporal intervals thanks to the concept of a Lazarus taxon. We know, logically, that if a taxon is observed in an earlier interval and again in a later interval, then it had to have lived through all of the intervening intervals, regardless of whether we observed it or not. Therefore, the number of taxa known to range through an interval that are *not* observed in that interval gives us an estimate how poorly we are sampling that inteval. Let's try an calculate this as a hypothetical example.

Geologic Stage | *Gengar* | *Haunter* | *Ghastly* | *Alakazam* | *Kadabra* | *Abra* | *Geodude* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
Alola | 0 | 1 | 1 | 1 | 1 | 1 | 0 |
Johto | 1 | 1 | 0 | 1 | 0 | 0 | 0 |
Kanto | 1 | 1 | 1 | 0 | 0 | 1 | 1 |

In the above example, we see that *Ghastly* and *Abra* were not observed during the Johto stage; however, we see that these two taxa *are* observed during the preceding Kanto stage and succeeding Alola stage. Therefore, we *know* that these taxa must have been present during Johto - i.e., they are Lazarus taxa. We can use this information to calcualate an estimated detection probability where:

````R
# Taxa actually observed/sampled during the Johto interval
Johto = c("Gengar","Haunter","Alakazam")

# Taxa that occur in both the Alola to the Kanto stage
Crossers = c("Haunter","Ghastly","Abra")

# The number of Lazarus taxa (will always be equal to or a subset of Crossers)
Lazarus = c("Ghastly","Abra")

# Estimate the probability  of detection
Detection = 1 - (length(Lazarus)/length(Crossers))

# Use the probability of detection to estimate actual diversity
Richness = length(Johto)/Detection
````
There are actually many variations that you can do of CMR, and this is only the most basic example. 

### Extrapolation: Questions III
1. Download six datasets: Kungurian Brachiopods, Roadian Brachiopods, Wordian Brachiopods, Capitanian Brachiopods, Wuchapingian brachiopods, and Changhsingian brachiopods.
2. Would it be reasonable/appropriate to use Fisher's Alpha to measure Roadian brachipods biodiversity (genus-level)?
3. Use  `vegan::estimateR()` to get the Chao1 extrapolated diversity estimate for each stage and use rarefy to get estimated genus richness for a common number of sampled individuals. How does the relative change in diversity from interval to interval differ between these two methods?
4. Using all six datasets, identify the porportion of Lazarus taxa vs Observed taxa in the Roadian, Wordian, Capitanian, and Wuchiapingian datasets. Using this to determine probabilities of encounter, use capture-mark-recapture to estimate the "true" richness of each interval. How does this compare the results you got from previous estiamtes?
5. Given the information available, is there any way you can determine whether CMR, Rarefaction, or Chao is the most likely to give the "correct" change in relative diversity between intervals, or at least which one is the least likely to be correct?
6. Can you think of any weaknesses/flaws that might be arise from using Lazarus taxa to calculate detection probabilities?

## Temporal Dynamics: Introduction
Despite all the effort we have spent covering various ways to estimate standing diversity, paleobiologists are actually rarely concerned with the "true" diversity of a sample (how many species were actually alive at a particular point in time). Instead, we generally want robust estimates of *relative* changes in diversity among samples - e.g., was diversity in Sample A higher or lower than in Sample B? 

Some famous questions of this type are:
1. Has total global diversity remained relatively flat throughout the Phanerozoic, or has diversity gradually increased over time?
2. Was the diversity of Dinosaurs on a long-term decline on the way to the K/Pg boundary?
3. Was the diversity drop from the K/Pg or the P/T mass extinction larger?

Of course, it is difficult to make a fair comparison among geologic intervals if the sampling effort was unequal (as we've discussed at length). But, assuming that we're comfortable with our data, what are some different ways that we can look at temporal changes in diversity/extinction/origination?

## Temporal Dynamics: Cohort Analysis
One popular way to visually analyse temporal patterns of diversity is through a family of analyses known as cohort analysis (also, demographic analysis). A *cohort* is group of taxa that originate at the same time (or, more loosely, within the same time-interval). This can be thought of as analagous to how we use "generation" in colloquial speech - e.g., Gen X are a cohort, Millenials are a Cohort, etc. Similarly, a grduating high-school or college class could also be considered a cohort. A cohort *analysis* examines how the diversty/size of a cohort has changed through time. Importantly, a cohort can only ever shrink or stay the same through time, because new members will never be added. 

The simplest kind of cohort anlaysis is a *survivorship curve*. A survivorship curve plots the proportion of cohort remaining (relative to its original size) over time. It should be 100% at time 0 and then monotonically decrease until reaching zero (when no members of the cohort remain).

### Temporal Dynamics: Questions I
1. Using the Paleobiology Database, identify the cohort of Late Jurassic Dinosaur families (originated in the Oxfordian, Kimmeridgian, or Tithonian). Plot out the survivorship curve for this group until all members of the cohort are extinct. Use Stages for the time-scale.
2. Is the rate of decay best described as hollow-curved, piece-wise, or linear?
3. Repeat this process for  Early Cenozoic (Paleocene) mammals. Comparing the survivorship of Late Jurassic Dinosaurs and Early Cenozoic Mammals, can you infer anything about their respective evolutionary histories?

## Temporal Dynamics: Turnover Rates
Another way for us to analyze changes in diversity over time is by breaking it down into its constituent components of origination and extinction (we can ignore immigration and emigration since most paleobiology is conducted at a global scale) and how those change through time. This is an increasingly popular way of analyzing diversity, and is probably a more precise way of analyzing evolutionary dynamics if your research question has to do with extinction or origination, specifically.

There are, broadly speaking, three ways to calculate extinction and origination rates. A raw rate based on simply tabulating the number of observed taxa that go extinct over a certain period of time. This raw rate is sometimes divided by the total richness of that interval (per taxon extinction rate), but that is unnecessary for reasons we will see later. The second method utilizes the slope of survivorship curves (more on this later), and is probably the most common way to calculate extinciton rates in the paleobiology literature (though there has been quite a bit of noise in the past few years to move away from this). Last, there are various formulas for estimating extinction rates that go with the [Capture-Mark-Recapture](#capture-mark-recapture-approaches) approaches we discussed earlier.

![Boundary](/Lab5Figures/boundary.png)

Today, let's focus mostly on the second method that is derived from survivorship curves. You may (should) have noticed in the previous exercise that the survivorship curves you generated for both mammals and dinosaurs were "hollow-curved". This is not only extremely common, it has been argued (somewhat controversially) that it is an evolutionary ***law*** ([Van Valen's Law](https://www.mn.uio.no/cees/english/services/van-valen/evolutionary-theory/volume-1/vol-1-no-1-pages-1-30-l-van-valen-a-new-evolutionary-law.pdf)) that can be observed in the vast majority of clades. 

![Boundary](/Lab5Figures/vanvalen.png)

This is, again, not surprising given what we have discussed thus far about the prevalence of hollow-curves in ecology. However, what *is* surprising is it has been argued that not only do most curves exhibit a hollow-curved shape, but that they are, specificially, exponential decay functions. If true, then the *decay rate* or *slope* of the exponential decay function can be interpreted as the *extinction rate*. This is where the "Slope Extinction Rate" formula comes from, and is why, unlike the other two methods, it does not have a time component included. Time is a variable, not a parameter, in an exponential decay function. 

![Boundary](/Lab5Figures/survivorship.png)

Of course, this raises the question of whether survivorship cureves are truly exponential decay functions. As we saw when discussing RADs, there are *lots* of ways to generate approximately hollow-curved shapes.

### Temporal Dynamics: Questions II
1.  Go back to the Late Jurassic Dinosaur and Early Cenozoic mammals datasets from the [previous round of questions](#temporal-dynamics-question-i). Fit an exponential decay function to your surviviorshop curves. Are these strong fits? (Hint: remember `nls()` and `lm()`)

````R
Formations = read.csv("https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/Lab5Figures/sediment_boundaries.csv")
````

2.  I have created a matrix for you of Geologic Formations (rows) and time in 1-myr increments (columns). I have flagged each formations status during that interval with a 0 (not present), 1 (range-through, Cr), 2 (extinction, Cb), 3 (origination, Ct), and 4 (contained-within, Cw). Calculate the "slope extinction rate" (more properly the truncation rate, or unconformity rate in this context) of sedimentary units for each 1-myr increment of the Phanerozoic. (Hint: you may find `apply()` useful)
3. Make a plot with x-axis as time and y-axis as the sediment truncation rate. Visually, do peaks in truncation rate align with the big-5 mass extinction events?

![TRUNCATION](/Lab5Figures/truncation.png)
> Your plot should look like this... minus the fancy colors for the time-scale. Notice that time always runs from oldest to youngest

Perhaps the most interesting part of Van Valen's "Law" is that he argued it could be explained by an evolutionary-arms race - the so-called [Red Queen Hypothesis](https://en.wikipedia.org/wiki/Red_Queen_hypothesis). However, as we have discussed multiple times already, there are many different ways to generate a distribution, and it is very hard to infer process from a distribution. Is it possible that we could get log-linear/expoential decay survivorship curves from a strictly stochastic model like a Gaussian random walk?

````R
# Set a seed
set.seed(541)

# A variety of random walk models with an absorbing boundary (extinction)
# The default dispersal constant is calibrated to empirical data (unpublished)
absorbingWalk = function(Richness=1000,Duration=541,Boundary=0,Dispersal=3.65,Model="Gaussian") {
	FinalMatrix = matrix(NA,nrow=Richness,ncol=Duration,dimnames=list(seq_len(Richness),seq_len(Duration)))
	for (i in seq_len(Richness)) {
		# One of four different ways to determine the initial range size of each taxon
		InitialRange = switch(Model,
			"Gaussian"=abs(rnorm(1,sd=Dispersal)),
			"Uniform"=runif(1,1,3),
			"Degenerate"=1,
			"Galton"=abs(rlnorm(1,sdlog=log(Dispersal)))
			)
		# Generate taxon walk
		Walk = cumsum(c(InitialRange,rnorm(Duration-1,sd=Dispersal)))
		# Convert post-extinction values to NA if taxon goes extinct
		Extinct = which(Walk<=Boundary)[1]
		if (is.na(Extinct)!=TRUE) {
			Walk[Extinct:length(Walk)]<-NA
			}
		FinalMatrix[i,] = Walk
		}
	return(FinalMatrix)
	}


# Plot function for plotting the random walks Walk
plotWalk = function(Walk=RandomWalk,Height=300) {
	plot(y=Walk[1,],x=1:ncol(Walk),ylim=c(0,Height),xlim=c(0,541),type="n",ylab="geographic range size",xlab="time from initiation",yaxs="i",xaxs="i")
	for (i in 1:nrow(Walk)) {
		points(y=Walk[i,],x=1:ncol(Walk),type="l",col="grey",lwd=0.25)
		}
	}
````

4. Use the above `absorbingWalk()` function to generate a matrix where the rows are species, the columns are myr-increments, and the cell-values are geographic range size. Plot the walk using `plotWalk()`
5. Using `apply()`, `length()`, and `na.omit()`, calculate the duration of each genus (how long each genus lived from its time of origination).
6. Make a survivorship curve for this random-walk dataset. Make a linear, log-linear, and log-log version. Which is a better fit - linear, exponential, or power?

````R
set.seed(888)

# Let's try a "memoryless" stochastic model instead of a random walk
# In this model, there is a random probability that a taxon survives
# which is redrawn each time-step. Each taxon makes a "roll" against that
# probability. If it "fails" the roll, - i.e., rolls less than the
# number needed to survive, it goes extinct.
binaryStep = function(Richness=1000,Duration=541) {
    Lifespan = vector("numeric",length=Duration)
    for (i in seq_len(Richness)) {
        Survive = runif(Duration,0,1)
        Roll = runif(Duration,0,1)
        Lifespan[i] = which(Roll<Survive)[1]
        }
    return(Lifespan)
    }
````

7. Make a survivorship curve for this binary-step model. Make a linear, log-linear, and log-log version. Which is a better fit - linear, exponential, or power?
8. You may have noticed that the binaryStep model as parameterized tends to create *very* short durations, with an average 'species' lifespan of ~2 million years. This doesn't jive with the actual average lifespan for most species, which tends to be aroudn 5-10 myrs depending on the group. Download a dataset of Cenozoic Gastropods from the paleobiology database. Calculate the average duration of genera (Hint: `tapply()` or `velociraptr::ageRanges()` may be helpful here), invert it (1/x), and then take the logarithm of this value. Rewrite the binaryStep Model so that the probability of "survival" matches this value, and so that the model is generating the same number of genera as in the PBDB dataset. Compare your empirical distribuiton to your new model distributions, did parameterizing the model with the empirical value make your predicted longevities more reasonable?

## Spatial Dynamics: Introduction
The [species-area-effect](#sampling-standardization-area-revisited) is sometimes called the most fundamental pattern in ecology, or at least the most fundamental in spatial ecology. It could be argued, however, that the distance-decay relationship is probably even more fundamental. The distance-decay relationship states that geographically closer ecological communities will be more similar (share more species in similar abundances) than more distantly related ones, where distance can be measured environmentally or spatially.

Before we can calculate a full distance-decay relationship, we will need to have some basic measure of similarity or dissimilarity. More precisely, in a **similarity** index, zero indicates complete dissimilarity and 1 indicates complete similarity. In a **dissimilarity** or **distance** index, zero indicates complete similarity and 1 indicates complete dissimilarity. This distinction is pretty trivial because to move back and forth between similarity and dissimilarity only requires for you to subtract the index from 1 - just don't get confused which one you're using.

Just as we saw with the biodiversity metrics, there are a large number of metrics for measuring the similarity of ecological communities. We won't go into these nearly as in depth as we did for biodiversity, largely because there are *no* good ones and also becuase I'm exhausted.

### Jaccard Index
The Jaccard index is the simplest Similarity index. It is the intersection of two samples divided by the union of two samples. In other words, the number of genera shared between two samples, divided by the total number of (unique) genera in both samples. Or put even another way, it is the percentage of genera shared between two samples. 

````R
# Calculate jaccard coefficinet
calcJaccard<-function(First,Second) {
	Numerator = length(intersect(First,Second))
    Denominator = length(union(First,Second))
    Jaccard = Numerator/Denominator
	return(Jaccard)
	}

# A rarely used variant of jaccard is the Dice Index
# Which is just the Jaccard index, but instead of using the union
# of both collections, it uses the size of the smaller sample
# in other words it is askign what percentage of hte smaller
# sample is found in the larger.
calcDice = function(First,Second) {
	Numerator = length(intersect(First,Second))
    Denominator = (length(First),length(Second))
	Jaccard = Numerator/Denominator
    return(Jaccard)
	}
````

As you may have gleaned from my inclusion of the "dice index", the issue of unequal sample-size once again rears its ugly head. Unfortunately, similarity indexes are even *more* sensitive and distorted by unequal sample size than diversity metrics. There's really no good solution for this yet, but you could probably get reasonably far using some sort of resampling/subsampling procedure. If you're interested in a list of other metrics, check out the `vegan::vegdist()` function in the vegan package.

### Spatial Dynamics: Questions I
All right, let's try and make a demonstration distance-decay relationship. 

````R
# Download a dataset of the canonical marine taxa for the Pleistocene
CanonicalTaxa = c("Bivalvia","Gastropoda","Anthozoa","Bryozoa")
Pleistocene = velociraptr::downloadPBDB(CanonicalTaxa,"Pleistocene","Pleistocene")

# Run some basic cleaning
Pleistocene = velociraptr::cleanTaxonomy(Pleistocene,"genus")
Pleistocene = subset(Pleistocene,is.na(Pleistocene[,"paleolat"])!=TRUE)
# Find the richness of the PBDB collections
CollectionsSize = tapply(Pleistocene[,"genus"],Pleistocene[,"collection_no"],function(x) length(unique(x)))
# Limit the comparisons to only collections betwee 10 and 50 genera
Pleistocene = subset(Pleistocene,Pleistocene[,"collection_no"]%in%names(which(CollectionsSize>50)))

# A function for converting degrees to radians! You need this!!!
convertRadians = function(Degrees) {
	return(Degrees*pi/180)
	}

# Calculates the geodesic distance between two points specified by 
# radian Latitude/Longitude using the Haversine formula - r-bloggers.com
# The Haversine formula is a special case of the spherical law
# of cosines, which is a special case of the law of cosines.
calcHaversine = function(Long1,Lat1,Long2,Lat2) {
	Radius = 6371 # radius of the Earth (km)
	DeltaLong = (Long2 - Long1)
	DeltaLat = (Lat2 - Lat1)
	A = sin(DeltaLat/2)^2+cos(Lat1)*cos(Lat2)*sin(DeltaLong/2)^2
	C = 2*asin(min(1,sqrt(A)))
	Distance = Radius*C
	return(Distance) # Distance in km
	}
````

1. Calculate the similarity of each PBDB collection in `Pleistocene` to every other collection. Calculate the distance of every collection to every other collection using the `paleolng`, `paleolat` and the `calcHaversine()` function. Make a scatter plot of similarity vs. distance. (Hint: You MAY find the `combn()` function useful and the `by()` function useful, but there are many ways to code this. The key is to make one matrix of Jaccard similarity for collection_no by collection_no, and another matrix of Haversine distance for collection_no by collection_no, then to bind the two matrices together based on the collection_no by collection_no id pairs).
2. Using `lm()` determine if a linear, exponential, or power-law function is a better fit for your distance-decay relationship.

## Spatial Dynamics: Beta Diversity
The slope of the distance-decay relationship is commonly referred to as *beta* diversity or the *spatial turnover* of diversity. Importantly, this is **NOT** correct. Please, as a personal favour to me, never do this.

Beta diversity actually refers to a different way of predicting/describing the spatial relationship of diversity among sampled localities. This paradigm goes back to Robert Harding Whittaker (not to be confused with the Mixed martial artist of the same name). Whittaker introduced (among many others) who wanted to understand how the spatial hierarchy of sampling affects how we perceived diversity.

![ADPFIGURE](/Lab5Figures/zaffosfeser.png)

> The above figure shows a sampling hierarchy for a study I've been working on with my colleague Kelsey Arkle. If you think of the smallest unit of analysis as an individual sample (alpha<sub>1</sub>), then you can group your samples together to form some larger unit of analysis (alpha<sub>n</sub>). In this case, we have our individual samples (a<sub>1</sub>) as sediment cores. We collect three cores together in an onshore-offshore transect (a<sub>2</sub>) in the shallow subtidal zone. We collect three transects per locality around the island (a<sub>3</sub>), from three localities per island (a<sub>4</sub>) from three islands in the region (a<sub>5</sub>). By convention the largest spatial partition is usually referred to as ***gamma*** diversity - but we will use the alpha<sub>n</sub> notation here.

The relationship of a finer-scale in the hierarchy (alpha<sub>n</sub>) to a broader-scale (alpha<sub>n+1</sub>) is called (you guessed it) ***beta diversity***. There are *many* ways to calculate beta diversity, but the most common three are pictured below. In the first, known as the additive method, beta diversity is the *premium* or how much new diversity is expected to be added to the community if a new sample was collected. The other methods, known as multiplicative, express the relationship as a ratio - i.e., is the larger scale double the size of a smaller scale. Again, despite what the proponents of each would have you believe, neither metric is superior to the other on mathematical or conceptual grounds. It is a question of what you are interested in.

![ADPFIGURE](/Lab5Figures/adp.png)

One important mathematical caveat, however, that is important to know is that it is probably wrong, or at least are not useful, to use biodiversity measures other than richness when studying beta diversity. You will find many articles saying otherwise out in the literature. This stems back to a paper in the mid-90s that claimed you only needed metrics that obey *concavity* - i.e., increase if diversity increases. While it is true that concavity is *necessary* for beta diversity analysis, it is not *sufficient*.

### Questions II
1. Just to make sure you understand the hierarchy, explain how many samples (sediment cores) need to be collected in total according to the schema described in the above figure of the Caribbean?
2. Download a dataset of Late Ordovician and Early Silurian Brachiopods, Anthozoans, Gastropods, Bivalves, Bryozoans, Crinoids, and Trilobites.
3. Organize the data into 5°x5° paleongitude by paleolatitude bins. You can do this by rounding each paleolatitude and paleolongitude coordinate down to its nearest x/5 %% 0. Calculate the alpha, beta, and gamma diversity for each time-interval
using both additive and multiplicative approaches. What can you infer about the ecological/spatial effects of the the end-Ordovician extinction? (Hint: `round_5 = function(x) {floor(x/5)*5}`).
4. You can use the `geoplate` field to find the tectonic plate that an occurrence occurs within, use this to expand your spatial hierarchy to alpha<sub>1</sub> as 5°x5° cell, alpha<sub>2</sub> as geoplate, and alpha<sub>3</sub>/gamma as global. How does this change your ecological story about the end-Ordovician extinction?
5. Instead of calculating alpha, beta, and gamma, calculate the average Jacard coefficient among cells and the average Jaccard among tectonic plates. Does this match what you saw with beta diversity?

## Spatial Dynamics: Polar Ordination
Polar ordination is the simplest form of ordination, and was originally invented  at the University of Wisconsin in the late 50s. In polar ordination you define two "poles" of the gradient - i.e., the two samples that you think are the most dissimilar. You then order the samples into a gradient based on how similar they are to each "pole". 

The definition of the poles can be based on the calculation of a simlarity index (e.g., Jaccard) or could be two samples you hypothesize are at the ends of a gradient. Both approaches are fairly crude, so this method of ordination has largely been abandoned. As far as I know, there are no longer any working functions in R for calculating polar ordination.

#### Spatial Dynamics: Questions III

1) Create a subset of the `PresencePBDB` matrix which contains just the following rows - "Pliocene", "Oligocene", "Paleocene", "Early Cretaceous", "Late Jurassic", and "Middle Jurassic". Convert this into a presence-absence community matrix AND a separate abundance matrix (i.e., rows = times, columns = genera, cells = abundance or presence/absence).

2) Using `vegan::vegdist()` find the dissimilarities of all the epochs in relation to time. Use "jaccard" for your presence-absence matrix and "bray-curtis" for your abundance matrix. (Hint: `help(vegan::vegdist)`)

3) Find the two epochs that are the most dissimilar and make them the poles. Now, using the dissimilarities, order (ordinate) the remaining epochs based on their similarity to the poles. State the order of your inferred gradient.

4) Can you deduce what "variable" is controlling this gradient (e.g., temperature, water depth, geographic distance)? [Hint: Check the [geologic timescale](https://en.wikipedia.org/wiki/Geologic_time_scale#Table_of_geologic_time)].

5). There is a relatively high dissimilarity between the Early Cretaceous and Paleocene epochs. Can you hypothesize why this is? Google these epochs if you need to.

6) Was gradient order affected by 

## Spatial Dynamics: Correspondence Analysis
The next form of ordination is known as corresponence analysis, also known as reciprocal averaging. There are three primary varietys of correspondence analysis: correspondence analysis, detrended correspondence analysis, and canonical (constrained) correspondence analysis. 

Since we already explained the basics of reciprocal averaging in class, I will not go into further detail on the underlying theory behind correspondence analysis. Instead, let us examine the difference between correspondence analysis and detrended correspondence analysis. We will use the same presence-absence matrix you created in the previous [polar ordination](#spatial-dynamics-polar-ordination) section.

````R
# Run a correspondence analysis using the decorana( ) function of vegan
# ira = 1 tells it to run a basic correspondence analysis rather than detrended correspondence analysis
CorrespondenceAnalysis = vegan::decorana(CommunityMatrix,ira=1)

# Plot the inferred samples (sites).
# If you want to see the taxa, use display="species"
plot(CorrespondenceAnalysis,display="sites")
````

Your final product should look like this.

<a href="url"><img src="/Lab4Figures/Figure1.png" align="center" height="500" width="500" ></a>

You may also wish to make a more complex/detailed plot. R has a dizzying variety of plotting functions, but today we will only need two of the basic functions.

The first function is `plot( )`, which you have used earlier in this lab and elsewhere in the course. It is a very versatile and easy to use function because it has many **methods** attached to it. Putting the technical definition of a **method** aside, a method is a set of pre-programmed settings or templates, that will make a different type of plot depending on what kind of data you give the function.

````R
# Use methods plot to see all the different types of methods
# You don't interact with the methods, the basic plot( ) function does it for you.
methods(plot)
````

The **generic** version of plot (i.e, the version of plot that does not use any methods) produces a basic [scatter plot](http://www.statmethods.net/graphs/scatterplot.html) - i.e., points along an x and y axis. The ordination plots we used above are an example of a scatter plot. What if we want more customization than the basic `plot.decorana` method/template gives us?

````R
# Use the scores( ) function if you want to see/use the numerical values of the inferred gradient scores
# Note that by scores we mean gradient values - e.g., a temperature of 5 degrees or a depth of 10m
SpeciesScores<-scores(CorrespondenceAnalysis,display="species")

# This shows the weighted average of all species abundances along each inferred gradient axis.
# i.e., The weight-average of Amphiscapha is 5.22 along axis 1, and -3.799 along axis 2.
head(SpeciesScores)
                    RA1       RA2       RA3        RA4
Amphiscapha    5.221689 -3.799051 -2.998689 1.27944155
Donaldina      5.460634 -1.936823 -1.439545 0.77634443
Euphemites     5.472197 -2.781106 -2.433943 0.04989632
Glabrocingulum 4.270209 -3.789545 -1.794858 1.37530975
Palaeostylus   5.322415 -3.151507 -2.536464 0.60251234
Meekospira     5.322415 -3.151507 -2.536464 0.60251234

# You can also do this for sample ("sites") scores as well.
SampleScores<-scores(SpeciesScores,display="sites")

# Now that we know the [x,y] values of each point, we can plot them.
plot(x=SampleScores[,"RA1"],y=SampleScores[,"RA2"])
````

<a href="url"><img src="/Lab4Figures/Figure5.png" align="center" height="500" width="500" ></a>

It certainly works, but is a lot uglier than what the `plot.decorana` method came up with. Here are a few things that we can do to improve the plot.

````R
plot(x=SampleScores[,"RA1"],y=SampleScores[,"RA2"],pch=16,las=1,xlab="Gradient Axis 1",ylab="Gradient Axis 2",cex=2)
````

Plotting Arguments | Description
----- | -----
````pch=```` | Dictates the symbol used for the points - e.g., ````pch = 16```` gives a solid circle, ````pch = 15```` gives a solid square. Try out different numbers.
````cex=```` | Dictates the size of the points, the larger cex value the larger the points. Try out different values.
````xlab=```` | Dictates the x-axis label, takes a **character** string.
````ylab=```` | Dictates the y-axis label, takes a **character** string.
````las=```` | Rotates the y-axis or x-axis tick marks. Play around with it.
````col=```` | The col function sets the color of the points. This will take either a [hexcode](http://www.color-hex.com/) as a character string, ````col="#010101"```` or a [named color](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf) in R, ````col="red"````

There are a great many other arguments that can be given to the `plot( )` function, but we will discuss those as we need them.

Although this plot is prettier than what we had before, it would probably be better to have text names for the points, stating which point is which epoch (i.e., like in the ````plot.decorana```` method). To do this we can use the `text( )` function. Importantly, you cannot use `text( )` without making a `plot( )` first.

````R
# Create plot empty of points (but scaled to the data) by adding the type="n" argument.
plot(x=SampleScores[,"RA1"],y=SampleScores[,"RA2"],pch=16,las=1,xlab="Gradient Axis 1",ylab="Gradient Axis 2",type="n")

# The text( ) function takes [x,y] coordinates just like plot
# You also give it a labels= defintion, which states what text you want shown at those coordinates
# In this case, the rownames of the PostCambrianSamples matrix - i.e., the epoch names
text(x=SampleScores[,"RA1"],y=SampleScores[,"RA2"],labels=dimnames(SampleScores)[[1]])

# You can also give the text function many of the arguments that you give to plot( )
# Like cex= to increase the size or col= to change the color
text(x=SampleScores[,"RA1"],y=SampleScores[,"RA2"],labels=dimnames(SampleScores)[[1]],cex=1.5,col="dodgerblue3")
````

Coloring is a very powerful visual aid. We might want to subset the data into different groupings, and color those grouping differently to look for clusters in the ordination space. Let's try splitting the dataset into three parts: Cenozoic Epochs (1-66 mys ago), Mesozoic Epochs (66-252 mys), and the Paleozoic (252-541 mys), and plot each with a different color.

````R
# Create plot empty of points (but scaled to the data) by adding the type="n" argument.
plot(x=SampleScores[,"RA1"],y=SampleScores[,"RA2"],pch=16,las=1,xlab="Gradient Axis 1",ylab="Gradient Axis 2",type="n")

# Separate out the epochs
Cenozoic<-SampleScores[c("Pleistocene","Pliocene","Miocene","Oligocene","Eocene","Paleocene"),]
Mesozoic<-SampleScores[c("Late Cretaceous","Early Cretaceous","Late Jurassic","Early Jurassic","Late Triassic","Middle Triassic","Early Triassic"),]
Paleozoic<-SampleScores[c("Lopingian","Guadalupian","Cisuralian","Pennsylvanian","Mississippian","Late Devonian","Middle Devonian","Early Devonian","Pridoli","Ludlow","Wenlock","Llandovery","Late Ordovician","Middle Ordovician","Early Ordovician"),]

# Plot Cenozoic in gold
text(x=Cenozoic[,"RA1"],y=Cenozoic[,"RA2"],labels=dimnames(Cenozoic)[[1]],col="gold")
# Plot Mesozoic in blue
text(x=Mesozoic[,"RA1"],y=Mesozoic[,"RA2"],labels=dimnames(Mesozoic)[[1]],col="blue")
# Plot Paleozoic in dark green
text(x=Paleozoic[,"RA1"],y=Paleozoic[,"RA2"],labels=dimnames(Paleozoic)[[1]],col="darkgreen")
````

Your final output should look like this.

<a href="url"><img src="/Lab4Figures/Figure7.png" align="center" height="500" width="500" ></a>

There are a few things you should notice about the above graph. First, the first axis (i.e, the horizontal axis, the x-axis) of the ordination has ordered the samples in terms of their age. On the far right of the x-axis is the Ordovician (the oldest epoch) and on the far left is the Pleistocene (the youngest epoch). Therefore, we can infer that *time* is the primary gradient.

However, you may have also noticed two other patterns in the data. 

First, when the second axis (i.e., the vertical axis, the y-axis) is taken into account, an interesting **Arch** shape is apparent. This arch does not represent a true ecological phenomenon, per se, but is actually a mathematical artefact of the correspondence analysis method. Brocard et al. (2013) describe the formation of the arch thusly,

> Long environmental gradients often support a succession of species. [Since species tend to have unimodal distributions along gradients], a long gradient may encompass sites that, at both ends of the gradient, have no species in common; thus, their distance reaches a maximum value (or their simi-larity is 0). But if one looks at either side of the succession, contiguous sites continue to grow more different from each other. Therefore, instead of a linear trend, the gradient is represented on a pair of CA axes as an arch.

In other words, the Pleistocene and Early Ordovician have no species in common, thus they are on opposite ends of the first axis. However, they do share something in common, which is that they become progressively dissimilar from epochs further away from them. For this reason, the correspondence analysis plots them on the same end of the second axis, and the epochs that are at the midpoint between them (i.e., the Permo-Trissic boundary) on the other end of the second axis. This is not helpful information (in fact, it is just a geometrically warped restatement of the information conveyed in the first axis) and we want to eliminate it for something more useful.

The other thing you may have noticed is **compression** towards the ends of the gradient. Meaning that most of the Cenozoic epochs (i.e., Pleistocene, Pliocene, Miocene, Oligocene, and Eocene) are overlain closely on top of each other. So much so that you probably have a hard time reading their text. This is also an artefact of correspondence analysis, and not necessarily an indication that those epochs are more similar to each other, than say the (more legible) Early and Late Cretaceous epochs.

For these reasons, it is rare for people to still use correspondence analysis (reciprocal averaging). Though some scientists argue you should at least try correspondence analysis before turning to another technique (I am not one of them).

## Spatial Dynamics: Detrended Correspondence Analysis
The Arch effect and compression are both ameliorated by detrended correspondence analysis (DCA). DCA divides the first axis into a number of smaller segments. Within each segment it recalculates the second axis scores such that they have an average of zero.

You can perform a DCA in R using the `decorana( )` function of the `vegan` package.

````R
# Peform a DCA on the Post Cambrian Dataset
# ira = 0 is the default, so you do not need to put that part in.
DetrendedCorrespondence<-vegan::decorana(CommunityMatrix,ira=0)

# Plot the DCA
plot(DetrendedCorrespondence,display="sites")
````

Your final product should look like this.

<a href="url"><img src="/Lab4Figures/Figure2.png" align="center" height="500" width="500" ></a>

You will notice that the arch effect is gone! This is good, but the DCA is suffering from a new problem known as the **Wedge** effect. You can envision the wedge effect by taking a piece of paper and twisting it, such that axis 1 is preserved reasonably undistorted, but the second axis of variation is expressed on DCA axis 2 on one end and on DCA axis 3 at the opposite end. This produces a pattern consisting of a tapering of sample points in axis 1-2 space and an opposing wedge in axis 1-3 space.

Here, let's contrast our above DCA plot by plotting DCA Axis 1 and DCA Axis 3. Do you see another wedge running in the opposite direction?

````R
# Use the choices= argument to pick which ordination axes you want plotted.
plot(DetrendedCorrespondence,display="sites",choices=c(1,3))
````
<a href="url"><img src="/Lab4Figures/Figure3.png" align="center" height="500" width="500" ></a>

## Spatial Dynamics: Multi-dimensional Scaling

Because correspondence analysis suffers from the arch and detrended correspondence analysis can suffer from the wedge, many ecologists favour a completely different technique known as non-metric multi-dimensional scaling (NMDS). The underlying theory behind NMDS is quite different from correspondence analysis. If you want to learn more there is a good introduction by [Steven M. Holland](http://strata.uga.edu/software/pdf/mdsTutorial.pdf).

However, if you just want the highlights, here is what you need to know.

1. Most ordination methods result in a single unique solution. In contrast, NMDS is a brute force technique that iteratively seeks a solution via repeated trial and error, which means running the NMDS again will likely result in a somewhat different ordination.
2. This effect is, in particular, especially sensitive to your initila "guess" as to the configuration. A different starting point will often result in a different answer. 
3. NMDS, unlike correspondence analysis, is not based on weighted-averaging, but on the ecological distances (e.g., jaccard) of samples, similar to polar ordination.
4. The species scores presented by NMDS are just the weighted-average of the final NMDS sample scores - just as in Correspondence Analysis.

Here is how you run an NMDS in R using the `vegan` package.

````R
MultiScaling<-vegan::metaMDS(CommunityMatric)

# The plotting defaults for metaMDS output is not as good as for decorana( )
# We have to do some graphical fiddling.

# Create a blank plot by setting type= to "n" (for nothing)
plot(MultiScaling,display="sites",type="n")

# Use the text( ) function, to fill in our blank plot with the names of the samples
# Importantly, text( ) will not work if there is not already an open plot,
# hence why we needed to make the blank plot first. Notice that we did not define the coordinates for
# text( ). This is because by giving the text( ) function an NMDS output, 
# it knows to use the text.metaMDS method/template.
text(MultiScaling,display="sites")
````

Your final product should look like this.

<a href="url"><img src="/Lab4Figures/Figure4.png" align="center" height="500" width="500" ></a>

It's the Arch Effect again, just like in correspondence analysis!!! Despite the fact that many ecologists like to praise NMDS over CA and DCA, the differences between them are exaggerated. The reason for this is that all three are unreliable when there isn't a strong gradient to pick up in the first place.

In these data, there is a very strong "time" gradient that is picked up in the first axis of all four ordination (polar, corresondence, detrended, and multidimensional) techniques that we've used so far. However, there is no secondary gradient (or tertiary etc.) that is obvious in these data, hence why all of the methods make up these (ecologically) meaningless wedges and arches along the second, third, and so on axes.

Of the ordination methods covered here, I recommend sticking with DCA. It is fairly robust and easy to interpret, though *watch out for those wedges*!
