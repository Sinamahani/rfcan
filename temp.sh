PROJECTNAME="Plot3D is running ..."
echo $PROJECTNAME

source plot3d-bird.sh
# call the functions
mkdir -p inv/plot3d/bird-view
reading_all_files   #reading all layers informtion for each station and extact the error values
station_list_lat_lon
graph_picker    #plot the graph for each station and save the graphs and extract the x value
read_tmp_files >> inv/plot3d/optimum_num_layers.csv  # read all tmp files and get the x value
awk -F ',' '{print $1,",", int($2)}' inv/plot3d/optimum_num_layers.csv > inv/plot3d/optimum_num_layers.csv
# rm inv/plot3d/bird-view/*.csv
cp_model_files