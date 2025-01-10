#!/bin/bash

# Prompt the user for input
while true; do
    echo "Enter the parameter to be passed to the script (1 for depth; 2 for vpvs; 3 for ani):"
    read param
    if [ $param -ne 1 ] && [ $param -ne 2 ] && [ $param -ne 3 ]; then
        echo "Invalid parameter. Please enter 1, 2, or 3."
    else
        break
    fi
done

# setting the projection and region
PROJECTION="-JL-85.5219/69.5921/50/79/6i"
REGION="-R-106.002/-65.0417/55.0359/84.1483"



# Using awk to process the CSV file
colm=$((param+3))
awk -v colm=$colm 'BEGIN {FS=","; OFS=","} NR>1 {print $3, $2, $colm, $colm, $1}' hk-hd_org.csv > temp.txt


#plot using gmt
if [ $param -eq 1 ]; then   
    title="Depth"
    # Set variables
    DATA_FILE="temp.txt"   # Path to your data file
    OUTPUT_FILE="MAPS/plot_depth_depth.ps"   # Output file name
    # Plot the data using GMT
    gmt begin $OUTPUT_FILE
    gmt makecpt -Cjet -T24/46/2 -Z
    gmt coast $PROJECTION $REGION -B -Ggrey -Sazure2
    gmt plot temp.txt -Wfaint -i0,1,2,3s0.01 -Scc -C          #-Sc0.5c
    gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l"$title" -By+lkm
    awk 'BEGIN {FS=","} NR>1 {print $3, $2, $1}' hk-hd_org.csv > new_temp.txt
    gmt text new_temp.txt -F+f6p,Helvetica-Bold+jLM -Dj0.1c/0.2c
    gmt end
    rm temp.txt new_temp.txt

elif [ $param -eq 2 ]; then
    title="Vp/Vs"
    # Set variables
    DATA_FILE="temp.txt"   # Path to your data file
    OUTPUT_FILE="MAPS/plot_depth_vpvs.ps"   # Output file name
    # Plot the data using GMT
    gmt begin $OUTPUT_FILE
    gmt makecpt -Cjet -T1.6/2.1/0.01 -Z
    gmt coast $PROJECTION $REGION -B -Ggrey -Sazure2
    gmt plot temp.txt -Wfaint -i0,1,2,3s0.2 -Scc -C     
    gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l"$title" -By+lkm
    awk 'BEGIN {FS=","} NR>1 {print $3, $2, $1}' hk-hd_org.csv > new_temp.txt
    gmt text new_temp.txt -F+f6p,Helvetica-Bold+jLM -Dj0.3c/0.1c
    gmt end
    rm temp.txt new_temp.txt

else
    title="Anisotropy"
    # Set variables
    DATA_FILE="temp.txt"   # Path to your data file
    OUTPUT_FILE="MAPS/plot_depth_$title.ps"   # Output file name (PostScript format)
    # Plot the data using GMT
    gmt begin $OUTPUT_FILE
    gmt coast $PROJECTION $REGION -B -Ggrey -Sazure2
    awk 'BEGIN {FS=","} NR>1 {$6 = (90 - $6 + 360) % 360; print $3, $2, $6, "0.6i"}' hk-hd.csv > ani_temp.txt
    gmt plot ani_temp.txt -Sv0.2i+jc+ea -Gblack -W1.5p -Baf
    gmt plot temp.txt -Sc0.05i -W0.01p -Baf -Gblack
    # gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l$title -By+lkm
    awk 'BEGIN {FS=","} NR>1 {print $3, $2, $1}' hk-hd.csv > new_temp.txt
    gmt text new_temp.txt -F+f6p,Helvetica+jLM -Dj0.1c/0.2c -Gwhite
    gmt end
    rm temp.txt new_temp.txt

fi

