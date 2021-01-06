# Lesson08_VisualizingData.R
# Date: Mar 19, 2017 8:04:25 PM 2017
#
# Author: M. Joseph Meyer
###############################################################################

# set the seed
set.seed(7720)

# An important part of analyzing data in research is to visualize the data in a presentable way,
# in order for researchers and article readers to best understand relationships and trends in
# the data.  In this unit, we'll look at various plotting methods, arguments, and other customizable
# options that will help you make plots that best fit your data.  We will also describe some best
# practices with data visualization that may help you avoid making misleading or ambiguous plots.

#------------------------------------------------------------

# Basic plot function:

# The basic plot function is in the form

# plot(x,y)

# Where x is the vector of x-coordinates, and y is the vector of y-coordinates.

# When plotting using this form, x and y need to have the same number of elements!

# Some examples:
x <- -4:4
x2 <- seq(-4,4,.1)
yXSquared <- x^2
yDensity <- dnorm(x)
yDensity2 <- dnorm(x2)
yScatter <- x*2 + 5 + rnorm(9,sd=1.5)
plot(x,yXSquared)
plot(x,yDensity)
plot(x2,yDensity2)
plot(x,yScatter)

# When making plots, the plots will go on the bottom-right part of the RStudio screen (see the
# slides on Collab for pictures!)

#------------------------------------------------------------

# Arguments for many plot methods

# Because every dataset looks different from other datasets, each plot may need to
# be customized differently for each dataset.  Luckily, R has many customization options
# for plotting data!  The most common arguments used for the plot function when
# plotting data are below:

# The type argument is used to choose whether to plot points, lines, or some combination of
# the two.

# p: points
plot(x,yXSquared,type="p")
plot(x,yDensity,type="p")
plot(x2,yDensity2,type="p")
plot(x,yScatter,type="p")

# l: lines
# Note that the line will connect the points in order of the x and y coordinates specified.
plot(x,yXSquared,type="l")
plot(x,yDensity,type="l")
plot(x2,yDensity2,type="l")
plot(x,yScatter,type="l")

# b: both lines and points
plot(x,yXSquared,type="b")
plot(x,yDensity,type="b")
plot(x2,yDensity2,type="b")
plot(x,yScatter,type="b")

# c: the lines part alone of "b"
plot(x,yXSquared,type="c")
plot(x,yDensity,type="c")
plot(x2,yDensity2,type="c")
plot(x,yScatter,type="c")

# o for both lines and points 'over-plotted'
plot(x,yXSquared,type="o")
plot(x,yDensity,type="o")
plot(x2,yDensity2,type="o")
plot(x,yScatter,type="o")

# "h" for 'histogram' like (or â€˜high-densityâ€™) vertical lines
plot(x,yXSquared,type="h")
plot(x,yDensity,type="h")
plot(x2,yDensity2,type="h")
plot(x,yScatter,type="h")

# "n" for no plotting
# This option is useful when you want to plot multiple sets of lines or points using separate functions
# (we'll go over the points() and lines() functions later in this script)
plot(x,yXSquared,type="n")
plot(x,yDensity,type="n")
plot(x2,yDensity2,type="n")
plot(x,yScatter,type="n")

#------------------

# Labels

# To add labels to your plot, you can use the xlab, ylab, and main arguments!

# xlab adds/changes the label for the x-axis
# ylab adds/changes the label for the y-axis
# main adds/changes the title

plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Parabola")
plot(x,yDensity,type="l",xlab="quantile",ylab="density",main="Rough Normal Distribution")
plot(x,yScatter,xlab="IV",ylab="DV",main="Simulated Scatterplot")

#------------------

# xaxt, yaxt

# if you set xaxt or yaxt to "n", you can remove the default tick marks
# for the corresponding axis.  This is useful when you want to define
# your own tick marks:

plot(x,yXSquared,xaxt="n")
plot(x,yDensity,yaxt="n")

#------------------

# xlim, ylim

# To set the minimum and maximum values of the viewable plot, we can
# use the xlim and ylim arguments:

# Our default plot, with x on the x-axis and yDensity on the y-axis.  Here,
# we see that our x-axis goes from -4 to 4, and our y-axis goes from 0 to 0.4.

plot(x,yDensity)

# This is because the minimum and maximum values of x are -4 and 4, respectively...
min(x)
max(x)

# ... and the minimum and maximum values of yDensity are approximately 0 and 0.4,
# respectively:
min(yDensity)
max(yDensity)

# When using the xlim and ylim arguments, the arguments expect a vector of two values:
# the minimum and maximum limits for the x-axis and y-axis, respectively.

# For example, xlim=c(0,4) changes the view to only show the part of the plot between
# an x value of 0 and an x value of 4:
plot(x,yDensity,xlim=c(0,4))

# ylim=c(0,0.5) changes the view to only show the part of the plot between a y value
# of 0 and a y value of 0.5:
plot(x,yDensity,ylim=c(0,0.5))

# Be careful when choosing xlim and ylim values in your own plots.  While it may be helpful
# to change the limits of the plot so that you can focus on certain parts of the data, you need 
# to make sure that you're not masking important parts of your plot, or making your plot too
# small to see any differences between groups.

# Going back to the xlim example:
plot(x,yDensity,xlim=c(0,4))

# It looks like the our yDensity values decrease as x increase.  However, if we look at
# our original plot:
plot(x,yDensity)

# we can see that yDensity first increases, and then decreases.  A very different trend!

#------------------

# col

# The col argument changes the color of the points or lines in 
# the plot.  Make sure to put the name of the color in quotes!

# col="red" when using type="l" sets the color of the line to red
plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Parabola",col="red")

# col="red" when using type="p" sets the color of the points to red
plot(x,yXSquared,type="p",xlab="x",ylab="x^2",main="Parabola",col="red")

# For the full range of colors you can use in R, look at the link
# https://stat.columbia.edu/~tzheng/files/Rcolor.pdf, or at the Rcolor.pdf file on
# Collab.

# If you're familiar with writing colors in RGB (red,blue,green) format, you can use
# the rgb function.  The rgb function has three minimum arguments, which each take values from 0 to 1.
# The higher the number, the more of that color is added to the final color (so rgb(red=0.5,green=0,blue=0.5) should
# give you purple).
# col=rgb(red=0,green=0,blue=1) sets the color of the line to blue
plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Parabola",
     col=rgb(red=0,green=0,blue=1))

# col=rgb(red=0.5,green=0,blue=0.5) sets the color of the line to purple
plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Parabola",
     col=rgb(red=0.5,green=0,blue=0.5))

# Extra info: if you know how to write colors as hex codes, you can use that too!
# col="#E57200" sets the color of the line to UVa's shade of orange (RGB values 229,114,0)
plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Parabola",col="#E57200")

# col="#232D4B" sets the color of the line to UVa's shade of navy blue (RGB values 35,45,75)
plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Parabola",col="#232D4B")

#------------------

# lty: line type

# If you want to change the type of the line (i.e., to a dotted line), you can use
# the lty argument.

# 0 = blank
plot(x,yScatter,type="l",lty=0)

# 1 = solid (default)
plot(x,yScatter,type="l",lty=1)

# 2 = dashed
plot(x,yScatter,type="l",lty=2)

# 3 = dotted
plot(x,yScatter,type="l",lty=3)

# 4 = dotdash
plot(x,yScatter,type="l",lty=4)

# 5 = longdash
plot(x,yScatter,type="l",lty=5)

# 6 = twodash
plot(x,yScatter,type="l",lty=6)

# the lty argument can also take character strings of the options:
plot(x,yScatter,type="l",lty="dashed")

#------------------

# lwd: line thickness

# If you want to change the thickness of a line, you can use the lwd argument.

# 1 is the default
plot(x,yScatter,type="l")
plot(x,yScatter,type="l",lwd=1)

# Thicker lines: > 1
plot(x,yScatter,type="l",lwd=2)
plot(x,yScatter,type="l",lwd=5)
plot(x,yScatter,type="l",lwd=10)

# Thinner lines: < 1 (only positive numbers work)
plot(x,yScatter,type="l",lwd=0.5)
plot(x,yScatter,type="l",lwd=0.2)
plot(x,yScatter,type="l",lwd=0.1)

#------------------

# cex: magnification level, i.e. for points

# If you want to change the size of a point, you can use the cex argument.

# 1 is the default
plot(x,yScatter,type="p")
plot(x,yScatter,type="p",cex=1)

# larger sizes: > 1
plot(x,yScatter,type="p",cex=2)
plot(x,yScatter,type="p",cex=5)
plot(x,yScatter,type="p",cex=10)

plot(x,yScatter,type="p",cex=x+5)

# smaller sizes: < 1
plot(x,yScatter,type="p",cex=0.5)
plot(x,yScatter,type="p",cex=0.2)
plot(x,yScatter,type="p",cex=0.1)

# Note that this is different than lwd - the cex argument will increase the 
# radius of the point circle (the size of the whole point), while lwd
# will increase the thickness of the line of the point.
# cex: increasing the radius
plot(x,yScatter,type="p",cex=2)
# lwd: increasing the thickness
plot(x,yScatter,type="p",lwd=2)

#------------------

# pch - point type

# If you want to change the type of the point (i.e., to a square), you can use
# the pch argument.

# There are over 100 possible options for point types.  See
# https://www.rdocumentation.org/packages/graphics/versions/3.5.1/topics/points
# for more details.

# Some examples of points:

# 1 is the default
plot(x,yScatter,type="p")
plot(x,yScatter,type="p",pch=1)

# 0: square
plot(x,yScatter,type="p",pch=0)

# 2: triangle
plot(x,yScatter,type="p",pch=2)

plot(x,yScatter,type="p",pch="R")

# 3: plus
plot(x,yScatter,type="p",pch=3)

# 4: cross
plot(x,yScatter,type="p",pch=4)

# 8: star
plot(x,yScatter,type="p",pch=8)

# 19: solid circle
plot(x,yScatter,type="p",pch=19,col="blue")

# For certain points (21:25), we can change the fill color by using bg:

# 21: filled circle
# col="blue" changes the border or line of the points to blue, and bg="red" changes the
# inside or fill of the points to red:
plot(x,yScatter,type="p",pch=21,bg="red",col="blue")

# 22: filled square
# bg="green" changes the inside or fill of the points to green:
# Note that we didn't change the color of the point line this time, so the outer part of the point
# is still black by default
plot(x,yScatter,type="p",pch=22,bg="green")

# 24: filled triangle
# col="blue" changes the border or line of the points to blue, bg="red" changes the
# inside or fill of the points to red, cex=3 makes the points 3 times bigger, and lwd=2
# makes the lines of the points 2 times thicker:
plot(x,yScatter,type="p",pch=24,bg="red",col="blue",cex=3,lwd=2)

# We can also use keyboard symbols to specify other kinds of point types:
plot(x,yScatter,type="p",pch="*",cex=3)
plot(x,yScatter,type="p",pch="+",cex=3)
plot(x,yScatter,type="p",pch="$",cex=3)
plot(x,yScatter,type="p",pch="5",cex=3)
plot(x,yScatter,type="p",pch="P",cex=3)

# More examples can be found at
# http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r

#------------------------------------------------------------

# The par function

# In addition to all of these arguments, we can use the par function to 
# manipulate plots further.

# While arguments in the plot function will customize the points, lines, and axes in
# the plot, the arguments in the par function will customize the entire plot and the
# area around it.

# Unlike most functions, running the par function will change the options of the
# plot globally; that is, all future plots will also have any customization options
# you set.  To reset these options, we need to save the output of the par function
# to an R object (typically named "op", but can be any name), and then run the par
# function again after we run the plot functions with the R object (op) as the only
# argument.

# Let's try an example.  As we'll see below, the mfrow argument in the par function will let you
# have multiple plots in the plotting area.
# To start, we can run the par function with the mfrow argument we want.  We then save
# the options by assigning them to an object (op):
op <- par(mfrow=c(1,3))

# Note that op is now a list containing all the original values of the options we set
# from the par function, so that we can reset the options back later:
str(op)

# Next, we run the plots:
plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Red Parabola",col="red")
plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Blue Parabola",col="blue")
plot(x,yXSquared,type="l",xlab="x",ylab="x^2",main="Green Parabola",col="darkgreen")

# and then we can revert the options so that only one plot is in in the plotting area by
# putting the object op back into the function:
par(op)

# Remember that if we don't do this or run all the code, we'll continue to have 3 plots
# in the plotting area!

# If you want to know the default values of any argument, you can run the par function
# with just the name of the argument in quotes:

par("mfrow")

#------------------

# mar: Change the margins of the plot

par("mar")

# This corresponds with the current margin size, in order of
# bottom, left, top, and right.

# Let's start by plotting x and yXSquared.
plot(x,yXSquared)

# Now, let's try decreasing the margins:
op <- par(mar=c(0.2,0.2,0.2,0.2))
plot(x,yXSquared)
par(op)

# And now increasing them:
op <- par(mar=c(10,10,10,10))
plot(x,yXSquared)
par(op)

# What if we go farther?
op <- par(mar=c(40,40,40,40))
plot(x,yXSquared)
par(op)

# If our margins are too large, we'll get the error "figure margins too large."
# You may see this error come up when your plot size for RStudio is too small, as well.

#------------------

# bg: change the background

# bg="blue" sets the entire plotting area to the color blue
op <- par(bg="blue")
plot(x,yXSquared,type="l",col="red")
par(op)

#------------------

# mfrow: multiple plots at once

# What if we want to combine all three plots into one?  Then, we can use the mfrow
# argument!

par("mfrow")

# This sets up a window that will plot up to 3 plots at once in a 1 x 3 grid (1 = number of
# rows, and 3 = number of columns)
op <- par(mfrow=c(1,3))
# Plotting 3 plots
plot(x,yXSquared,type="l")
plot(x,yDensity,type="l")
plot(x,yScatter)
# Remember: this statement reverts the par() options so that you can plot one plot at a time!
par(op)

#------------------------------------------------------------

# Functions to plot over existing plots

# In addition to the plot function, which will create a new plot each time,
# We can also use certain functions to draw lines, points, and other things to already existing plots.
# Note that these can only be used if a plot already exists - you'll need to create a run the plot
# function at least once first.

# Also, in many cases, the arguments used in the plot function will work in these functions, too.
# For example, arguments that customize points can be used in the points function.

# points() - add additional points to the plot.
# Plot a line where x contains the x-coordinates and yXSquared contains the y-coordinates
plot(x,yXSquared,type="l")
# Plot points as stars (pch=8) at each value of x and yXSquared on top of the line
points(x,yXSquared,pch=8)

#------------------

# lines()
# plotting yDensity vs. x (fewer values)
plot(x,yDensity,type="l",lty=3)
# plotting yDensity2 vs. x2 (more values)
lines(x2,yDensity2,col="blue")

# Plotting yScatter vs. x
plot(x,yScatter)
# plotting a line of best fit (or regression line)
lines(x,2*x+5)

# We can set up a blank plot using type="n" if we just want to plot multiple lines using the
# lines() function.
plot(x,yXSquared,type="n",xlim=c(-4,4),ylim=c(-4,20))
lines(x,yXSquared,col="blue")
lines(x,yDensity,col="red")
lines(x,yScatter,col="green")

# If you want to specify a specific plot size first, you can plot the minimum and maximum values
# in the first plot function:
plot(c(-4,4),c(-4,20),type="n")
lines(x,yXSquared,col="blue")
lines(x,yDensity,col="red")
lines(x,yScatter,col="green")

# Or, you can use the xlim and ylim arguments when doing the initial plot:
plot(x,yXSquared,type="n",xlim=c(-4,4),ylim=c(-4,20))# Note that you still need to specify x and y values!
lines(x,yXSquared,col="blue")
lines(x,yDensity,col="red")
lines(x,yScatter,col="green")

#------------------

# abline - plot intercept and slope

# You can use the abline to draw a line based on the intercept and slope of a line
# The function uses the form abline(a,b), and will plot the line y = b*x + a, where
# b is the slope and a is the intercept.

# abline is useful if you perform a simple linear regression, and want to plot a
# line of best fit.

# Plotting our scatterplot (yScatter vs. x)
# As a reminder, yScatter = x*2 + 5 + some amount of errors, so the line of best fit
# should have an intercept of 5 (a = 5) and a slope of 2 (b = 2).
plot(x,yScatter)
abline(a=5,b=2)

#------------------

# text - plot text

# If we want to add text to our plot, we can use the text function

# The text function is in the form text(x,y,"my text"), where x and y are the initial
# x and y coordinates of the text.

# Just like with lines and points, you can use certain plot arguments with text.  For
# example, we can use the cex argument to magnify the size of the text.

plot(x,yXSquared,type="l",xlim=c(-6,3),ylim=c(-2,14),col="blue")
text(-2,9,"This is a parabola.",cex=2)

#------------------

# polygon - plot a polygon

# If you wanted to plot a polygon, you can use the polygon function!

# The polygon function is in the form polygon(x,y), where x is all the x values
# and y is all the y values (just like with plot, lines, points, etc.)

# Note that a line will be drawn across all points, as well as a line between the last
# point and the first.

# Plotting a blank plot, using the x and y values to determine the minimum and maximum
# values of the plot.
plot(c(1,7),c(1,7),type="n",main="Triangle")
# Plotting a triangle with coordinates (2, 2), (6, 2), and (6, 6).
polygon(c(2,6,6),c(2,2,6))

# Plotting a stop sign
plot(x,yXSquared,type="n",xlim=c(1,7),ylim=c(1,7),main="Stop Sign")
# Plotting a dark red octagon (8 sets of x and y coordinates)
polygon(c(2,3,5,6,6,5,3,2),c(5,6,6,5,3,2,2,3),col="darkred")
# Adding the word "STOP" to the stop sign (magnified 5 times and with the color white)
text(4,3.75,"STOP",col="white",cex=5)

#------------------

# rect - plot a rectangle

# If you just wanted to plot a rectangle (i.e., to draw a box around something), you
# can use the rect function

# The rect function is in the form rect(xleft,ybottom,xright,ytop), representing the 
# x and y coordinates for the bottom left and top right corner points, respectively.

plot(c(1,7),c(1,7),type="n",main="Square")
# Plotting a rectangle (square) with the bottom left point at (2, 2), and the top right point
# at (6, 6).
rect(xleft=2,ybottom=2,xright=6,ytop=6)

plot(c(1,7),c(1,7),type="n",main="Rectangle")
# Plotting a rectangle with the bottom left point at (3, 2), and the top right point
# at (5, 6).
rect(3,2,5,6)

#------------------

# arrows - add arrows to plot

# If you want to add arrows to a plot, you can use the arrows function!

# The arrows function is in the form
# arrows(x0, y0, x1 = x0, y1 = y0)

# Where x0 and y0 are the coordinates of the tail of the arrow, and x1 and y1 are the
# coordinates of the head of the arrow
# Note that if you don't include x1 or y1, then x1 is set to x0, and y1 is set to y0

# Plotting our parabola
plot(x,yXSquared,type="l",xlim=c(-3,3),ylim=c(-2,14),col="blue")
# Adding an arrow with tail coordinates (-1, 9) and head coordinates (-3, 9) (and setting
# the color to red)
arrows(-1,9,-3,9,col="red")

# Plotting our triangle from before
plot(c(1,7),c(1,7),type="n",main="Find X")
polygon(c(2,6,6),c(2,2,6))
# Adding in X
text(4,4.5,"X",cex=2)
# Drawing a blue arrow to X
arrows(2,6,3.5,5,col="blue")
# And yelling "There it is!" using the text function
text(2,6.25,"There it is!",cex=2,col="blue")

#------------------------------------------------------------

# axis() functions

# axis() will let you customize the tick marks on the x-axis or y-axis.

# The axis function is in the form
# axis(side, at, labels)
# Where side is the side of the plot you're adding tick marks to (1=below, 2=left,
# 3=above and 4=right), at is the vector of values where you're adding tick marks,
# and labels is what you want the tick marks to say (you can skip using this argument
# if you want the labels to be the same as the values)

# Let's start with our initial plot
plot(x, yXSquared, type="l", col="blue")

# Let's suppose we want to change the tick marks on the y-axis (on the left) to go up every
# 3 values instead of every 5 values.

# First, when doing so, typically we use the xaxt="n" and/or yaxt="n",
# so that we can start with empty tick marks before adding new ones using
# axis (otherwise, both the old tick marks and the new ones will be on the plot).
plot(x, yXSquared, type="l", col="blue",yaxt="n")

# Then, we can use the axis function, using side = 2 and at = seq(0,15, by = 3):
plot(x, yXSquared, type="l", col="blue")
axis(side = 2, at = seq(0,15,by = 3))

# We can also add unique labels for the values, if it makes sense to do so:
# Plotting the parabola with no tick marks on the y-axis
plot(x, yXSquared, type="l", col="blue",yaxt="n")
# Adding tick marks at 0, 5, 10, and 15, with the labels "nothing", "some", "a lot", "way too much"
axis(side = 2, at = seq(0,15,5), labels=c("nothing","some", "a lot","way too much"))

# If we want to change the tick marks on the x-axis (the bottom side), we can use side = 1:
# Plotting the parabola with no tick marks on the x-axis
plot(x, yXSquared, type="l", col="blue",xaxt="n")
# This will make the first, or bottom side (the x-axis) have tick marks for every integer from -4 to 4
axis(side = 1, at = -4:4)

# We can also add tick marks on other sides of the plot (this may be helpful if you want to have two
# different scales on the same plot
# This will make the fourth, or right side mimic the values on the left side (the y-axis)
axis(side = 4, at = seq(0, 15, by=5))

#------------------

# legend() will let you add a legend to your plot

# The basic form of legend is

# legend(x, legend)

# where x is the position of the legend, and legend is a vector of labels.

# Note that x here can be an x-coordinate, but is more typically a general position in the plot instead
# (i.e., "bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right" and "center").
# Also, in order to match the labels with the plot, you'll need to use similar arguments used
# when making the plot itself.

# To start, let's draw our parabola (that has a quadratic trend) and a new line (which has a linear trend).
plot(x, yXSquared, type="l", col="blue")
lines(x, x + 5, col="red")

# By default, lty (line type) or lwd (line thickness) is used to draw colored lines in the legend, 
# pch (point type) is used to draw points, and fill is used to draw colored boxes.  You can also use other
# arguments (i.e., col) to customize the lines, points, and boxes further.

# This draws a legend in the bottom left that has labels "linear" and "quadratic," and adds a red and blue line,
# both with line type 1.  Here, red and blue were chosen along with line type 1 because those were the colors and
# line types of the lines in the plot.
legend("bottomright", legend = c("linear", "quadratic"),lty=c(1,1),
       col = c("red", "blue"))

# This draws a legend at the top that has labels "linear" and "quadratic," and adds a red and blue point,
# with point types 3 and 5, respectively
legend("top", legend = c("linear", "quadratic"),	col = c("red", "blue"), pch=c(3,5))

# This draws a legend in the bottom right that has labels "linear" and "quadratic," and adds a red and blue colored box
legend("bottomright", legend = c("linear", "quadratic"), fill = c("red", "blue"))

# Note that the legend, too, draws over the graph you already made.  Make sure you put the
# legend in a reasonable place!

#------------------------------------------------------------

# title function

# Another way to add a title is using the title function!

# This is useful if there are plots from other packages that
# don't have a title.

plot(x,yScatter,main="")
title(main="My New Title")

#------------------------------------------------------------

# Saving plots to files

# One way to save plots to files is to use functions to do so, similarly to writing files.

# The basic idea with saving plots is to create and open a file, draw the plot inside the file,
# and then close the file.

# This structure is similar to the sink function (see lesson 6). With the sink function, we
# created and opened a file, wrote output to that file, and then closed the file.

# While the initial file opening functions may differ depending on what kind of file you're 
# creating, you will always need to close the file using the dev.off() function -- otherwise,
# all future plots will be drawn in that file, too!

#------------------

# Plot saving functions

# pdf function - save a plot to a pdf file

# The basic form of the pdf function is

# pdf(file name, height, width)

# The file name is the path where the file will be saved, and the height and width are how large
# the final picture is, in inches.

# A good size for saving plots (i.e., for publications) is to use a height of 5 and a width of 6.

# Opening file
pdf("Lesson_09_tutorial_plots_xSquared.pdf",height=5,width=6)
# Running the plot
plot(x,yXSquared,type="l")
# Closing the file - This is necessary in order to stop plotting to the pdf
dev.off()

# One benefit of using the pdf function over the other functions is that multiple plots can be
# saved to the same file.  Each new plot (i.e., with the plot function) will be on its own page
# in the file

# Opening file
pdf("Lesson_08_tutorial_plots_AllPlots.pdf",height=5,width=6)
# First plot - page 1
plot(x,yXSquared,type="l")
# Second plot - page 2
plot(x,yDensity,type="l")
# Third plot - page 3
plot(x,yScatter)
# Closing the file - This is necessary in order to stop plotting to the pdf
dev.off()

#------------

# png function - save a plot to a png file

# Png files may be useful when you can't use a pdf for some reason

# The basic form of the png function is similar to the pdf function

# By default, height and width are in pixels, so we set units to inches to be consistent with pdf().
# Res is the resolution in ppi (points per inch) -- if you don't know what to choose for this, 300 ppi
# is fine
# Note that you can only plot one plot at a time using the png device

# Opening file
png("Lesson_09_tutorial_plots.png",height=5,width=6,units="in",res=300)
# Running the plot
plot(x,yXSquared,type="l")
# Closing the file
dev.off()

#------------

# jpeg function - save a plot to a jpg file

# When creating plots that can't be saved as a pdf (i.e., for journals that won't accept pdfs for plots),
# png is almost always the next best option.  However, if you want to create a picture that has a smaller
# file size than a png, the jpeg function may be useful.

# The jpeg function is set up in the same way as the png function:

# Opening file
jpeg("Lesson_09_tutorial_plots.jpg",height=5,width=6,units="in",res=300)
# Running the plot
plot(x,yXSquared,type="l")
# Closing the files
dev.off()

#------------------------------------------------------------

# Other types of plots:

# histogram
hist(yXSquared)

# Histograms can take similar arguments to the plot function:

# Adding labels and making the bars grey
hist(yXSquared,main="Squared Values",xlab="Value",col="grey")

# The breaks argument allows you to control the binning of the
# data; that is, how many bars will be in the histogram

# Note that if R can't put your data into a specific number of bins, it may change
# the number of bins automatically to fit all the data in the plot.

# breaks=seq(0,20,by=2) will set the approximate number of breaks to 10, starting at 0
# and ending at 20
hist(yXSquared,main="Squared Values",xlab="Value", breaks=seq(0,20,by=2),col="grey")

# Look at the x-axis - the tick marks didn't change with the breaks we defined!
# Let's fix that.

# The same plot as above, but without any tick marks on the x-axis (xaxt="n")
hist(yXSquared,main="Squared Values",xlab="Value",
     breaks=seq(0,20,by=2),col="grey",xaxt="n")
# Adding in tick marks that are the same as the bins we added
axis(1,seq(0,20,by=2))

# Now, our x-axis matches!

#------------

# boxplot

# We can use the boxplot function to make a boxplot

# The basic form of a boxplot is 

# boxplot(dataset)

# where dataset is either a data frame or matrix containing all the variables you want to look at

# Let's plot boxplots for x, yXSquared, and yScatter
boxplot(cbind(x,yXSquared,yScatter))

# Boxplots can also take similar arguments to the plot function:

# Making all the boxplots green (col="green") and doubling the thickness (lwd=2)
boxplot(cbind(x,yXSquared,yScatter),col="green",lwd=2)
# Making each boxplot a unique color and thickness
boxplot(cbind(x,yXSquared,yScatter),col=c("#E57200","#232D4B","#B59A57"),lwd=c(2,1,4))

#------------

# barplot

# a barplot takes a matrix of values and plots them as bars, where each value in the matrix corresponds
# to the height of the bars
# Each column corresponds to one set of bars, and each row corresponds to one color.

# This is useful when plotting means of values, such as group means when looking at
# how one variable predicts another.

# The basic form of a barplot is 

# barplot(matrix of heights,beside=TRUE,col,
#		legend.text,args.legend=list(x=position))

# where "matrix of heights" is the matrix of values that correspond to the heights of each bar,
# beside = true puts all the values in each column together, while making spaces between each set of values,
# col is the color of each bar
# legend.text is the vector of labels for the legend
# args.legend is a list containing other arguments for the legend (i.e., the position)

# Let's try an example that looks at how sleep and caffeine potentially affects test scores.  Sleep and
# caffeine each have two levels -- the levels for sleep are < 5 hours and >= 5 hours, and the levels
# of caffeine are 0-1 cups of coffee and 2-3 cups of coffee.

# Creating a matrix of cell means.  Factor A corresponds to the rows, and Factor B corresponds to the columns
cellMeanMatrix<-matrix(c(48,42,40,36),byrow=TRUE,nrow=2,dimnames=list(c("< 5 Hours",">= 5 Hours"),c("0-1 Cups","2-3 Cups")))
cellMeanMatrix

# Marginal means for Sleep (means of each row)
marginalMeansSleep <- apply(cellMeanMatrix,1,mean)
marginalMeansSleep

# Marginal means for Caffeine (means of each column)
marginalMeansCaffeine <- apply(cellMeanMatrix,2,mean)
marginalMeansCaffeine

# Plotting cell means
# Here, we're plotting the values in cellMeanMatrix.  We set beside to be true, and the colors of each pair
# of bars to be orange and purple.  The legend text will be equal to the row names of cellMeanMatrix (since
# the columns represent the sets of bars, or the means for each level of caffeine, the rows will represent
# the heights of each bar within each set, or the means for each level of sleep).
# In this plot, we decided to put the legend in the top left (args.legend=list(x="topleft")), and then we
# changed the limits of the y axis to be from 0 to 60 (ylim=c(0,60)).
barplot(cellMeanMatrix,beside=TRUE,col=c("orange","purple"),
        legend.text = rownames(cellMeanMatrix),args.legend=list(x="topleft"),
        ylim=c(0,60))

# If we set beside to false, the bars are set on top of each other instead
barplot(cellMeanMatrix,beside=FALSE,col=c("orange","purple"),
        legend.text = rownames(cellMeanMatrix),args.legend=list(x="topleft"))

# Plotting marginal means for sleep
# Since we're only plotting two values, we don't need to have a legend, and so
# we'll leave out the legend arguments
barplot(marginalMeansSleep,beside=TRUE,col=c("orange","purple"))

# Plotting marginal means for caffeine
# Since we're only plotting two values, we don't need to have a legend, and so
# we'll leave out the legend arguments
barplot(marginalMeansCaffeine,beside=TRUE,col=c("orange","purple"))

# If we want, we can add in the values of the means above each bar.
# To do so, we need to get the x values from the barplot, and then
# use them as x coordinates in a text function.  The y coordinates will be the means + 1 (to add a
# space between the number and the bar), and the labels will be the means, too

# Let's try this with the group means for caffeine.  First, we get the x values
# from the barplot by assigning the output of the barplot to an R object - say, xCaffeineScores:
# We're adding in ylim=c(0,50) too so there's enough room to see the numbers
# Also, the plot is independent of the barplot output - the plot will still show up even when we assign
# the output to a variable, and using the variable won't rerun the plot
xCaffeineScores <- barplot(marginalMeansCaffeine,beside=TRUE,col=c("orange","purple"),ylim=c(0,50))
xCaffeineScores

# Next, we write a text function that has xCaffeineScores as the x-coordinates, marginalMeansCaffeine + 1
# as the y-coordinates, and marginalMeansCaffeine as the labels:
text(x=xCaffeineScores,y=marginalMeansCaffeine+1,labels=marginalMeansCaffeine)

# And now the means are at the top of each bar!

# You can also use these means and x-coordinates along with the lines function to add error bars, if you
# want.  To get 95% confidence interval values, you can use the ci.mean function in the Publish package, or
# if you want to calculate standard errors for 2*standard error bars, you can use the std.error function
# in the plotrix package.

#------------

# qqnorm/qqline

# To make a qqplot of a variable (i.e., to assess normality of a dependent variable),
# we can use the qqnorm and qqline functions:

# The qqnorm function plots the actual points, and the qqline function draws the line
qqnorm(yScatter)
qqline(yScatter)

# The line here represents the relationship between the actual values of yScatter, and the
# expected values of yScatter, assuming we expect a normal distribution.

# The closer the points are to the line, the less likely the distribution of the variable
# deviates from normality.

#------------

# pairs - "matrix" of scatterplots

# This provides an easy way of looking at relationships between sets of variables

# For example, if you have 3 independent variables predicting a dependent variable,
# we can use this to see how the independent variables relate to each other, as well
# as see how well each independent variable predicts the dependent variable

# The form of pairs is pairs(dataset), where dataset is either a data frame or matrix
# containing all the variables you want to look at

# Let's plot x with yXSquared and yScatter
pairs(cbind(x,yXSquared,yScatter))

# Amazingly, x seems to have a quadratic relationship with yXSquared, and a linear relationship
# with yScatter!  (This comes as no surprise, since we constructed yXSquared and yScatter that
# way)

# Also, since yScatter has a linear relationship with x, and yXSquared is just x^2, yXSquared seems
# to have an approximately quadratic relationship with yScatter too.

#------------

# persp - 3D plot

# Another way of looking at multiple variables at the same time is with 3D plots

# We can use the persp function to do this

# The basic idea is that for some set of x and y values, we should have a matrix of
# z values, where z is a function of x and y.  The persp function then takes the form

# persp(x,y,z)

# Where x and y are the vectors of x and y coordinates, and z is the matrix of z values.

# Create x and y values
randVarX <- seq(-pi/2,pi/2,pi/4)
randVarY <- seq(-pi/2,pi/2,pi/4)
# Create an empty matrix with 5 rows and 5 columns called myJointFunction
myJointFunction<-matrix(nrow=5,ncol=5)
# for i and j between 1 and 5...
for(i in 1:5){
  for(j in 1:5){
    # Calculate the value of (sin(ith x)^2 + cos(jth y)^2)/25, and assign it to
    # the element in myJointFunction in the ith row and jth column
    tempX<-randVarX[i]
    tempY<-randVarY[j]
    myJointFunction[i,j]<-(sin(tempX)^2+cos(tempY)^2)/25
  }
}
# So every row in myJointFunction corresponds to an x value, and every column corresponds
# to a y value.

# Once you have the matrix of z values (the myJointFunction matrix), we can put it into
# persp!
persp(x=randVarX,y=randVarY,z=myJointFunction)

# To make the plot easier to see, let's add some colors.  We'll create a vector of 5 colors that correspond to
# the 5 x and y values:

my3dColors <- c("red",'blue',"gold","green","purple")
persp(x=randVarX,y=randVarY,z=myJointFunction,col=my3dColors)

# The persp function also has two rotation arguments: theta and phi.

# theta controls the "horizontal" or azimuthal rotation of the plot
persp(x=randVarX,y=randVarY,z=myJointFunction,theta=30,col=my3dColors)
persp(x=randVarX,y=randVarY,z=myJointFunction,theta=90,col=my3dColors)
persp(x=randVarX,y=randVarY,z=myJointFunction,theta=135,col=my3dColors)
persp(x=randVarX,y=randVarY,z=myJointFunction,theta=330,col=my3dColors)

# phi controls the "vertical" or colatitude rotation of the plot
persp(x=randVarX,y=randVarY,z=myJointFunction,phi=0,col=my3dColors)
persp(x=randVarX,y=randVarY,z=myJointFunction,phi=70,col=my3dColors)
persp(x=randVarX,y=randVarY,z=myJointFunction,phi=90,col=my3dColors)
persp(x=randVarX,y=randVarY,z=myJointFunction,phi=135,col=my3dColors)
persp(x=randVarX,y=randVarY,z=myJointFunction,phi=45,col=my3dColors)
persp(x=randVarX,y=randVarY,z=myJointFunction,phi=330,col=my3dColors)

