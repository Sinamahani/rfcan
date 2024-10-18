#!/bin/bash
# Inputs
DATA="comp-selected.csv"
# setting the projection and region
PROJECTION="-JL-85.5219/69.5921/50/79/6i"
# PROJECTION="-JM6i"
REGION="-R-106/-66/55/84"

# #text data selection
# # Using awk to process the CSV file and extract the columns we need
awk 'BEGIN {FS=","} NR>1 {print $4, $3, $5}' $DATA > temp.txt
# Using awk to process the CSV file and extract the columns we need and filter the data based on n=1
awk 'BEGIN {FS=","} NR>1 {gsub(/"/, "", $9); if ($9 == 1) print $4, $3, $5}' $DATA > temp-selected.txt
awk 'BEGIN {FS=","} NR>1 {gsub(/"/, "", $9); if ($9 == 1) print $4, $3, $1}' $DATA > text-selected.txt


#plot using gmt
DATA_FILE="temp.txt"   # Path to your data file
OUTPUT_FILE="plots/PLOT_sina"   # Output file name (PostScript format)

# Plot the background
gmt begin $OUTPUT_FILE
background="gray50"
gmt coast $PROJECTION $REGION -G$background
gmt makecpt -Cturbo -T-150/300/5 -Z
gmt plot dt/WK_merged.txt -W2p,black
gmt text dt/WK_labels.txt -F+a0+jML+f13,Helvetica-Bold,black -Dj0.1i/0.1i

#plotting the data
gmt plot $DATA_FILE $PROJECTION $REGION -Wfaint -B -Sc0.3c -Gred -I+c0.1p -t70
gmt text text-selected.txt -F+f6p,Helvetica-Bold+jLM -Dj0.2c/0c
gmt plot temp-selected.txt $PROJECTION $REGION -Wfaint -B -Sc0.3c -Gred -I+c0.1p -t0


gmt end

rm *emp.txt