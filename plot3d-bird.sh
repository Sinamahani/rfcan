PROJECTNAME="Plot3D is running ..."
echo $PROJECTNAME

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
            set term png             
            set output "$station.png"
            replot
            print int(x)
            set print "$station.tmp"
            print int(x)
EOF
pkill -f gnuplot

done
}

function read_tmp_files() {
    find inv/plot3d/bird-view -name "*csv.tmp" | while IFS= read -r station; do
        x=$(cat $station)
        #extarct the station name
        station_code=$(echo $station | sed -e 's/inv\/plot3d\/bird-view\///' -e 's/\.csv\.tmp$//')
        echo $station_code, $x
    done
}

function station_list_lat_lon() {
    # Extract the station list with lat and lon and save it to a file
    EX='(NR>1) {print $11, $12, $13}'
    FL='DATA/waveforms_list_org.csv'  # File location
    awk -F, "$EX" $FL | sort | uniq -c > inv/plot3d/station_list_lat_lon.tmp
    awk -F" " '{print $2, $3, $4}' inv/plot3d/station_list_lat_lon.tmp > inv/plot3d/station_list_lat_lon.csv
    rm inv/plot3d/station_list_lat_lon.tmp
} 
 
function cp_model_files() {
    # Copy the model files to a new directory
    mkdir -p inv/plot3d/bird-view
    awk -F "," '{print $1, $2}' inv/plot3d/optimum_num_layers.csv | while read station layers; do
        echo $station, $layers
        echo "------------------"
        find "inv/results/$station/$1" -name "$station_*_$layers*_model.csv" | while IFS= read -r model; do
            echo $model
            awk -v station_tmp=$station -F" " '$1==station_tmp {print $2,$3}' inv/plot3d/station_list_lat_lon.csv | while read lat lon; do
                echo $lat, $lon
                cp $model inv/plot3d/bird-view/$station-$layers.csv
            done
            done
        done
}



# call the functions
# mkdir -p inv/plot3d/bird-view
# reading_all_files   #reading all layers informtion for each station and extact the error values
# graph_picker    #plot the graph for each station and save the graphs and extract the x value
# read_tmp_files >> inv/plot3d/optimum_num_layers.csv  # read all tmp files and get the x value
# rm inv/plot3d/bird-view/*.*
# station_list_lat_lon
# cp_model_files
