#!/bin/sh

# Example of using GMT to contour a data set from a text file


# Setting some shell variables (so that the values to adjust are all at the top)
# raw datafile (this is the inoput)
data='hk-hd.csv'
# temporary file with reformatted data (generated when the script runs)
temp='moho_temp.txt'
# range (lonmin/lonmax/latmin/latmax)
range='-R-100/-70/55/85'
# map projection (Lambert conic centred 70N,85W with std. parallels 60N, 80N) & width (6 inches)
proj='-JL-85/70/60/80/6i'

# -- actual GMT commands start here -- "gmt begin" names the output file.
# -- remove individual lines to eliminate map layers
gmt begin moho_depth pdf

# The next few commands build the base map (with topography and coastlines) on which we plot'
# the data file:
# map frame -- all four axes are drawn, only W and S annotated. 10 degree x spacing, 5 degree y
gmt basemap $proj $range -BWenS -Bx10 -By5
# topography -- this reads a remote data set (GEBCO topography, 1 arc minute version)
# the command reads a grid file, trims to the given range, then converts to an image using
# a colour map (in this case the "geo" colourmap)
gmt grdimage @earth_gebco_01m $range -Cgeo
# coastlines -- 1 pt, black lines, use low resolution version, suppress anything smaller than 4000km^3,
# fill lakes in with white
gmt coast -W1p,black -Dl -A4000 -Cwhite


# Now we'll plot our data. The file format is wrong, so we'll use the "tail" command
# to start at line 2 (skipping header), then use awk to pull out the columns we want
# (4, 3, and 6 -- lon, lat, dt) and dump the result into a temporary file.
awk -F',' 'NR > 1 {printf "%f %f %f %f\n",$3,$2,$4,$4}' $data > $temp
# Make a color map for these data (using the "plasma" standard map), continuous, from 0 to 1.5 s
gmt makecpt -Cplasma -Z -T30/50/4 -N
# To make contours, we need to interpolate the data that fall within the map frame. We'll
# use GMT's "surface" command, which fits a smooth surface to data points, to do this.
# Here the input is the temporary file, the output is the grid file, the spacing is 0.2 degree,
# and we restrict the grid range to the map area. The preprocessing step is "blockmedian", which
# gives a better result by taking the median within each grid cell. The -T option in surface controls
# the "tension" on the surface
# gmt blockmedian $temp -I0.2 $range | gmt surface -G$grid -I0.2 $range -T0.2
# Next, let's plot the measurement locations shaded by split time, using circles 0.1 inch across
# coloured using our colourmap, with an outline 0.5 points thick
gmt plot $temp -Sc0.1i -C -W0.5p,black
# Add a colourbar at middle right of the plot, with a label
gmt colorbar -DJMR -B+l"Depth (km)"

# finalizes the PDF file, the "show" option displays it
gmt end