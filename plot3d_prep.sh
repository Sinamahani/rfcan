#Running the functions for the 3D plot
source codes_RF/plot3d-func.sh

# making backup
cp -r inv/plot3d inv/plot3d-backup
rm -r inv/plot3d
mkdir -p inv/plot3d/data

#call the functions
reading_all_files   #reading all layers informtion for each station and extact the error values
graph_picker    #plot the graph for each station and save the graphs and extract the x value
read_tmp_files >> inv/plot3d/optimum_num_layers.csv  # read all tmp files and get the x value
station_list_lat_lon
cp_model_files
#removing unnecessary files
rm inv/plot3d/data/*.csv.png
rm inv/plot3d/data/*.csv.tmp
# making summary files through a python script
python3 codes_RF/plot3dprep.py
echo "Your files are ready for 3d plot"
echo "Warning: if you do not see column depth in your csv files in inv/plot3d/, please run 'python3 codes_RF/plot3dprep.py' again"