## Table of Contents
- [Configuring R Environment](#configure-r)
- [Richness: Introduction]()
  - [Richness: Questions I]()
  - [Richness: "Downside"]()
  - [Richness: Questions II]()
- [Frequency Distributions: Introduction]()
  - [Frequency Distributions: Questions I]()
  - [Frequency Distributions: Proper Visualization]()
  - [Frequency Distributions: Questions II]()
- [Evenness: Introduction]()
  - [Evenness: Questions]()
- [Probability of Encounter: Introduction]()
  - [Probability of Encounter: Questions]()
- [Entropy: Introduction]()
  - [Entropy: Questions]()
- [Hill Numbers: Introduction]()
  - [Hill Numbers: Magic Number?]()
- [Frequency Distributions II: Regression Models]()
  - [Frequency Distributions II: Questions I]()
- [Richness II: Nonlinearity]()
  - [Richness II: Questions I]()
  - [Richness II: Standardization]()
  - [Richness II: Standardization Questions]()
- [Extrapolation: Introduction]()
  - [Extrapolation: Richness]()
  - [Extrapolation: Frequency Distributions]()
- [Turnover Rates: Introduction]()
  - [Turnover Rates: Footeian]()
  - [Turnover Rates: Footeian Questions]()
- [Spatial Dynamics: Alpha, Beta, and Gamma]()
  - [Spatial Dynamics: Questions]()
- [Time Series: Introduction]()
  - [Time Series: Autocorrelation]()
  - [Time Series: Periodicity]()
  - [Time Series: Correlation]()
- [Birth-Death Model: Introduction]()
- [Trajectory of Phanerozoic Biodiversity]()

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

# Change the maximum timeout t0 300 second. This will allow you to download larger datafiles from 
# the paleobiology database.
options(timeout=300)

# Functions are camelCase. Variables and Data Structures are PascalCase
# Fields generally follow snake_case for better SQL compatibility
# Dependency functions are not embedded in master functions
# []-notation is used wherever possible, and $-notation is avoided.
# []-notation is slower, but more explicit and works for atomic vectors
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

5. You may have noticed that Evenness, Entropy, and Probability of Encounter are extraordinarily similar. This is becuase they are all ultimately ways of asking about the shape of the frequency distributon. If the frequency distribution is flat - i.e., discrete uniform distribution - and all species are equally abundant then Gini = 0, Gini-Simpson ≈ 0, and Pielou = 1. If the frequency distribution consists of only one species - i.e., degenerate distribution - then Gini = 1, Gini-Simpson = 1, and Pielou = 0.

However, just because the maximums and minimums are the same, does not mean that they are perfectly interchangable. Calculate the Gini, Gini-Simpson (Inverse), Shannon's H, and Pielou's J for each of the following distributions, and compare how they differ (or are the same).

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
Proportions = Frequencies/sum(Frequencies)
HillGini = sum(Proportions^q)^(1/(1-q))
````

While Hill Numbers have some pretty interesting mathematical properties, and help us to put the competing influences of evenness and richness in better context, it doesn't actually solve any of the problems that come with trying to summarize all properties of a frequency distribution in a single number. Importantly, We still cannot tell, for any given metric, how much an increase or decrease in "diversity" was driven by changes in richness vs. evenness. This is an inherent difficulty of trying to summarize a non-isometric entity with only one number.

![ISOMETRY_FIGURE](Lab5Figures/rectangle.png)

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
1. Try and rexpress our power law function as a linear model, and run the regression again using `lm()`. (Hint: All you need is some clever use of `log()`). Is the result exactly the same as what you got with `nls()`?
2. Download 10 Bryozoan datasets from PBDB for any 10 geologic stages of your choice. Calculate the Gini Coefficient, Shannon's H, and Gini-Simpson index for each.
3. Fit a power law function to your RAD for each of your 10 intervals using the linear model form.
4. Relate the coefficient from your power regressions to the diversity metrics you calculated.

## Richness II: Nonlinearity
