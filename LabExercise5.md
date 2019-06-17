# Ecological Informatics
There are many different metrics and definitions for "biodiversity" that have been proposed. All are equally "valid", but are almost always not interchangable.

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

# Change the maximum timeout ot 300 second. This will allow you to download larger datafiles from 
# the paleobiology database.
options(timeout=300)
````

## Richness: Introduction
The simplest and most common biodiveristy metric is *richness*. Richness is applicable to any categorical dataset, and is simply the total number of categories. Let's begin by downloading a dataset of all Pleistocene mammal genera in the Paleobiology Database.

````R
# Download all representatives of mammalia that are withint he Pleistocnee boundary
Mammals = velociraptr::downloadPBDB(Taxa="Mammalia",StartInterval="Pleistocene",StopInterval="Pleistocene")
````

Take some time to examine this dataset. It is always worth taking time to familiarize yourself with a dataset *before* you commit
to an analysis. Here are some functions that you may find useful for quickly perusing the data: `head()`, `dim()`, `table()`, `subset()`, and `unique()`. Remember, you can always learn more about a particular funciton by using `help()` or `?`.

### Richness: Introduction Questions
1. How many fossil occurrences are in this dataset? 
2. How many paleobiology database collections are in this dataset?
3. What is the species richness, genus richnss, and family richness of this dataset?
4. What is the species richness of the family Vespertilionidae?
5. Which family has the highest genus richness? - hint: look at the function `tapply()`
6. Closely inspect the text values in the family, genus, and accepted_name fields. Can you see any problems with the quality of these data?

## Richness: Downside
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

**We will revisit this problem and discuss some solution in a later exercise.**

### Richness: Downside Questions

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

### Frequency Distribution: Introduction Questions
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

### Frequency Distribution: Proper Visualization Questions
1. The Lorenz curve was actually borrowed from the field of economics, where it is usually used to describe income inequality. If you've ever heard someone talk about how the X% holds Y% of the wealth, those statistics ultimately come from a Lorenz curve. Create your own fictional dataset of 100 species where the top 20% of species have 80% of the total sample population.
2. Plot out your fictional dataset as a RAD and as a Lorenz curve.
3. Create a perfectly equitable distribution of 100 species (discrete uniform), where every species has the same abundance. Plot it as a RAD and a Lorenz curve.

## Frequency Distributions: Evenness Introduction
It would be extremely convenient if the information contained in frequency distributions could be distilled into a single summary number. However, just like trying to describe any other distribution with a summary statistic - e.g., mean, median, variance - you need to determine what *aspect* of the distribution you are really trying to understand.

In biodiversity sciences, many workers are especially concerned with the idea of *Evenness*, what would be called *Inequality* in other disciplines. An ecological example of a perfectly *even* community is one where all species have the same frequencies/abundance/population size, and a perfectly *uneven* community is one where all species are rare except one. Many workers equate the idea of evenness/inequality rather than richness, with biodiversity. We will discuss why this is in the next session.

The most common index used to characterize Evenness/Inequality is the Gini Coefficient or Gini Index (not to be confused with the Gini-Simpson Index), which is derived from the Lorenz Curve.

-- Add figure of GINI calculation

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

Another popular measurement of evenness is [Pielous's Measure of Species Evenness](https://www.sciencedirect.com/science/article/pii/0022519366900130) or Pielou's J, but that metric is intimately tied to the concept of *entropy*, which we will discuss later.

### Frequency Distributions: Evenness Questions
1. Download a datset of Priabonian Bivalves from the Paleobiology Database and calculate the genus-level Gini.
2. The Gini coefficient was originally designed by economists to study income inequality. Can you see a difference between income and species abundance that might affect the calculation of Gini?

## Frequency Distribution: Encounter Introduction
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
## Frequency Distribution: Entounter Questions
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

## Frequency Distribution: Entropy Introduction
A similar, and very popular concept, is the idea of entropy. Entropy is another measure of "probability of encounter", but in this case, it is when *all* species are equally likely to encounter each other. The most common way to measure entropy is Shannon's Entropy, which is a specific case of the more general [Rényi Entropy](https://en.wikipedia.org/wiki/R%C3%A9nyi_entropy).

The basis of Shannon's entropy is the *bit*. Just like a computer bit, an information bit has a value of **TRUE** or **FALSE**. Shannon's Entropy asks how many bits does it take to find what species we have drawn from the pool.

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

### Frequency Distribution: Entropy Questions
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

## Diversity Summary: Practical Examples
As you may have noticed, all of the different "diversity" metrics that we have discussed today [*richness*](), [*gini coefficinet*](), [*gini-simpson*], and [*shannons H*]() are mathematically related, despite the fact that each metric is asking *very* different questions. This is because the unifying factor is that the frequency distribution will always govern [richness](), 