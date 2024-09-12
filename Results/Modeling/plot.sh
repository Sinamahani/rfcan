#!/bin/bash

# setting the projection and region
PROJECTION="-JL-85.5219/69.5921/50/79/6i"
REGION="-R-106.002/-65.0417/55.0359/84.1483"

# Using awk to process the CSV file
awk 'BEGIN {FS=","} NR>1 {print $4, $3, $8/1000, $8/1000} {OFS=","}' brief.csv > temp_moho.txt
awk 'BEGIN {FS=","} NR>1 {print $4, $3, $13, $13} {OFS=","}' brief.csv > temp_vpvs.txt
awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") {print $4, $3, $14, ($14+3)}} {OFS=","}' brief.csv > temp_ani.txt
awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") {print $4, $3, $15, $15+3}} {OFS=","}' brief.csv > temp_dip.txt

awk 'BEGIN {FS=","} NR>1 {print $4, $3, $1}' brief.csv > temp_text_all.txt
awk 'BEGIN {FS=","} NR>1 {if ($6=="GOOD") {print $4, $3, $1}}' brief.csv > temp_text_selected.txt

# Moho depth
DATA_FILE="temp_moho.txt"   # Path to your data file
OUTPUT_FILE="Depth"   # Output file name (PostScript format)
# Plot the data using GMT
# Plot the data using GMT
gmt begin $OUTPUT_FILE
gmt makecpt -Cjet -T30/42/2 -Z
gmt coast $PROJECTION $REGION -B -Ggrey -Sazure2
gmt plot $DATA_FILE -Wfaint  -Scc -C -i0,1,2,3s0.01
gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l$OUTPUT_FILE -By+lkm
gmt text temp_text_all.txt -F+f6p,Helvetica-Bold+jLM -Dj0.1c/0.2c
gmt end

# Vp/Vs
DATA_FILE="temp_vpvs.txt"   # Path to your data file
OUTPUT_FILE="VpVs"   # Output file name (PostScript format)
TITLE="Vp/Vs"
# Plot the data using GMT
gmt begin $OUTPUT_FILE
    gmt makecpt -Cjet -T1.6,1.7,1.8,1.9,2.0,2.1
    gmt coast $PROJECTION $REGION -B -Ggrey -Sazure2
    gmt plot $DATA_FILE -Wfaint -i0,1,2,3s0.2 -Scc -C     
    gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l$TITLE -By
    gmt text temp_text_all.txt -F+f6p,Helvetica-Bold+jLM -Dj0.3c/0.1c
gmt end

# Anisotropy
DATA_FILE="temp_ani.txt"   # Path to your data file
OUTPUT_FILE="Anisotropy"   # Output file name (PostScript format)
TITLE="Anisotropy"
# Plot the data using GMT
gmt begin $OUTPUT_FILE
    gmt makecpt -Cjet -T0,1.5,3,4.5,6,7.5
    gmt coast $PROJECTION $REGION -B -Ggrey -Sazure2
    gmt plot $DATA_FILE -Wfaint -i0,1,2,3s0.08 -Scc -C     
    gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l$TITLE -By+l%
    gmt text temp_text_selected.txt -F+f6p,Helvetica-Bold+jLM -Dj0.3c/0.1c
gmt end

# Dip
DATA_FILE="temp_dip.txt"   # Path to your data file
OUTPUT_FILE="Dip"   # Output file name (PostScript format)
TITLE="Dip"
# Plot the data using GMT
gmt begin $OUTPUT_FILE
    gmt makecpt -Cjet -T0,1,2,3,4,5,6
    gmt coast $PROJECTION $REGION -B -Ggrey -Sazure2
    gmt plot $DATA_FILE -Wfaint -i0,1,2,3s0.1 -Scc -C     
    gmt colorbar -C -Dx8c/2c+w12c/0.5c+jTC+h -Bxaf+l$TITLE -By+lDegree
    gmt text temp_text_selected.txt -F+f6p,Helvetica-Bold+jLM -Dj0.3c/0.1c
gmt end


rm temp*