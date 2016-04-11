# Lab 11: Triassic and Jurassic Macrostratigraphy

The Early Triassic fossil record is very sparse, which is generally interpreted as evidence of a prolonged and weak recovery following the end-Permian mass extinction. For example, there is a prolonged absence of coral reefs and coal deposits across the globe for approximately 10 million years (Induan - Anisian).

Although faunas are generally considered to have "recovered" by the middle Triassic, diversity remained comparatively low for much of the rest of the Triassic and well into the Middle Jurassic.

![Range-Through Richness](https://github.com/aazaff/teachPaleobiology/raw/master/Lab11Figures/Fig1.png)
> Range-through marine generic richness

An alternative hypothesis is that the observed lows in biodiveristy from the Early Triassic through Middle Jurassic are actually a consequence of poor preservation. Specifically, low volumes of preserved sedimentary rock available for paleontologists to sample during this interval. Today we will explore this possibility using data from the Earliest Triassic in the [Macrostrat](https://macrostrat.org) and [Paleobiology](https://paleobiodb.org) Databases.

## Part 1

We are going to download some data from the Macrostrat database and make some basic maps of Triassic rock units in North America. We will do this by using the Macrostrat API, similar to how we used the Paleobiology Database API in [Lab 3](https://github.com/aazaff/teachPaleobiology/blob/master/LabExercise3.md#paleobiology-database-api). You can review that previous lab for a basic overview of API concepts.

#### Step 1
Load in the beta version of the [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R/blob/master/README.md#paleobiologydatabaser) package's [communityMatrix.R](https://github.com/aazaff/paleobiologyDatabase.R/blob/master/README.md#communitymatrixr) module.

````R
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/communityMatrix.R")
````

#### Step 2
Go to the Macrostrat API page at https://macrostrat.org/api. If you are using chrome, you may find it hepful to install the free Chrome extension [JSONView](https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc?hl=en). If you are not using Chrome, you should rethink your life choices.

You should see a list of API routes available for you to investigate.

![Macrostrat API Home Page](https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/Lab11Figures/Fig2.png)
> A list of Macrostrat API routes

#### Step 3
Although there are quite a few macrostrat routes available, there are only three routes that are going to be relevant to you today. The following is a review of those three routes. Review each route type before moving further.

##### /units 
This route will allow you to search for different rock units based on certain search criteria. 

Units are the foundation of Macrostrat, equivalent to the idea of a fossil occurrence in the Paleobiology Database. Units may be classified at any level of the lithostratigraphic hierarchy - members, formations, groups, or supergroups. 

Many units have additional attributes attached to them, such as their age, geographic location, and lithologic attributes (e.g., igneous/metamorphic/sedimentary or terrestrial/marine) 

You can therefore search for all units matching some attribute by using the this route. For example, you can search for all Silurian Units using the following API query: https://macrostrat.org/api/units?interval_name=Silurian

##### /columns 
This route will alow you to search for different macrostrat columns based on certain serach criteria.

The overarching unit of organization in Macrostrat is the column, analagous to collections in the Paleobiology Database. Columns are essentially a geographic summary of a set of units at a geographic location.

You can think of columns as analagous to the boundaries of states. Just as states have no pre-defined size, shape, or population, columns do not not have a fixed size, shape, or number of constituent units. They are simply an *arbitrary* set of polygons used to divide up the Earth and broadly group units by geographic location. We primarily use columns for organizational or plotting purposes (making maps).

##### /defs 
This route and its various sub-routes (e.g., /defs/intervals) will help you looks up definitions and information related to other routes. 

For example, https://macrostrat.org/api/defs/intervals?timescale=international%20epochs will return basic information about all epochs used in the international time-scale (such as their upper and lower ages).

Generally, if you encounter something in the Macrostrat API documentation that you do not understand, you should consider looking for it through the defs route.

### Problem Set 1

1) You first mission is to download a list of all Triassic units in the Macrostrat Database using the /units route into R. Name this object ````TriassicUnits````. As always, show your code.

Hints:
+ You will want to use the ````read.csv( )```` function, similarly to how we have loaded in Paleobiology Database data. Review previous labs if you do not remember how to use this function.
+ You will want to make sure that you set the output format to csv.
+ You should use the interval name Triassic rather than the numerical ages to define your search.

2) How many Triassic units did you download? What code did you use to find out?

3) Look at the first 10 units that you downloaded. Are they mostly Igenous, Metamorphic, or Sedimentary rocks? Do you believe that these units are relevant for an investigation of fossil preservation? Show your code and explain your reasoning.

4) Which *columns* of your ````TriassicUnits```` data.frame denote the starting age and ending age of each unit, respectively?

5) Considering the bottom and top ages of the first 10 units, are these units constrained to only the Triassic or do some range through the Triassic?

### Problem Set 2

1) Re-download ````TriassicUnits````, however, this time restrict the data to only sedimentary rocks. Show your code.

Hints:
+ /units documentation may provide some hepful information.
+ /defs/lithologies may provide some helpful information.
+ As before, use the ````read.csv( )```` function and set the output format to csv.

2) Restrict ````TriassicUnits```` to only units that with starting ages <= start of the Triassic and ending ages >= to the end of the Triassic. As always, show your code.

Hints:
+ You will want to use either the ````which( )``` or ```subset( )``` functions.
+ You will have to make use of logical operators `>=`, `<=`, and `&`. For a review of these, see the [logical operators](https://github.com/aazaff/startLearn.R/blob/master/beginnerConcepts.md#r-as-a-fancy-scientific-calculator) and [subsetting with logical operators](https://github.com/aazaff/startLearn.R/blob/master/intermediateConcepts.md#subscripting-and-subsetting-with-logicals) sections of the R Tutorial.

3) Repeat the above processes (download and subset) for the following geologic periods. The Cretaceous, Jurassic, Triassic (you don't have to download it twice), Permian, Carboniferous, Devonian, Silurian, and Ordovician. Show your code, but do not show me the downloaded data.

4) Make a vector named ````UnitFreqs```` that records the number of units present in each epoch. Show your code.

5) Find the mean and standard deviation of ````UnitFreqs```` **not counting the Triassic**. How many standard deviations above or below the mean is the number of Triassic Units? Show your code.

6) Given your answer to the above, do you believe that the Triassic has a statistically lower number of units than the other periods? Why?

7) What if you consider both the Triassic and Jurassic as potential outliers? Explain (show your code) how you arrived at your answer.

## Part 2

Another way we can approach this problem is by making maps of Triassic and Jurassic units and compare them to other Periods. 

#### Step 1
We will be using a different type of file format than the traditional CSV for this step. Instead, we will use something called GeoJSON. GeoJSON is rarely used in science, but is an extremely common format for web development (think google maps).

You need the packages ````RCurl```` and ````rgdal```` in order to download GeoJSON files in to R. Don't worry, you already installed and loaded those packages during Step 1 of [Part 1](#part-1). If you didn't do that step, go back and do it.

#### Step 2
Let's download a geojson of all Albian columns. Note: We want to use the output format geojson_bare, not just geojson. The ````getURL( )```` function comes from the ````RCurl```` package. Notice that we also limit the data to ````project_id=1````. This limits the data to North America and excludes other smaller datasets contained in Macrostrat - e.g., New Zealand.

````R
# Write out the API route
URL<-"https://macrostrat.org/api/columns?format=geojson_bare&interval_name=Albian&project_id=1"
# Retrieve the URL
GotURL<-getURL(URL)
````

#### Step 3
We next need to convert the GeoJSON into a shapefile. While GeoJSON is normally used by web developers, shapefiles are commonly used by scientists. Popular geospatial analysis (mapping) programs like QGIS and ArcGIS use shapefiles as their primary data format. R is not really meant for mapping or web develoment, but packages, like ````rgdal````, can be used to shoehorn R into those purposes. 

````R
# Conver the URL to a shapefile
AlbianMap<-readOGR(GotURL,"OGRGeoJSON",verbose=FALSE)
````

#### Step 4
Plot the map using the ```plot( )```. Notice that although we used ````col=rgb( )```` to define the plot color last week, this week we are using a [hexcode](http://www.color-hex.com/). This is because the international commission on stratigraphy has assigned each geologic interval (eon, era, period, epoch, and age) an official hexcode color. The downside of using a hexcode instead of ````rgb( )```` is that you cannot easiy change the transparency of polygons.

````R
# Plot the map
plot(AlbianMap,col="#CCEA97")
````

![Albian Map](https://github.com/aazaff/teachPaleobiology/raw/master/Lab11Figures/Fig3.png)

## Problem Set 3

1) Download and plot a map of **all** North American geologic columns (no color). Show your code.

2) On top of your map from Question 1, plot a map of all North American columns with Induan-Anisian sedimentary units. Use the Olenekian hexcode color for this map. You can look up the Olenekian hexcode through the /defs/intervals route. 

3) Using the ````downloadPBDB( )```` function from previous labs. Download all occurrences of animal fossils in the Paleobiology Database of Induan-Anisian age. Using the ````points( )```` function, plot all of these occurrences on the map you made in question 2 as solid circles. If you do not remember how to use points, you can consult previous labs or use ````help(points)````. Show your code. Save this map for later questions.

4) You can open a new plot window using ````quartz( )```` if you are on a mac or ````windows( )``` if you are on a windows machine. Download and plot a map of *all* North American geologic columns (no color) - i.e., repeat Question 1 in this new plot window. On top of this map, plot a map of all North American columns with Lopingian aged sedimentary units. Use the appropriate Lopingian hexcode color for this new map. Show your code.

5) Download all occurrences of animal fossils in the Paleobiology Database of Lopingian age. Plot all of these occurrences on the map you made in question 2 as solid circles. Show your code.

6) Compare and contrast your Induan-Anisian map versus your Lopingian map. Does it seem based on these maps that...

+ There was a substantial drop in the areal extent of North American sedimentary units across the P/T boundary.
+ There was a substantial drop in the percentage of sedimentary units with reported fossils in them aross the P/T boundary?
+ Overall, do you think there is sufficient evidence from these maps to reject or accept the hypothesis that lower diversity in the Early Triassic is an artefact of either poor fossil sampling of the available sedimentary rock ***or*** a low availablility of sedimentary rock.
