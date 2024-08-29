from pyraysum import prs, Geometry, Model, Control
import numpy as np
import os
import obspy as op
import pandas as pd
from scipy.optimize import dual_annealing, shgo, differential_evolution
from scipy import signal
import matplotlib.pyplot as plt
from scipy.optimize import LinearConstraint, Bounds
import ast
import time

# reading the data
def reading_rfs(keyword: str, filters=(0.04, 0.4), corners = 4, sort=None, t_snr_treshold=-10, 
                path_to_data="DATA/waveforms_list.csv") -> tuple:
    """
    Reading RF data by the name of keyword as station code
    inputs:
    keyword: str
        station code
    t_snr_treshold: float
        signal to noise ratio treshold for transverse component (default 0, means no treshold)

    outputs:
    obser: np.array
        observed data in numpy array format
    baz: list
        corresponding back azimuth
    slow: list
        corresponding slowness
    """
    baz = []
    slow = []
    waveforms_list = pd.read_csv("DATA/waveforms_list.csv")
    filtered_files = waveforms_list[waveforms_list['sta_code']==keyword].copy()
    filtered_files = filtered_files[filtered_files['rf_quality'] == 1].copy()
    path = "DATA/RF/"
    npts = 426 * 2   
    dt = 0.2
    obser = np.zeros((len(filtered_files), npts))
    
    # function to calculate signal to noise ratio for transverse component
    def cal_snr_for_transverse(rft: np.array) -> np.array:
        noise = np.mean(rft[60:210]**2)
        signal = np.mean(rft[210:360]**2)
        return 10 * np.log10(signal/noise)
    
    idx = 0
    for _, row in filtered_files.iterrows():
        wave_path = os.path.join(path, row['file_name']+".pkl")
        st = op.read(wave_path)
        RFR = st.select(channel="RFR")[0].filter('bandpass', freqmin=filters[0], freqmax=filters[1],
                                                 corners=corners, zerophase=True).data
        RFT = st.select(channel="RFT")[0].filter('bandpass', freqmin=filters[0], freqmax=filters[1],
                                                 corners=corners, zerophase=True).data
        #check if the signal to noise ratio is above the treshold
        if cal_snr_for_transverse(RFT) > t_snr_treshold:
            baz.append(st[0].stats.baz)
            slow.append(st[0].stats.slow)
            RFR = RFR #/ np.max(np.abs(RFR))
            RFT = RFT #/ np.max(np.abs(RFT))
            obser[idx, :426] = RFR
            obser[idx, 426:] = RFT
            idx += 1
    obser = obser[:idx, :]
    # sorting based on back azimuth or slowness
    if sort != None:
        zipped = list(zip(obser, baz, slow))
        if sort == "baz":
            zipped.sort(key=lambda x: x[1])
        elif sort == "slow":
            zipped.sort(key=lambda x: x[2])
        obser, baz, slow = zip(*zipped)
    obser = np.array(obser)

    return obser, baz, slow



# reading the model
def read_model(path_to_models, layer):
    """
    Reading the initials bounds and values
    Inputs:
        path_to_models: str: path to the models
        layer: int: layer number
    Outputs:
        bounds: list: bounds of the model
        fixed_vales: list: fixed values of the model
        mask: np.array: mask for the non-fixed values
    """
    bounds = pd.read_csv(os.path.join(path_to_models, "bounds.csv"))
    fixed_vales = pd.read_csv(os.path.join(path_to_models, "fixed_values.csv"))
    bounds = bounds[bounds["layer_code"] == layer].drop(columns=["layer_code"])
    fixed_vales = fixed_vales[fixed_vales["layer_code"] == layer].drop(columns=["layer_code"])
    
   
    bounds = bounds.values.flatten()
    # create a mask for the non-fixed values
    mask = pd.notna(bounds)
    bounds = [ast.literal_eval(i) for i in bounds if str(i) != 'nan']
    return bounds, fixed_vales, mask

def pyraysum_func(baz, slow, thickn, rho, vp, vs, dip, strike,
                  plunge, trend, ani, npts, dt) -> tuple:
    flag = [1 if ani[i]==0 else 0 for i in range(len(ani))]
    model = Model(thickn, rho, vp, vs=vs, strike=strike,
                  dip=dip, plunge=plunge, trend=trend, ani=ani, flag=flag)
    geom = Geometry(baz, slow)
    rc = Control(wvtype="P", rot="RTZ", mults=2, verbose=False,
                 npts=npts*1, dt=dt, align=1, shift=5)
    result = prs.run(model, geom, rc, rf=True)
    result.filter('rfs', 'lowpass', freq=1., zerophase=True, corners=2)
    return result

def predict(model: pd.DataFrame, baz, slow, filters=(0.03, 0.3), corners=4):
    result = pyraysum_func(baz, slow, model["thickn"], model["rho"], model["vp"], model["vs"],
                           model["dip"], model["strike"], model["plunge"], model["trend"],
                           model["ani"], 3*426, 0.2)
    #lower number of samples would be problematic and that is why we produce longer signal and
    # then reduce it
    pred = np.zeros((len(result), 2*426)) 
    pred_r = np.zeros((len(result), 3*426))
    pred_t = np.zeros((len(result), 3*426))

    for idx, i in enumerate(result):
        RFR = i[1][0].filter('bandpass', freqmin=filters[0], freqmax=filters[1], corners=corners,
                             zerophase=True).data
        RFT = i[1][1].filter('bandpass', freqmin=filters[0], freqmax=filters[1], corners=corners,
                             zerophase=True).data
        pred_r[idx, :] = RFR #/ np.max(np.abs(RFR))
        pred_t[idx, :] = RFT #/ np.max(np.abs(RFT))
    #making more samples to reduce the effect of the edges
    pred_r = pred_r[:, 426:2*426]
    pred_t = pred_t[:, 426:2*426]
    pred[:, :426], pred[:, 426:] = pred_r, pred_t
        #reducing the length of the data to 426
    return pred

def cost_func(variables, fixed_values, mask, obser, baz, slow, layer):
    """
    """
    keys = fixed_values.keys()
    fixed_values = fixed_values.values.flatten()
    fixed_values[mask] = variables
    model = fixed_values.reshape(layer, 9)
    model = pd.DataFrame(model, columns=keys)
    pred = predict(model, baz, slow)
    
    # # Mean Squared Error (MSE) --> eval = 4/5
    # loss = np.mean((obser - pred) ** 2)
    
    # # Mean Absolute Error (MAE) --> eval = 3/5
    # loss = np.mean(np.abs(obser - pred))
    
    # # Mean Absolute Percentage Error (MAPE) --> eval = 1/5
    # loss = np.mean(np.abs((obser - pred) / obser)) * 100
    
    # # Log-Cosh Loss --> eval = 3/5
    # loss = np.mean(np.log(np.cosh(obser - pred)))
    
    # # Symmetric Mean Absolute Percentage Error (sMAPE) --> eval = 3/5
    # loss = np.mean(2 * np.abs(pred - obser) / (np.abs(pred) + np.abs(obser))) * 100
    
    # # Cosine Similarity Loss --> eval = 0/5
    # from sklearn.metrics.pairwise import cosine_similarity
    # loss = 1 - cosine_similarity([obser], [pred])[0][0]

    # # Pearson Correlation Coefficient --> eval = 3/5
    # loss = 1 - pearsonr(obser.flatten(), pred.flatten())[0]

    # # Normalized Mean Squared Error (NMSE) --> eval = 4/5
    # loss = np.mean((obser - pred) ** 2) / np.mean(obser ** 2)

    # Correlation Coefficient --> eval = 4/5
    # loss = 1 - np.corrcoef(obser.flatten(), pred.flatten())[0, 1]


    # # Correlation Coefficient --> eval = 5/5
    # corr_coef_obs_and_pred = np.corrcoef(obser.flatten(), pred.flatten())[0, 1]
    # corr_coef_obs = np.corrcoef(obser.flatten(), obser.flatten())[0, 1]
    # corr_coef_pred = np.corrcoef(pred.flatten(), pred.flatten())[0, 1]
    # loss_all = 1 - corr_coef_obs_and_pred/(corr_coef_obs*corr_coef_pred)**0.5

    if model["thickn"].sum() < 51_000 and model["thickn"].sum() > 30_000: #km
        ss = 125 #starting sample
        obser_r = obser[:, ss:426].flatten()/np.max(np.abs(obser[:, 213:213+ss].flatten()))
        pred_r = pred[:, ss:426].flatten()/np.max(np.abs(pred[:, 213:213+ss].flatten()))
        obser_t = obser[:, 426+ss:].flatten()/np.max(np.abs(obser[:, 426+213:426+213+ss].flatten()))
        pred_t = pred[:, 426+ss:].flatten()/np.max(np.abs(pred[:, 426+213:426+213+ss].flatten()))
        
        # correlation coefficient for Radial
        corr_coef_obs_and_pred_r = np.corrcoef(obser_r, pred_r)[0, 1]
        corr_coef_obs_r = np.corrcoef(obser_r, obser_r)[0, 1]
        corr_coef_pred_r = np.corrcoef(pred_r, pred_r)[0, 1]
        loss_r = 1 - corr_coef_obs_and_pred_r/(corr_coef_obs_r*corr_coef_pred_r)**0.5

        # correlation coefficient for Transverse
        corr_coef_obs_and_pred_t = np.corrcoef(obser_t, pred_t)[0, 1]
        corr_coef_obs_t = np.corrcoef(obser_t, obser_t)[0, 1]
        corr_coef_pred_t = np.corrcoef(pred_t, pred_t)[0, 1]
        loss_t = 1 - corr_coef_obs_and_pred_t/(corr_coef_obs_t*corr_coef_pred_t)**0.5
        
        return np.mean([loss_t, 3*loss_r])/4
    else:
        return 999

def optimize_model(bounds, fixed_values, mask, obser, baz, slow, layer, maxiter=1000):
    """To improve your chances of finding a global minimum use higher popsize values,
      with higher mutation and (dithering), but lower recombination values. This has
      the effect of widening the search radius, but slowing convergence."""
    result = differential_evolution(cost_func,
                                    bounds,
                                    args=(fixed_values, mask, obser,
                                          baz, slow, layer),
                                    maxiter=maxiter,
                                    disp=True,
                                    updating="immediate",
                                    strategy="best1bin",
                                    popsize=30,
                                    mutation=0.5,
                                    recombination=0.7
                                    )
    return result
    

def save_inv_summary(results, station, layer, data_size, delta_time):
    summary = {"data size": data_size, "error": results.fun, "number of iterations": results.nit,
               "number of function evaluation": results.nfev, "processing time": delta_time}
    summary_list = [list(summary.keys()), list(summary.values())]
    with open(f"inv/results/{station}/summary_{layer}.txt", "w") as f:
        for i in range(len(summary_list[0])):
            f.write(f"{summary_list[0][i]}: {summary_list[1][i]:.2f}\n")
    return None