PROJECTNAME="Plot3D is running ..."
echo $PROJECTNAME
mkdir -p inv/plot3d/bird-view

function reading_all_files() {
    ls inv/results | while read station;
    do 
    echo 'layer,fun' > inv/plot3d/bird-view/$station.csv;
    for i in {2..7};
            do awk -F',' 'NR > 1 {print $2,$3}' inv/results/$station/flatmoho/*_$i*result.csv | sed 's/ /,/g' >> inv/plot3d/bird-view/$station.csv;
        done;
    done
}

function graph_picker() {
    find inv/plot3d/bird-view -name "*.csv" | while IFS= read -r station; do
        echo $station
        gnuplot -persist <<- EOF
            set title "Plot for $station"
            set xlabel "# of Layers"
            set ylabel "Errors"
            set grid
            set datafile separator ","
            set xrange [2:7]  # Adjust according to your data's expected range
            # set yrange [GPVAL_DATA_Y_MIN:GPVAL_DATA_Y_MAX]  # Adjust accordingly
            plot "$station" every ::1 using 1:2 with linespoints 
            pause mouse keypress
            x = MOUSE_X
            set terminal png
            set output "$station.png"
            replot
            set print "$station.tmp"
            print x
            unset print
            
EOF
pkill -f gnuplot

done
}

function read_tmp_files() {
    find inv/plot3d/bird-view -name "*.tmp" | while IFS= read -r station; do
        x=$(cat $station)
        #extarct the station name
        stationu=$(echo $station | sed -e 's/inv\/plot3d\/bird-view\///' -e 's/\.csv\.tmp$//')
        echo $stationu, $x
        rm $station
    done
}


# call the functions
reading_all_files   #reading all layers informtion for each station and extact the error values
graph_picker    #plot the graph for each station and save the graphs and extract the x value
read_tmp_files >> inv/plot3d/optimum_num_layers.csv  # read all tmp files and get the x value
awk -F ',' '{print $1,",", int($2)}' inv/plot3d/optimum_num_layers.csv > inv/plot3d/optimum_num_layers.csv
