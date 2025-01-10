#!/bin/bash
# Inputs
GRD_FILE="/Users/sina/Desktop/RFCAN/rfcan/Results/GRAVITY/dt/GRAV/output.nc"
DATA="hk-hd_org.csv"
# setting the projection and region
PROJECTION="-JL-85.5219/69.5921/50/79/6i"
# PROJECTION="-JM6i"
REGION="-R-106/-66/55/84"

#text data selection
awk 'BEGIN {FS=","} NR>1 {print $3, $2, $1}' $DATA > text_temp.txt

# Using awk to process the CSV file
awk 'BEGIN {FS=","} NR>1 {print $3, $2, $4, $4}' $DATA > temp.txt
TITLE="Depth"
min=`awk 'BEGIN {FS=","} NR>1 {print $4}' $DATA | sort -n | head -1`
max=`awk 'BEGIN {FS=","} NR>1 {print $4}' $DATA | sort -n | tail -1`
step=`echo "($max - $min) / 10" | bc`
colorbar_title="km"


#plot using gmt
title="Gravity Bouguer Anomaly"
# Set variables
DATA_FILE="temp.txt"   # Path to your data file
OUTPUT_FILE="plots/PLOT_$TITLE"   # Output file name

# # Plot the background
gmt begin $OUTPUT_FILE
# background="gray50"
# gmt coast $PROJECTION $REGION -G$background -S$background
gmt makecpt -Cgray -T-150/300/5 -Z
gmt grdimage "$GRD_FILE" $PROJECTION $REGION -B -I+d
gmt colorbar -C -Dx13c/17.5c+w5c/0.5c+jTC+h -Bxaf+l"Bouguer Anomaly" -By+lmGal
gmt plot dt/WK_merged.txt -W2p,black
gmt text dt/WK_labels.txt -F+a0+jML+f13,Helvetica-Bold,black -Dj0.1i/0.1i

# #plotting the data
gmt makecpt -Cjet -T$min/$max/$step -Z -Iz
gmt plot $DATA_FILE $PROJECTION $REGION -Wfaint -B -C -Sc -i0,1,2,3s0.01 
gmt colorbar -C -Dx13c/19c+w5c/0.5c+jTC+h -Bxaf+l$TITLE -By+l$colorbar_title
gmt text text_temp.txt -F+f6p,Helvetica-Bold+jLM -Dj0.4c/0c -Gwhite@50


gmt end

# rm *emp.txt