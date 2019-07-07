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

# Get the fauna in each sample
Fauna = by(Pleistocene, Pleistocene[,"collection_no"],function(x) by(x[,"genus"],x[,"collection_no"],function(y) unique(as.character(y))))

# Find the Jaccard similarity of compared pbdb collections
fossilSimilarity = function(Data) {
	Combinations = t(combn(names(Data),2))
	Similarity = vector("numeric",length=nrow(Combinations))
	names(Similarity) = apply(Combinations,1,function(x) paste(x,collapse="."))
	for (i in 1:nrow(Combinations)) {
		Similarity[i] = calcJaccard(Data[[Combinations[i,1]]],Data[[Combinations[i,2]]])
		}
	return(Similarity)
	}

Jaccard = fossilSimilarity(Fauna)

# Get the paleolat and paleolng of each colelction_no
Coordinates = unique(Pleistocene[,c("collection_no","paleolng","paleolat")])
Coordinates[,"paleolng"] = convertRadians(Coordinates[,"paleolng"])
Coordinates[,"paleolat"] = convertRadians(Coordinates[,"paleolat"])

# A function for converting degrees to radians
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

# Find the haversine distance of compared pbdb collections
coordinateDistance = function(Data) {
	Index = t(combn(seq_len(nrow(Data)),2))
    Similarity = apply(Index,1,function(x,y) calcHaversine(Data[x[1],"paleolng"],Data[x[1],"paleolat"],Data[x[2],"paleolng"],Data[x[2],"paleolat"]),Data)
   	Collections = t(combn(Data[,"collection_no"],2))
    names(Similarity) = apply(Collections,1,function(x) paste(x,collapse=".")) # I don't like this because it makes the index brittle
	return(Similarity)
	}

Distances = coordinateDistance(Coordinates)

Answer = cbind(Distances,Jaccard)

plot(y=Answer[,"Jaccard"],x=Answer[,"Distances"],pch=16,xlab="distance",ylab="jaccard similarity",las=1)