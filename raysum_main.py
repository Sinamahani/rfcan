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
        layer, station = int(sys.argv[2]), sys.argv[1]
        t_snr_treshold = 6.0 #signal to noise ratio treshold for transverse component
        filters = (0.05, 0.30)
        corners = 4
        path_to_data = "DATA/RF"
        path_to_models = "inv/initial"
        os.makedirs(f"inv/results/{station}", exist_ok=True)
        #reading RFs
        obser, baz, slow = reading_rfs(station, t_snr_treshold=t_snr_treshold, sort="baz", filters=filters, corners=corners)
        # print("Station:", station,"- Observation Data Size:", obser.shape, "- Number of Layers:", layer )
        # reading the model bounds and fixed values
        bounds, fixed_values, mask = read_model(path_to_models, layer)

        # Geometry plot
        fig, ax = plt.subplots(subplot_kw={'projection': 'polar'}, figsize=(5, 5))
        ax.plot(np.array(baz)*np.pi/180, slow, marker='o', linestyle='', color='grey', markersize=15, alpha=0.6, linewidth=1)
        ax.set_theta_direction(-1)
        ax.set_theta_zero_location('N')
        ax.grid(True)
        ax.set_title(f"Distibution of events around {station} station", va='top')
        # plt.show()
        fig.savefig(f"inv/results/{station}/geometry.png")
        plt.close("all")

        # Inversion
        start_time = time.time()
        results = optimize_model(bounds, fixed_values, mask, obser, baz, slow, 
                                 layer, maxiter=10)
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
        fig_main = plt.figure(figsize=(25, 12), dpi=300)
        row, col = 4, 2
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
        ###################
        plt.subplot(row, col, 5)
        plt.arrow(0, 0, 0, -1, head_width=0.02, head_length=0.3, fc='k', ec='k')
        plt.xlim(-0.2, 0.2)
        plt.ylim(-2, 1)
        plt.axis('off')
        plt.subplot(row, col, 6)
        plt.arrow(0, 0, 0, -1, head_width=0.02, head_length=0.3, fc='k', ec='k')
        plt.xlim(-0.2, 0.2)
        plt.ylim(-2, 1)
        plt.axis('off')
        ###################
        plt.subplot(row, col, 7)
        plt.imshow(pred_data[:,0:426]-obser[:,0:426], aspect="auto")
        plt.ylabel("RFR - Residual")
        plt.xticks(np.array([113, 163, 213, 263, 313]), [-10, -5, 0, 5, 10])
        plt.yticks(y_val, [int(baz[y_val[0]]), int(baz[y_val[1]]), 
                        int(baz[y_val[2]]), int(baz[y_val[3]])])
        plt.xlabel("Time (s)")
        ###################
        plt.subplot(row, col, 8)
        plt.imshow(pred_data[:,426:]-obser[:,426:], aspect="auto")
        plt.ylabel("RFT - Residual")
        plt.xticks(np.array([113, 163, 213, 263, 313]), [-10, -5, 0, 5, 10])
        plt.yticks(y_val, [int(baz[y_val[0]]), int(baz[y_val[1]]), 
                        int(baz[y_val[2]]), int(baz[y_val[3]])])
        plt.xlabel("Time (s)")
        ###################
        plt.tight_layout()
        fig_main.savefig(f"inv/results/{station}/imageofwaves_{station}_{layer}_layer.png")
        plt.close("all")

        # Plotting the model 
        model = Model(flatten_x["thickn"], flatten_x["rho"], flatten_x["vp"], vs=flatten_x["vs"], strike=flatten_x["strike"], dip=flatten_x["dip"], plunge=flatten_x["plunge"], trend=flatten_x["trend"], ani=flatten_x["ani"])
        fig_model = model.plot(show=False, zmax=70)
        fig_model.savefig(f"inv/results/{station}/model_{station}_{layer}_layer.png")
        plt.close("all")
        fig_model.clf()

        # Plotting the RFs
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
        plt.close("all")