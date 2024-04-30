#Running the functions for the 3D plot
source codes_RF/plot3d-func.sh
read -p "Enter the model you want to plot (options are 'flatmoho', 'dipmoho' or 'animoho'): " model

#making backup
cp -r inv/plot3d inv/plot3d-backup
rm -r inv/plot3d
mkdir inv/plot3d

#call the functions
mkdir -p inv/plot3d/bird-view
reading_all_files   #reading all layers informtion for each station and extact the error values
graph_picker    #plot the graph for each station and save the graphs and extract the x value
read_tmp_files >> inv/plot3d/optimum_num_layers.csv  # read all tmp files and get the x value
rm inv/plot3d/bird-view/*.csv
station_list_lat_lon
cp_model_files $model
mkdir inv/plot3d/$model | mv inv/plot3d/bird-view inv/plot3d/$model
python3 codes_RF/plot3dprep.py
echo "Your files are ready for 3d plot"
echo "Warning: if you do not see column depth in your csv files in inv/plot3d/$model/bird-view, please run python3 codes_RF/plot3dprep.py again"