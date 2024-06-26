PROJECTNAME="Plot3D is running ...\n Plot3D is part of RFCAN project.\n Developed by: Sina Sabermahani, GIT (sina.sabermahani@gmail.com)\n last update 2024\n ===================="
echo $PROJECTNAME

function reading_all_files() {
    ls inv/results | while read station;
    do 
    echo 'layer,fun' > inv/plot3d/data/$station.csv;
    for i in {2..5};
            do awk -F',' 'NR > 1 {print $1,$2}' inv/results/$station/*_$i*result.csv | sed 's/ /,/g' >> inv/plot3d/data/$station.csv;
        done;
    done
}

function graph_picker() {
    find inv/plot3d/data -name "*.csv" | while IFS= read -r station; do
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
            replot
            set term png  
            set output "$station.png"     
            print int(x)
            set print "$station.tmp"
            print int(x)
EOF
pkill -f gnuplot

done
}

function read_tmp_files() {
    find inv/plot3d/data -name "*csv.tmp" | while IFS= read -r station; do
        x=$(cat $station)
        #extarct the station name
        station_code=$(echo $station | sed -e 's/inv\/plot3d\/data\///' -e 's/\.csv\.tmp$//')
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
 
function cp_model_files {
    # Copy the model files to a new directory
    # mkdir -p inv/plot3d/data
    echo "Copying model files ..."
    awk -F "," '{print $1, $2}' inv/plot3d/optimum_num_layers.csv | while read station layers; do
        echo $station, $layers
        echo "------------------"
        find "inv/results/$station" -name "$station_*_$layers*_model.csv" | while IFS= read -r model; do
            echo $model
            awk -v station_tmp=$station -F" " '$1==station_tmp {print $2,$3}' inv/plot3d/station_list_lat_lon.csv | while read lat lon; do
                echo $lat, $lon
                lat=$(printf "%.2f\n" "$lat")
                lon=$(printf "%.2f\n" "$lon")
                cp $model inv/plot3d/data/$station%$layers%$lat%$lon%short.csv
            done
            done
        done
}
