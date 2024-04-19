PROJECTNAME="Plot3D is running ..."
echo $PROJECTNAME
mkdir -p inv/plot3d/bird-view

ls inv/results | while read station;
    do 
    echo 'layer,fun' > inv/plot3d/bird-view/$station.csv;
    for i in {2..7};
            do awk -F',' 'NR > 1 {print $2,$3}' inv/results/$station/flatmoho/*_$i*result.csv | sed 's/ /,/g' >> inv/plot3d/bird-view/$station.csv;
        done;
    done

# Install gnuplot package if not already installed
if ! command -v gnuplot &> /dev/null; then
    sudo apt-get install gnuplot -y
fi

find inv/plot3d/bird-view -name "*.csv" | while IFS= read -r station; do
head $station
    # Use gnuplot to plot the data
gnuplot -persist <<- EOF
        set title "Plot for $station"
        set xlabel "X-axis"
        set ylabel "Y-axis"
        set grid
        set datafile separator ","
        set xrange [2:7]  # Adjust according to your data's expected range
        set yrange [GPVAL_DATA_Y_MIN:GPVAL_DATA_Y_MAX]  # Adjust accordingly
        plot "$station" every ::1 using 1:2 with lines title "Line Plot"
        set terminal png
        set output "$station.png"


EOF
    # Optional: Prompt the user to press enter before continuing with the next file
read -p "Press enter to continue";

done