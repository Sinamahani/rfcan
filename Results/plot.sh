#!/bin/bash

# Prompt the user for input
while true; do
    echo "Enter the parameter to be passed to the script (4 for depth; 5 for vpvs; 6 for ani):"
    read param
    if [ $param -ne 4 ] && [ $param -ne 5 ] && [ $param -ne 6 ]; then
        echo "Invalid parameter. Please enter 4, 5, or 6."
    else
        break
    fi
done


# Using awk to process the CSV file
awk -v param="$param" 'BEGIN {FS=","} NR>1 {print $3, $2, $param, $param, $1} {OFS=","}' hk-hd.csv > temp.txt

#plot using gmt
if [ $param -eq 4 ]; then
    title="Depth"
    # Set variables
    DATA_FILE="temp.txt"   # Path to your data file
    OUTPUT_FILE="MAPS/plot_depth_$title.ps"   # Output file name (PostScript format)
    REGION="-R-100/-70/50/83"    # Specify the region of interest (adjust as per your data)
    PROJECTION="-JM5i"      # Specify map projection (adjust as per your preference)
    PROJECTION="-JB-85/50/48/52/6i" #Albers projection
    # Plot the data using GMT
    gmt begin $OUTPUT_FILE
    gmt makecpt -Cjet -T24/40/2 -Z
    gmt coast $REGION $PROJECTION -B -Gchocolate -Sazure2
    gmt plot temp.txt -Wfaint -i0,1,2,3s0.01 -Scc -C          #-Sc0.5c
    gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l"Depth" -By+lkm
    awk 'BEGIN {FS=","} NR>1 {print $3, $2, $1}' hk-hd.csv > new_temp.txt
    gmt text new_temp.txt -F+f6p,Helvetica-Bold+jLM -Dj0.1c/0.2c
    gmt end
elif [ $param -eq 5 ]; then
    title="Vp_Vs"
    # Set variables
    DATA_FILE="temp.txt"   # Path to your data file
    OUTPUT_FILE="MAPS/plot_depth_$title.ps"   # Output file name (PostScript format)
    REGION="-R-100/-70/50/83"    # Specify the region of interest (adjust as per your data)
    PROJECTION="-JM5i"      # Specify map projection (adjust as per your preference)
    PROJECTION="-JB-85/50/48/52/6i" #Albers projection
    # Plot the data using GMT
    gmt begin $OUTPUT_FILE
    gmt makecpt -Cjet -T1.6,1.7,1.8,1.9,2.0,2.1
    gmt coast $REGION $PROJECTION -B -Gchocolate -Sazure2
    gmt plot temp.txt -Wfaint -i0,1,2,3s0.2 -Scc -C     
    gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l$title -By+lkm
    awk 'BEGIN {FS=","} NR>1 {print $3, $2, $1}' hk-hd.csv > new_temp.txt
    gmt text new_temp.txt -F+f6p,Helvetica-Bold+jLM -Dj0.3c/0.1c
    gmt end
else
    title="Anisotropy"
    # Set variables
    DATA_FILE="temp.txt"   # Path to your data file
    OUTPUT_FILE="MAPS/plot_depth_$title.ps"   # Output file name (PostScript format)
    REGION="-R-100/-70/50/83"    # Specify the region of interest (adjust as per your data)
    PROJECTION="-JM5i"      # Specify map projection (adjust as per your preference)
    PROJECTION="-JB-85/50/48/52/6i" #Albers projection
    # Plot the data using GMT
    gmt begin $OUTPUT_FILE
    gmt coast $REGION $PROJECTION -B -Gchocolate -Sazure2
    awk 'BEGIN {FS=","} NR>1 {$6 = (90 - $6 + 360) % 360; print $3, $2, $6, "0.6i"}' hk-hd.csv > ani_temp.txt
    gmt plot ani_temp.txt -Sv0.2i -Gyellow -W2p -Baf
    # gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l$title -By+lkm
    awk 'BEGIN {FS=","} NR>1 {print $3, $2, $1}' hk-hd.csv > new_temp.txt
    gmt text new_temp.txt -F+f6p,Helvetica+jLM -Dj0.1c/0.2c -Gwhite
    gmt end
fi

