#!/bin/bash

awk -F"," 'NR>1 {print $4, $3, $8}' brief.csv >> interpo.csv

#plot interpolated map using gmt

PROJECTION="-JL-85.5219/69.5921/50/79/6i"
REGION="-R-106.002/-65.0417/55.0359/84.1483"

gmt begin interpo png
gmt coast $REGION $PROJECTION -Df -W0.25p -N1/0.25p -A1000 -B5g5 -Glightgray
gmt plot interpo.csv $REGION $PROJECTION -Sc0.1 -Gred
gmt contour interpo.csv -Wthin -C1000 -A5 -B
gmt end show

