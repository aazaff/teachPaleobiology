# Lab Exercise 1

## Instructions

Lab exercise 1 is broken into two components. The first part is an introduction to the Paleobiology Database Website. The second part is an introduction to the R computer language. The R tutorials and associated exercises are kept in a separate repository named [startLearn.R](https://github.com/aazaff/startLearn.R/blob/master/README.md).

You will be able to complete the first part during lab period, but will likely have to finish the second part as homework. Both components are due at the start of the next lab period: **Wednesday January 27th**. 

## Finding the Paleobiology Database Website

The URL for the Paleobiology Database is [www.paleobiodb.org](https://paleobiodb.org). However, because you are all honorary members of the development team, you can also use the special development server at [www.training.paleobiodb.org](https://training.paleobiodb.org).  Go there now in your web browser. The first thing that you should see is the **SPLASH** page. 

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure1.png" align="center" height="450" width="500" ></a>

The Paleobiology Database (**PBDB** for short) splash page has a lot of information packed into it. At the bottom of the screen you will see some basic stats on the types and quantity of data located in the database.

Data Type | Definition
--------- | ----------
**References** | Scientific articles, books, monographs, or other sources of data.
**Taxa** | A taxon (plural taxa) is a group of one or more populations of an organism or organisms seen by taxonomists to form a unit. 
**Opinions** | Different opinions on the correct taxonomic name/identification of different fossil taxa.
**Collections** | A group (collection) of fossil taxa at a specific location.
**Occurrences** | An individual observation of a taxon at a specific location.
**Scientists** | The number of scientists that are *officially* involved in the Paleobiology Database initiative.

## References

All data in the PBDB can ultimatley be traced back to one or more references. The interface for searching and viewing references is currently being overhauled this semester, which is why there is no search button on the splash page. You can still access the old references search feature by clicking [here](https://training.paleobiodb.org/cgi-bin/bridge.pl?a=displaySearchRefs&type=view).

The references search page should look something like this.
<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure2.png" align="center" height="450" width="500" ></a>

#### Exercise Questions 1

Let's take a look at a great scientific paper by Steven M. Holland and Mark E. Patzkowsky. 

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure3.png" align="center" height="450" width="500" ></a>

Use the reference search tool to look up collections associated with this paper and answer the following questions.

1. How many collections are associated with this references?

2. What is the reference id number for the article? 

Once you have answered the above questions, click the **view collections** hyperlink to see a print out of the collections associated with the study.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure4.png" align="center" height="450" width="500" ></a>

Click on collection no. **72438**. Answer the following questions about this collection.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure5.png" align="center" height="450" width="500" ></a>

1. The first taxon in the taxonomic list is *Rafinesquina alternata*. Next to the taxonomic name is the citation (Conrad 1830), what is the significance of this citation?

2. What is the *class*, *order*, *family*, *genus*, and *species* name of the second taxon in the taxonomic list?

3. In what County was the data collected?

4. What age (Period) is the data from?

5. What is the geologic formation where the data was found?

## Collections

Collections are useful for getting contextual information about the age, location, and geologic context of collected fossils. They are, however, generally a poor tool for data analysis. This is because there is no standard operational definition of a collection in the Paleobiology Database.

For example, collection **72438** from the above example represents a single sample from the study by Holland and Patzkowsky. In that study, a sample represents a single *bedding plane* (i.e., the top of a single rock layer) between 100 cm<sup>2</sup> and 1600 cm<sup>2</sup> in size.

In contrast, collection **91240** represents a single sample in a study by Ivany et al. 2009, Ref# 30540. In that study, a sample was defined as an entire rock outcrop (multiple beds), generally several square meters in extent. 

If you blindly compared these two collections, you would be making an apples and orange comparison.

## Occurrences

Occurrences are the number of collections that contain a taxon. Since the size and definition of collections is variable, the meaning of occurrences is also somewhat imprecise. 

Therefore, as we progress in this class, you will see that often times the first step of any data analysis project using the PBDB is to reorganize occurrences into a more sensible and standardized format. We will discuss occurrences more when discussing how to download data.

#### Exercise Questions 2

Return to the **SPLASH** page, and enter the PBDB [navigator](https://paleobiodb.org/navigator/) tool. This tool is the best way to visualize the age and location of collections in the PBDB.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure6.png" align="center" height="450" width="500" ></a>

Look at the search bar prompt in the top right corner. Navigator will allow you to enter a geologic time period, a taxon, an authorizer, or a geologic unit. Let's look for the genus *Abra*.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure7.png" align="center" height="450" width="500" ></a>

1. Zoom in so that you can see from Texas to Florida and from Florida to New York. Some of the occurrences are oranges and others are yellow, what is the significance of the different colors?

2. Zoom back out. Add an additional filter into the searchbar, the Ypresian stage. In what countries are there Ypresian occurrences of *Abra*?

3. Clear the *Abra* and Ypresian filters from the search. Look for the genus *Ambonychia*. Within the United States find the city with the most occurrences of *Ambonychia*. What is the name of this city? 

4. What age (Period) are most *Ambonychia* occurrences?

Add in your answer to question 4 as an additional filter. Click on the little icon of South America breaking away from Africa on the left side of the screen. This icon rotates the continents back to their position in the specified time-period. Note that it requires you to have set a specific time-period as a filter. 

5. During this time-period, were most occurrences of *Ambonychia* arrayed parallel or perpendicular to the equator?

6. Click on the little insect icon on the left side of the screen. This brings up taxonomic information on the target taxon. What order does *Ambonychia* belong to?

## Downloading Data

You can the data displayed in your Navigator window using the little arrow icon on the left side of the screen, but its options are limited. 

Use the new and more detailed download form instead. Return to the **SPLASH** page and click on [Download Data](https://paleobiodb.org/cgi-bin/bridge.pl?a=displayDownloadGenerator). This download form uses the new Paleobiology Database **API**. Once you are more advanced, you will be able to donwnload data directly into R using the **API**, and will no longer need to use Navigator or the download form.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure8.png" align="center" height="450" width="500" ></a>

Let's try downloading all collections of both *Ambonychia* and *Abra* as a tab-separated file. 

1. Select Collections
2. Select Tab-separated values (tsv)
3. Enter Abra, Ambonychia into the Taxon textbar.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab1Figures/Figure9.png" align="center" height="450" width="500" ></a>

If you were successful you should have gotten a blue URL, describing your data request.

https://paleobiodb.org/data1.2/colls/list.tsv?datainfo&rowcount&base_name=Abra,Ambonychia

#### Exercise Questions 3

For the following questions generate the appropriate URL for the following data queries.

1. What is the appropriate URL for downloading all occurrences of Ambonychia in the Lexington Limestone as a JSON?

2. What is the appropriate URL for downloading all occurrences of mammals present in the Paleocene through Oligocene epochs as a csv?

3. What is the appropriate URL for downloading all opinions on the order Testudines in the Mesozoic?

4. What is the appropriate URL for downloading all collections of Aves, Marsupialia, and Sirenia in the United States as a csv?

5. What is the approopriate URL for downloading all occurrences of the gastropod genus, *Ficus* as a csv?

#### Exercise Questions 4

The next set of questions is free form, in that you can find the answer to the following questions using any of the PBDB tools discussed so far.

1. What family does the genus *Gastrocopta* belong to?

2. There is only once occurrence of *Isoetes* in Portugal. What age is it?

3. What is the age of the oldest occurrence of *Gastrocopta*?

4. There is only one occurrence of *Tiktaalik* in the Paleobiology Database? Was that occurrence located in the tropics or the extratropics when it was alive?

5. There are two occurrences of *Namacalathus* in Sibera. What geologic formations are they found in?
