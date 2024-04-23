function station_list_lat_lon() {
    # Extract the station list with lat and lon and save it to a file
    EX='(NR>1) {print $11, $12, $13}'
    FL='DATA/waveforms_list_org.csv'  # File location
    awk -F, "$EX" $FL | sort | uniq -c > inv/plot3d/station_list_lat_lon.tmp1
    awk -F" " '{print $2, $3, $4}' inv/plot3d/station_list_lat_lon.tmp1 > inv/plot3d/station_list_lat_lon.csv
    rm inv/plot3d/station_list_lat_lon.tmp
} 
 
function cp_model_files() {
    # Copy the model files to a new directory
    mkdir -p inv/plot3d/bird-view
    awk -F "," '{print $1, $2}' inv/plot3d/optimum_num_layers.csv | while read station layers; do
        echo $station, $layers
        echo "------------------"
        find "inv/results/$station/flatmoho" -name "$station_*_$layers*_model.csv" | while IFS= read -r model; do
            echo $model
            awk -v station_tmp=$station -F" " '$1==station_tmp {print $2,$3}' inv/plot3d/station_list_lat_lon.csv | while read lat lon; do
                echo $lat, $lon
                cp $model inv/plot3d/bird-view/$station-$layers-$lat-$lon.csv
            done
            done
        done
}

cp_model_files