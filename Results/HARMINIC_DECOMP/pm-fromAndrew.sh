#!/bin/sh

# I like to put filenames in variables (so I don't misspell them later)
infile='hk-hd.csv'

# Projection and plot range (using Lambert conic)
proj='-JL-85/69/59/79/5i'
range='-R-100/-70/54/84'

gmt begin harmonic_directions
  # plot topography (no real need to download separately). I used the -t option to make this layer
  # 50% transparent to fade it a bit, so the lines plotted on top show up better
  gmt grdimage @earth_relief_02m.grd $proj $range -Cgeo -I+d -t50
  # plot coastlines and add plot frame
  gmt coast -Dh -A1000 -W1p,black -BWenS -B5
  # plot two-lobed directions as azimuths. Note how I use a pipe instead of a file. The
  # gmt plot command expects lon,lat,azimuth,length. The "+e" means put an arrowhead at
  # the end
  tail +2 $infile | awk -F, '{print $3,$2,90-$8,1.2i}' | gmt plot -SV0.2i+jc+ea -W2.5p,black
  # Now plot the four-lobed directions (without arrowheads)
  tail +2 $infile | awk -F, '{print $3,$2,90-$9,1.2i}' | gmt plot -SV0.2i+jc -W1.5p,darkred
  # Add a dot for each station
  tail +2 $infile | awk -F, '{print $3,$2}' | gmt plot -Sc0.05i -Gwhite -W0.5p,black
gmt end show

