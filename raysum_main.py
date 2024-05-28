#awk -F"," 'NR > 1 {print $1}' inv/all_stations.csv | while IFS= read -r i; do for j in {2..5}; do python raysum_main.py "$j" "$i"; done; done
from pyraysum import prs, Geometry, Model, Control
import numpy as np
import os
import obspy as op
import pandas as pd
from numpy.linalg import norm
from scipy.optimize import dual_annealing, rosen, shgo, differential_evolution
from scipy import signal
import matplotlib.pyplot as plt
import sys
from scipy.optimize import LinearConstraint
import ast
from codes_RF.inv_func import *

argv = sys.argv
  
#controller
layers = int(argv[1])
station = argv[2]
obser_data, baz, slow= reading_rfs(station)
if 0:
        limit = 6
        obser_data, baz, slow = obser_data[:limit], baz[:limit], slow[:limit]
print(f"{'='*30}\nStation: {station}\nNumber of Layers: {layers}\nNumber of RFs: {len(obser_data)}\nThe program is running...")
geom = {"baz": baz,
        "slow": slow}
initial_model, bounds = read_layers(layers=layers, range_percentage=0.35)
# print("Initial Model")
# print(initial_model)

# create the appropriate directory
if not os.path.exists(f"inv/results/"):
        os.mkdir(f"inv/results/")
# create the appropriate directory
if not os.path.exists(f"inv/results/{station}/"):
        os.mkdir(f"inv/results/{station}/")

#Modeling the data
# results = do_inversion(cost_func, bounds, initial_model, geom, obser_data, layers, method="diff_evol")
results = do_inversion(cost_func, bounds, initial_model, geom, obser_data, layers, 
                       verbose=False, norm_method = "individual", method="diff", tr_contrib=0.0)
#saving the new model
updated_model = initial_model.copy()
depth = results.x[0:layers-1]
vp = results.x[layers-1:2*layers-1]
vs = results.x[2*layers-1:3*layers-1]
rho = results.x[3*layers-1:4*layers-1]
dip = results.x[4*layers-1:5*layers-1]
strike = results.x[5*layers-1:6*layers-1]
plunge = results.x[6*layers-1:7*layers-1]
trend = results.x[7*layers-1:8*layers-1]
ani = results.x[8*layers-1:9*layers-1]
updated_model

#saving the new model
updated_model.to_csv(f"inv/results/{station}/{station}_layers_{layers}_updated_model.csv", index=False)
# Evaluation
print_and_save(results, station, layers)
# updated model is a global variable
pred_data, model = predict(geom, updated_model)
# !!! for saving the plot, I have changed the prs.py file to return the fig in the plot() function. Also add a keyword argument to the plot() function named "show" to show the plot or not.
fig = model.plot(zmax=65, show=False)
fig.savefig(f"inv/results/{station}/{station}_layers_{layers}_updated_model.png")

pred_data, model = predict(geom, updated_model)
pred_stacked = np.mean(pred_data, axis=0)   #stacking the prediction data
obser_stacked = np.mean(obser_data, axis=0) #stacking the observation data
fig = plot_rfr_and_rft(pred_stacked, obser_stacked)
fig.savefig(f"inv/results/{station}/{station}_layers_{layers}_rfr_rft.png")

# stack plot
fig = plt.figure(figsize=(15,3))
plt.plot(pred_stacked[190:], label="Predicted", linestyle="--", color="red")
plt.plot(obser_stacked[190:], label="Real", color="black")
plt.legend()
fig.savefig(f"inv/results/{station}/{station}_layers_{layers}_stacked.png")
plt.close()

#Matrix visualization
fig, ax = plt.subplots(nrows=3, ncols=1, figsize=(15, 5))
fig.tight_layout()
ax[0].imshow(obser_data, aspect="auto", cmap="jet")
ax[0].set_title("Observed Data")
ax[1].imshow(pred_data, aspect="auto", cmap="jet")
ax[1].set_title("Predicted Data")
ax[2].imshow(np.subtract(obser_data, pred_data), aspect="auto", cmap="jet")
ax[2].set_title("Difference")
fig.savefig(f"inv/results/{station}/{station}_layers_{layers}_matrix.png")


# # Plotting waveforms
for wave_num in range(len(pred_data)):
    data_pred, _ = predict(geom, updated_model)
    slow_baz = f" Slow= {slow[wave_num]:.2f}     Baz= {baz[wave_num]:.2f} "
    fig = plot_rfr_and_rft(data_pred[wave_num,:], obser_data[wave_num,:], text=slow_baz)
    # check if the directory exists
    if not os.path.exists(f"inv/results/{station}/wfs/"):
        os.mkdir(f"inv/results/{station}/wfs/")
    fig.savefig(f"inv/results/{station}/wfs/{station}_layers_{layers}_wave_{wave_num}.png")
    plt.close()