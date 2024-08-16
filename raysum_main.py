# awk '{FS=","; NR>1} {print $1}' inv/all_stations.csv | xargs -I {} python raysum_main.py {} 1
from pyraysum import Model
from codes_RF.inv_func import *
import numpy as np
import os
import pandas as pd
import matplotlib.pyplot as plt
import time
import sys

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python raysum_main.py <station> <layer>")
        sys.exit(1)
    else:
        # CONTROL PARAMETERS
        layer, station = int(sys.argv[2]), sys.argv[1].upper()
        t_snr_treshold = 4.0 #signal to noise ratio treshold for transverse component
        path_to_data = "DATA/RF"
        path_to_models = "inv/initial"
        os.makedirs(f"inv/results/{station}", exist_ok=True)
        #reading RFs
        obser, baz, slow = reading_rfs(station, t_snr_treshold=t_snr_treshold, sort="baz")
        print("Station:", station,"- Observation Data Size:", obser.shape, "- Number of Layers:", layer )
        # reading the model bounds and fixed values
        bounds, fixed_values, mask = read_model(path_to_models, layer)

        # Geometry plot
        import matplotlib.pyplot as plt
        import numpy as np

        fig, ax = plt.subplots(subplot_kw={'projection': 'polar'}, figsize=(4, 4))
        ax.plot(np.array(baz)*np.pi/180, slow, marker='D', linestyle='', color='black', markersize=5, alpha=0.4, linewidth=0.001)
        ax.set_theta_direction(-1)
        ax.set_theta_zero_location('N')
        ax.grid(True)
        ax.set_title(f"Distibution of events around {station} station", va='top')
        # plt.show()
        fig.savefig(f"inv/results/{station}/geometry.png")

        # Inversion
        start_time = time.time()
        results = optimize_model(bounds, fixed_values, mask, obser, baz, slow, layer, maxiter=5)
        end_time = time.time()
        save_inv_summary(results, station, layer, obser.shape[0], end_time-start_time)

        # Updating the model and then saving the results
        flatten_x = fixed_values.values.flatten()
        flatten_x[mask] = results.x
        flatten_x = flatten_x.reshape(layer, 9)
        flatten_x = pd.DataFrame(flatten_x, columns=fixed_values.columns)
        flatten_x.to_csv(f"inv/results/{station}/model_{station}_{layer}_layer.csv", index=False)

        # Plotting the results (Matrix)
        import matplotlib.pyplot as plt
        time = np.arange(-213/5, 213/5, 5)
        pred_data = predict(flatten_x, baz, slow)
        fig_main = plt.figure(figsize=(20, 7), dpi=300)
        row, col = 2, 2
        y_val = np.int_(np.linspace(0, pred_data.shape[0]-1, 4))

        ###################
        plt.subplot(row, col, 1)
        plt.imshow(pred_data[:,0:426], aspect="auto")
        plt.xticks(np.array([113, 163, 213, 263, 313]), [-10, -5, 0, 5, 10])
        plt.yticks(y_val, [int(baz[y_val[0]]), int(baz[y_val[1]]), 
                        int(baz[y_val[2]]), int(baz[y_val[3]])])
        plt.ylabel("RFR (Pred)")
        ###################
        plt.subplot(row, col, 3)
        plt.imshow(obser[:,0:426], aspect="auto")
        plt.ylabel("RFR (Obser)")
        plt.xlabel("Time (s)")
        plt.xticks(np.array([113, 163, 213, 263, 313]), [-10, -5, 0, 5, 10])
        plt.yticks(y_val, [int(baz[y_val[0]]), int(baz[y_val[1]]), 
                        int(baz[y_val[2]]), int(baz[y_val[3]])])
        ###################
        plt.subplot(row, col, 2)
        plt.imshow(pred_data[:,426:], aspect="auto")
        plt.ylabel("RFT (Pred)")
        plt.xticks(np.array([113, 163, 213, 263, 313]), [-10, -5, 0, 5, 10])
        plt.yticks(y_val, [int(baz[y_val[0]]), int(baz[y_val[1]]), 
                        int(baz[y_val[2]]), int(baz[y_val[3]])])
        ###################
        plt.subplot(row, col, 4)
        plt.imshow(obser[:,426:], aspect="auto")
        plt.ylabel("RFT (Obser)")
        plt.xticks(np.array([113, 163, 213, 263, 313]), [-10, -5, 0, 5, 10])
        plt.yticks(y_val, [int(baz[y_val[0]]), int(baz[y_val[1]]), 
                        int(baz[y_val[2]]), int(baz[y_val[3]])])
        plt.xlabel("Time (s)")

        plt.tight_layout()
        fig_main.savefig(f"inv/results/{station}/imageofwaves_{station}_{layer}_layer.png")
        # plt.show()

        # Plotting the model 
        model = Model(flatten_x["thickn"], flatten_x["rho"], flatten_x["vp"], vs=flatten_x["vs"], strike=flatten_x["strike"], dip=flatten_x["dip"], plunge=flatten_x["plunge"], trend=flatten_x["trend"], ani=flatten_x["ani"])
        fig_model = model.plot(show=False, zmax=70)
        fig_model.savefig(f"inv/results/{station}/model_{station}_{layer}_layer.png")
        plt.close("all")
        fig_model.clf()

        # Plotting the model
        data_length = pred_data.shape[0]
        model = Model(flatten_x["thickn"], flatten_x["rho"], flatten_x["vp"], vs=flatten_x["vs"],
                        strike=flatten_x["strike"], dip=flatten_x["dip"], plunge=flatten_x["plunge"],
                        trend=flatten_x["trend"], ani=flatten_x["ani"],
                        flag=[1 if flatten_x["ani"][i]==0 else 0 for i in range(len(flatten_x["ani"]))])
        fig_model = model.plot()
        # plt.show()
        fig_model.savefig(f"inv/results/{station}/model_{station}_{layer}_layer.png")

        # Plotting the waveforms
        data_length = pred_data.shape[0]
        os.makedirs(f"inv/results/{station}/waveforms", exist_ok=True)

        for i, j, z in zip(pred_data, obser, baz):
            fig, ax = plt.subplots(1, 2, figsize=(16, 2))
            ax[0].plot(i[0:426], label="RFR Pred")
            ax[0].plot(j[0:426], label="RFR Obser")
            ax[0].set_xticks([163, 213, 263, 313, 363, 413], [-5, 0, 5, 10, 15, 20])
            ax[0].legend()
            ax[0].set_xlim(100, 426)

            ax[1].plot(i[426:], label="RFT Pred")
            ax[1].plot(j[426:], label="RFT Obser")
            ax[1].set_xticks([163, 213, 263, 313, 363, 413], [-5, 0, 5, 10, 15, 20])
            ax[1].legend()
            ax[1].set_xlim(100, 426)
            fig.suptitle(f"Station: {station} - Back Azimuth: {z:.0f} ")
            fig.savefig(f"inv/results/{station}/waveforms/layer_{layer}_baz{z:.0f}.png")