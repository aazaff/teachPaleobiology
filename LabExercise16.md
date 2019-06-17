## Periodicity in Sediments
In a seminal [1984 paper](https://www.pnas.org/content/pnas/81/3/801.full.pdf) David M. Raup and J.J. Sepkoski detected a 27-million year periodicity in extinction rates (originally stated to be 26 Myr).

This finding sparked a lot of speculation that perhaps there was an extra-terrestrial mechanism (e.g., cosmic radition, impacts) that operated on a 27-million year cycle that was driving extinction patterns. 

Let's take quick look at what the PBDB has to say about this finding.

## Download paleobiology database data
Let's download two starting dataset from the paleobiology database and calculate extinction rates *q* across the Eocene-Oligocene mass extinction boundary.

````R
# Load in the velocirpatr package

# Get that Eocene data
Eocene = velociraptr::downloadPBDB(Taxon="mammalia",StartInterval="Eocene",EndInterval="Eocene")

# Get that Oligocene data
Oligocene = velociraptr::downloadPBDB(Taxon="mammalia",StartInterval="Oligocene",EndInterval="Oligocene")
````
plot(f.data$freq[harmonics]*length(trajectory), 
+      f.data$spec[harmonics]/sum(f.data$spec), 
+      xlab="Harmonics (Hz)", ylab="Amplitute Density", type="h")
library(GeneCycle)
> f.data=GeneCycle::periodogram(SedimentExtinction)
trajectory=SedimentExtinction[findPeaks(SedimentExtinction,"local_max")][which(SedimentExtinction[findPeaks(SedimentExtinction,"local_max")]>0.112994)]

findPeaks<-function(x,Model="all_min") {
+         Peaks<-switch(Model,
+                 "all_min"=which(diff(c(FALSE,diff(x)>0,TRUE))>0),
+                "local_min"=which(diff(diff(x)>0)>0)+1,
+                 "all_max"=which(diff(c(TRUE,diff(x)>=0,FALSE))<0),
+                 "local_max"=which(diff(diff(x)>=0)<0)+1
+                 )
+         return(Peaks)
+         }
