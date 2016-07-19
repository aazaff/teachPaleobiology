## Natural language processing (NLP), PaleoDeepDive, and “dark data”

This lab was conceived and composed by Dr. Valerie Syverson.

###Part 1: Introduction to NLP

Go to http://nlp.stanford.edu:8080/corenlp/process. This site runs the natural language analysis program CoreNLP on any text you enter into the box and gives you visually tagged output. Enter any sentence you like and look at the result.

What is CoreNLP doing with your sample sentence?
+Part-of-speech tagging: assigning parts of speech to each word (noun, verb, etc.)
+Named entity recognition: noticing particular entities that are referred to multiple times
+Coreference (don’t worry about this)
+Dependencies: figuring out the grammatical relationships between words

###Part 2: PaleoDeepDive

####Step 1
Download the test data set (````pyritized.csv````) from the course page on github and load it into R:
````R
pyr<-read.csv("https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/Lab14Files/pyritized.csv")
````
Look at the first few rows to get a sense of what the columns contain:
````R
colnames(pyr)
head(pyr)
````
The first three columns contain numbers identifying the document, sentence, and each word in the sentence, which combined constitute a unique identifier for each word in the database.
The fourth column contains the actual sentence, bracketed by { } and with spaces converted to commas. You’ll notice the strings “-LRB-” and “-RRB-”, which stand for “left round bracket” and “right round bracket” -- i.e. open and close parentheses.

Most of the rest should be familiar from the previous exercise: ````poses```` are parts of speech, ````ners```` are named entities ("O" denoting a word not recognised as an entity), and ````dep_paths```` and ````dep_parents```` give the type of grammatical dependency and the ID of the word on which it depends. The only unfamiliar one is ````lemmas````, which is the NLP program’s best shot at finding the simplest form of each word -- i.e. taking nouns to singular, verbs to infinitive, and a few other transformations.

Next we’ll try to extract information from this. This is a small subset of the PaleoDeepDive corpus, consisting of about 1300 sentences containing one of a few keywords having to do with pyritization, plus the three sentences from those documents that occur before and after the one with the keyword, which comes out to about 9300 sentences. Take a look at the set of sentences from the third paper in the data set, which is pretty representative:
````R
pyr[which(pyr[,"docid"]==unique(pyr[,"docid"])[3]),4]
````
The question we’re going to try to answer is this: What taxa are most frequently found as pyritized fossils?
####Step 3
Download the taxon list (````taxa.csv````) for the assignment and load that as well:
````R
taxa<-read.csv("https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/Lab14Files/taxa.csv")
````
This is a list of all the taxa at family level or higher in the PBDB (data service call URL: https://paleobiodb.org/data1.2/taxa/list.csv?datainfo&rowcount&base_name=Metazoa&rank=min_family). I've trimmed down the list of columns and removed the header. We’re going to look for the list of which taxon names most frequently occur within three sentences of the words having to do with pyritization. To do this, we'll be using ````grep( )````, which looks for matches to a regular expression within a string and prints the matching row numbers.
This function, ````count_uses( )````, takes a list of taxon names, cuts a certain number of letters off the end (useful for recognizing that "ammonites" and "Ammonoidea" are the same thing, for instance). Run the following code snippet in your R window to define the function:
````R
count_uses<-function (taxon_list, clip, sentences){
    # arguments: vector of taxa, nlp sentences table, amount to truncate end of taxon names
    result<-array(dim=c(length(taxon_list),2))
    for (i in 1:length(taxon_list)) {
       teststr<-as.character(taxon_list[i]) #deals with weird type issues
      result[i,1]<-substr(teststr,1,nchar(teststr)-clip) #trims off as many characters as specified and puts it into the table
       dummy<-grep(result[i,1],sentences[,"words"],ignore.case=TRUE) #searches all sentences in the table for the resulting string
       result[i,2]<-length(dummy) #puts the number of matches into the table
    }
    return(data.frame(string=result[,1],matches=as.numeric(result[,2])))
}
````
####Step 4
Try running this function with taxon list ````taxa```` and sentences table ````pyr````, while varying the number of letters removed from the ends of the taxon names. 
````
counts<-count_uses(taxa[,"taxon_name"],0,pyr) #change the 0 to whatever you like
counts[order(-counts[,"matches"]),] #sort into descending order of frequency
````
Caution: the first of these commands may take a LONG time to run -- it's matching 15,000+ strings against 9300+ sentences! Take a potty break or read about regular expressions or something.

##Problem Set 1:
+Which taxon names appear most often? Print the top 20 taxa.
+What are the commonly used or colloquial names for these 20 taxa, if any? (Look them up online if you need to.)
+Which of these are probably not good data? Why? 
+Conversely, which taxa are likely candidates for pyritization, and why?

####Step 5
The taxon names in ````taxa.csv```` are very formal, even when we throw out the last few letters to account for Anglicizations and abbreviations of the Linnaean names. If you look through the sentences from the different documents using ````pyr[which(pyr[,"docid"]==unique(pyr[,"docid"])[n]),4]```` (replace n by various integers to look at the different documents), you'll notice that the authors don't always use formal names: they'll say "coral" rather than "Anthozoa", "worm" instead of "Annelida", etc. Try making your own list of possible names to search (for an example of what I mean, see my list at [vjps_taxa.csv](https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/Lab14Files/vjps_taxa.txt)) and importing it as ````my_taxa````. Then use ````count_uses()```` with your taxon list and ````pyr```` to see what kind of results you get with informal names:
````R
my_counts<-count_uses(my_taxa[,"taxon_name"],0,pyr)
my_counts[order(-my_counts[,"matches"]),]
````
##Problem Set 2:
+ Print your list. Explain why you chose the string you did.
+ How does this compare to the results from the list of truncated formal names? In other words, would you trust the truncated formal names or your custom list of informal names more?
