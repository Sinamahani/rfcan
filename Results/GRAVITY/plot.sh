#!/bin/bash
# Inputs
GRD_FILE="DGRAV_fixed.nc"
DATA="Brief.csv"
# setting the projection and region
PROJECTION="-JL-85.5219/69.5921/50/79/6i"
REGION="-R-106/-66/55/84"

echo "Enter the number of plot you want to make:
1.Depth
2.Vp
3.Vs
4.VpVs
5.Anisotropy
Enter the number: "
inputCondition=true
while $inputCondition; do
    read input
    if [ "$input" == "1" ] || [ "$input" == "2" ] || [ "$input" == "3" ] || [ "$input" == "4" ] || [ "$input" == "5" ]; then
        inputCondition=false
    else
        echo "Invalid input.
        Please enter a valid number: "
    fi
done


#text data selection
awk 'BEGIN {FS=","} NR>1 {print $4, $3, $1}' $DATA > text_temp.txt

# Using awk to process the CSV file
if [ "$input" == "1" ]; then
    awk 'BEGIN {FS=","} NR>1 {print $4, $3, $8, $8/1000, $8/1000, $1}' $DATA > temp.txt
    TITLE="Depth"
    min=`awk 'BEGIN {FS=","} NR>1 {print $8}' $DATA | sort -n | head -1`
    max=`awk 'BEGIN {FS=","} NR>1 {print $8+9}' $DATA | sort -n | tail -1`
    step=`echo "($max - $min) / 10" | bc`
    colorbar_title="km"
elif [ "$input" == "2" ]; then
    awk 'BEGIN {FS=","} NR>1 {print $4, $3, $11, $11/180, $11, $1}' $DATA > temp.txt
    TITLE="Vp"
    min=`awk 'BEGIN {FS=","} NR>1 {print $11}' $DATA | sort -n | head -1`
    max=`awk 'BEGIN {FS=","} NR>1 {print $11+9}' $DATA | sort -n | tail -1`
    step=`echo "($max - $min) / 10" | bc`
    colorbar_title="km/s"
elif [ "$input" == "3" ]; then
    awk 'BEGIN {FS=","} NR>1 {print $4, $3, $12, $12/100, $12, $1}' $DATA > temp.txt
    TITLE="Vs"
    colorbar_title="km/s"
    min=`awk 'BEGIN {FS=","} NR>1 {print $12-1}' $DATA | sort -n | head -1`
    max=`awk 'BEGIN {FS=","} NR>1 {print $12+9}' $DATA | sort -n | tail -1`
    max=`echo "scale=2; $max+10" | bc`
    step=`echo "($max - $min) / 10" | bc`
elif [ "$input" == "4" ]; then
    awk 'BEGIN {FS=","} NR>1 {print $4, $3, $13, $13*20, $13, $1}' $DATA > temp.txt
    TITLE="VpVs"
    colorbar_title="-"
    min=`awk 'BEGIN {FS=","} NR>1 {print $13}' $DATA | sort -n | head -1`
    max=`awk 'BEGIN {FS=","} NR>1 {print $13}' $DATA | sort -n | tail -1`
    step=`echo "scale=2; ($max - $min) / 2" | bc`
elif [ "$input" == "5" ]; then
    awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") print $4, $3, $14, $14*15+5, $14*15+5, $1}' $DATA > temp.txt
    awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") print $4, $3, $1}' $DATA > text_temp.txt
    TITLE="Anisotropy"
    colorbar_title="%"
    min=`awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") print $14}' $DATA | sort -n | head -1`
    max=`awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") print $14}' $DATA | sort -n | tail -1`
    step=`echo "scale=2; ($max - $min) / 2" | bc`
# elif [ "$1" == "6" ] || [ "$1" == "dip" ]; then
#     awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") print $4, $3, $16, $15*50, $15*50, $1}' $DATA > temp.txt
#     awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") print $4, $3, $1}' $DATA > text_temp.txt
#     TITLE="Dip"
#     colorbar_title="Azimuthal Degree"
#     min=`awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") print $16}' $DATA | sort -n | head -1`
#     max=`awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") print $16}' $DATA | sort -n | tail -1`
#     step=`echo "scale=2; ($max - $min) / 10" | bc`
#     echo $min $max $step
fi

#plot using gmt
title="Gravity Bouguer Anomaly"
# Set variables
DATA_FILE="temp.txt"   # Path to your data file
OUTPUT_FILE="plots/PLOT_$TITLE"   # Output file name (PostScript format)

# Plot the background
gmt begin $OUTPUT_FILE
background="gray50"
gmt coast $PROJECTION $REGION -G$background -S$background
gmt makecpt -Cpolar -T-350/200/10 -Z
# gmt grd2cpt $GRD_FILE -Cglobe
gmt grdimage $GRD_FILE $PROJECTION $REGION -B
gmt colorbar -C -Dx15c/13c+w5c/0.5c+jTC+h -Bxaf+l"Bouguer Anomaly" -By+lmGal
gmt plot WK_bounds/WK_merged.txt -W2p,black
gmt text WK_bounds/WK_labels.txt -F+a0+jML+f13,Helvetica-Bold,black -Dj0.1i/0.1i

#plotiing the data
gmt makecpt -Ccool -T$min/$max/$step -Z -Iz
gmt plot $DATA_FILE $PROJECTION $REGION -Wfaint -B -C -Sc -i0,1,2,3s0.01 
gmt colorbar -C -Dx15c/16c+w5c/0.5c+jTC+h -Bxaf+l$TITLE -By+l$colorbar_title
gmt text text_temp.txt -F+f6p,Helvetica-Bold+jLM -Dj0.4c/0c


gmt end

rm *emp.txt