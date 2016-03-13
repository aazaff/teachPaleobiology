# The migration of paleocontinents

Today we will be investigating the ecological impact of paleocontinent migration.

## Visualizing the continents

Let's take a look at the orientation of the continents today versus 66 million years ago.

#### Step 1
Load in the beta version of the [paleobiologyDatabase.R](https://github.com/aazaff/paleobiologyDatabase.R/blob/master/README.md#paleobiologydatabaser) package's [communityMatrix.R](https://github.com/aazaff/paleobiologyDatabase.R/blob/master/README.md#communitymatrixr) module.

````R
source("https://raw.githubusercontent.com/aazaff/paleobiologyDatabase.R/master/communityMatrix.R")
````

#### Step 2
<p>Use the ````downloadPaleogeography( )```` function to download a map of end-Cretaceous paleocontinents and modern continents. The function takes an Age in millions of years, must be a whole number where 0 &#8804; Age &#8804; 541. 


````R
# Download a Cretaceous map
CretaceousMap<-downloadPaleogeography(Age=66)

# Download a Modern map
ModernMap<-downloadPaleogeography(Age=0)
````

#### Step 3
Make a plot of your maps. We will first make a plot of ````CretaceousMap````, because geologists always start from oldest to youngest.

````R
plot(CretaceousMap,col=rgb(0,0,1,0.33),lty=0.01)
````

Next, we will make a plot of ````ModernMap```` and overay it on top of ```CretaceousMap````. We will make it translucent, so that we can see the Cretaceous background.

````R
plot(ModernMap,col=rgb(1,0,0,0.33),lty=0.01,add=TRUE)
````

#### Problem Set 1

1) Is North America current to the West or East of its position in the Cretaceous?

2) Look at the following line of code that you used before.
````R
plot(ModernMap,col=rgb(1,0,0,0.33),lty=0.01,add=TRUE)
````
Describe what this code is doing. A good answer will describe what each of the ````plot( )```` function **arguments** is doing - i.e., what is the meaning of col=, lty= and add=. As well, what does the ````rgb( )```` function do? What does it mean? Use google or the R ````help( )```` function.

3) Download a map of the middle Cretaceous (Albian Epochs ~110 mys ago). Name is ````AlbianMap````. 

4) Add ````AlbianMap```` to the plot you made earlier. The added continents should be colored green, and use the same level of opacity (translucence) as your ````CretaceousMap```` and ````ModernMap````. Show your code!

5) Has there been more movement north and south or east and west in the Eastern Hemisphere since the Albian?

6) Has there been more movement north and south or east and west in the Western hemisphere since the Albian?

## Problem Set 2

1) Download and plot a new map of the Paleocene/Eocene boundary (Age=55 mya). You may use any color and level of opacity. Show your code.

2) Download a dataset of Anthozoan occurrences from the paleobiology database ranging from the Paleocene through Eocene. Consult with previous labs if you do not remember how to do this. Show your code.

3) How many occurences did you download?

4) What are the names of columns of the PBDB data matrix you just downloaded. What does each column mean? If you do not know, consult with the [API documentation](https://paleobiodb.org/data1.2/occs/list_doc.html). 

5) Use the ````points( )```` function to plot each occurrence on the map you made previously (make sure to use the paleolatitude and paleolongitude coordinates). Show your code. If you do not know how to use the ````points( )```` function, consult the help file or use Google.

6) Where are most of the Anthozoan occurrences in the Eastern Hemisphere (i.e., what region of the world)? Are Anthozoans primarily marine or freshwater organisms? What can you infer must have existed in this region of the world during this time?

## Problem Set 3

1) Download a dataset of Perissodactyla occurrences from the PBDB that span the Paleogene. Show your code.

2) What is the defining attribute of Perissodactyla? What are some prominent examples (e.g., lions, tigers, bears, oh my!)? [Hint: Neither lions, nor tigers, nor bears]

3) Find collection number 112723 in the dataset you just downloaded in Question 1. Show your code.

4) What "geoplate" id (tectonic plate) is associated with this collection? What modern day region of the world does this geoplate id correspond to? The remaining questions will refer to this geoplate/region as region-X.

5) Subset your dataset of Perissodactyla occurrences to only include occurrences that occur in region-X. How many occurrences are there? Show your code.

6) Using the maps we have created previously, making your own new maps, or using the Paleobiology Database Navigator tool, what is the general history of region-X from the Albian through to the present day?

7) There are also many Paleogene occurrences of Perissodactyla in present day China. Using the maps we have created previously, making your own new maps, or using the Paleobiology Navigator tool, evaluate the plausibility of each of the following scenarios? ***Thoroughly*** explain your reasoning and how you tested your ideas.

+ Species of Perissodactyla migrated from region-X to China during the Paleogene?
+ Species of Perissodactyla migrated from China to region-X during the Paleogene?
+ The species of Perissodactyla in China and region-X are unrelated and probably both came from a third region? 
