# Introduction to Principle Components Analysis

Here is a basic explanation of PCA by Steven M. Holland (modified), at the University of Georgia. For a more in depth explanation, including a bit about the underlying math, you can see the original tutorial [here](http://strata.uga.edu/software/pdf/pcaTutorial.pdf).

Suppose we measure two variables, **length** and **width**, and plot them as shown below. Both variables have approximately the same variance (spread of the distribution - i.e., the **standard deviation** squared) and they are highly correlated with one another. We could pass a line through the long axis of the cloud of points and a second line at right angles to the first, with both lines passing through the centroid (center) of the data.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab2Figures/PCA1.png" align="center" height="300" width="650" ></a>

Once we have made these lines, we could find the coordinates of all of the data points relative to these two perpendicular lines and replot the data, as shown here (both of these figures are from Swan and Sandilands, 1995).

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/paleobiologyWebsite/master/Lab2Figures/PCA2.png" align="center" height="300" width="650" ></a>

The variance is greater along axis 1 than it is on axis 2 in this new reference frame. Also note that the spatial relationships of the points are unchanged; this process has merely rotated the data. Finally, note that the axes are uncorrelated. By performing such a rotation, the new axes might have particular explanations. 

In this case, axis 1 could be regarded as a size measure, with samples on the left having both small length and width and samples on the right having large length and width. Axis 2 could be regarded as a measure of shape, with samples at any axis 1 position (that is, of a given size) having different length to width ratios.

These relationships may seem obvious, and you might wonder why you would need a PCA to sleuth them out. However, when one is dealing with *many* variables, this process allows one to assess much more quickly any relationships among variables. For data sets with many variables, the variance of some axes may be great, whereas others may be small that they can can be ignored. This is known as reducing the dimensionality of a data set. For example, one might start with thirty original variables, but end with only two or
three axes that PCA identifies as meaningful.
