from pyraysum import prs, Geometry, Model, Control
import numpy as np
import os
import obspy as op
import pandas as pd
from scipy.optimize import dual_annealing, shgo, differential_evolution
import matplotlib.pyplot as plt
from scipy.optimize import LinearConstraint
import ast

def read_layers(layers=2, **kwargs) -> pd.DataFrame:
    models = pd.read_csv("inv/initial/all_layers.csv")
    models = models[models["layer_code"] == layers]
    selected_model = models[["thickn", "rho", "vp", "vs", "dip", "strike", "plunge", "trend", "ani"]]
   
    # bounds
    bounds_from_file = pd.read_csv("inv/initial/bounds.csv")
    df = bounds_from_file[bounds_from_file["layer_code"] == layers]
    df = df.drop(columns=["layer_code"])
    bounds = []
    for key in df.keys():
        for row in df[key]:
            each_bound = ast.literal_eval(row) #turn string to tuple
            each_bound = (float(each_bound[0]), int(each_bound[1]))
            bounds.append(ast.literal_eval(row))
    bounds = [i for i in bounds if i != (0, 0)]
    return selected_model.reset_index(), bounds

def cal_snr_for_transverse(rft: np.array) -> np.array:
    """
    Calculate the signal to noise based on closest 100 samples to P-wave (centered at 213th sample)
    """
    noise = rft[:213]
    signal = rft[213:]
    return np.sum(np.square(signal)) / np.sum(np.square(noise))


def reading_rfs(keyword: str, t_snr_treshold=0) -> list:
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

    idx = 0
    for _, row in filtered_files.iterrows():
        wave_path = os.path.join(path, row['file_name']+".pkl")
        st = op.read(wave_path)
        RFR = st.select(channel="RFR")[0].filter('bandpass', freqmin=0.05, freqmax=0.3, corners=2, zerophase=True).data
        RFT = st.select(channel="RFT")[0].filter('bandpass', freqmin=0.05, freqmax=0.3, corners=2, zerophase=True).data
        #check if the signal to noise ratio is above the treshold
        if cal_snr_for_transverse(RFT) > t_snr_treshold:
            baz.append(st[0].stats.baz)
            slow.append(st[0].stats.slow)
            RFR = RFR / np.max(np.abs(RFR))
            RFT = RFT / np.max(np.abs(RFT))
            obser[idx, :426] = RFR
            obser[idx, 426:] = RFT
            idx += 1
    obser = obser[:idx, :]
    return obser, baz, slow


def pyraysum_func(baz, slow, thickn, rho, vp, vs, dip, strike, plunge, trend, ani, npts, dt) -> tuple:
    model = Model(thickn, rho, vp, vs=vs, strike=strike, dip=dip, plunge=plunge, trend=trend, ani=ani)
    geom = Geometry(baz, slow)
    rc = Control(wvtype="P", rot="RTZ", mults=2, verbose=False, npts=npts*1, dt=dt, align=1, shift=5)
    result = prs.run(model, geom, rc, rf=True)
    result.filter('rfs', 'lowpass', freq=1., zerophase=True, corners=2)
    return model, geom, result


def predict(geom, model):
    model, _, result = pyraysum_func(geom["baz"], geom["slow"], model["thickn"], model["rho"], model["vp"], model["vs"], model["dip"],
                                     model["strike"], model["plunge"], model["trend"], model["ani"], 3*426, 0.2)
    #lower number of samples would be problematic and that is why we produce longer signal and then reduce it
    pred = np.zeros((len(result), 2*426)) 
    pred_r = np.zeros((len(result), 3*426))
    pred_t = np.zeros((len(result), 3*426))

    for idx, i in enumerate(result):
        RFR = i[1][0].filter('bandpass', freqmin=0.05, freqmax=0.3, corners=2, zerophase=True).data
        RFT = i[1][1].filter('bandpass', freqmin=0.05, freqmax=0.3, corners=2, zerophase=True).data
        pred_r[idx, :] = RFR / np.max(np.abs(RFR))
        pred_t[idx, :] = RFT / np.max(np.abs(RFT))
    pred_r = pred_r[:, 426:2*426]
    pred_t = pred_t[:, 426:2*426]
    pred[:, :426], pred[:, 426:] = pred_r, pred_t
        #reducing the length of the data to 426
    return pred, model


def cost_func(x, model, geom, obser_rf, layers, norm_method, t_contrib=0.5):
    model["dip"] = model["dip"].astype(float)
    model["strike"] = model["strike"].astype(float)
    model["plunge"] = model["plunge"].astype(float)
    model["trend"] = model["trend"].astype(float)
    model["ani"] = model["ani"].astype(float)

    if layers == 2:               # 2-layer model
        model.loc[0, "thickn"] = int(x[0])
        model.loc[1, "thickn"] = 0
        model.loc[[0, 1], "rho"] = np.int_(x[1:3])
        model.loc[[0, 1], "vp"] = np.int_(x[3:5])
        model.loc[[0, 1], "vs"] = np.int_(x[5:7])
        try:
            model.loc[0, "dip"] = 0
            model.loc[1, "dip"] = x[7]
            model.loc[0, "strike"] = 0
            model.loc[1, "strike"] = x[8]
            model.loc[[0, 1], "plunge"] = x[9:11]
            model.loc[[0, 1], "trend"] = x[11:13]
            model.loc[[0, 1], "ani"] = x[13:15]
        except:
            pass
    elif layers == 3:             # 3-layer model
        model.loc[[0, 1], "thickn"] = np.int_(x[0:2])
        model.loc[2, "thickn"] = 0
        model.loc[[0, 1, 2], "rho"] = np.int_(x[2:5])
        model.loc[[0, 1, 2], "vp"] = np.int_(x[5:8])
        model.loc[[0, 1, 2], "vs"] = np.int_(x[8:11])
        try:
            model.loc[0, "dip"] = 0
            model.loc[[1, 2], "dip"] = x[11:13]
            model.loc[0, "strike"] = 0
            model.loc[[1, 2], "strike"] = x[13:15]
            model.loc[[0, 1, 2], "plunge"] = x[15:18]
            model.loc[[0, 1, 2], "trend"] = x[18:21]
            model.loc[[0, 1, 2], "ani"] = x[21:24]
        except:
            pass
    elif layers == 4:             # 4-layer model
        model.loc[[0, 1, 2], "thickn"] = np.int_(x[0:3])
        model.loc[3, "thickn"] = 0
        model.loc[[0, 1, 2, 3], "rho"] = np.int_(x[3:7])
        model.loc[[0, 1, 2, 3], "vp"] = np.int_(x[7:11])
        model.loc[[0, 1, 2, 3], "vs"] = np.int_(x[11:15])
        try:
            model.loc[0, "dip"] = 0
            model.loc[[1, 2, 3], "dip"] = x[15:18]
            model.loc[0, "strike"] = 0
            model.loc[[1, 2, 3], "strike"] = x[18:21]
            model.loc[[0, 1, 2, 3], "plunge"] = x[21:25]
            model.loc[[0, 1, 2, 3], "trend"] = x[25:29]
            model.loc[[0, 1, 2, 3], "ani"] = x[29:33]
        except:
            pass
    elif layers == 5:             # 5-layer model
        model.loc[[0, 1, 2, 3], "thickn"] = np.int_(x[0:4])
        model.loc[4, "thickn"] = 0
        model.loc[[0, 1, 2, 3, 4], "rho"] = np.int_(x[4:9])
        model.loc[[0, 1, 2, 3, 4], "vp"] = np.int_(x[9:14])
        model.loc[[0, 1, 2, 3, 4], "vs"] = np.int_(x[14:19])
        try:
            model.loc[0, "dip"] = 0
            model.loc[[1, 2, 3, 4], "dip"] = x[19:23]
            model.loc[0, "strike"] = 0
            model.loc[[1, 2, 3, 4], "strike"] = x[23:27]
            model.loc[[0, 1, 2, 3, 4], "plunge"] = x[27:32]
            model.loc[[0, 1, 2, 3, 4], "trend"] = x[32:37]
            model.loc[[0, 1, 2, 3, 4], "ani"] = x[37:42]
        except:
            pass
    elif layers == 6:             # 6-layer model
        model.loc[[0, 1, 2, 3, 4], "thickn"] = np.int_(x[0:5])
        model.loc[5, "thickn"] = 0
        model.loc[[0, 1, 2, 3, 4, 5], "rho"] = np.int_(x[5:11])
        model.loc[[0, 1, 2, 3, 4, 5], "vp"] = np.int_(x[11:17])
        model.loc[[0, 1, 2, 3, 4, 5], "vs"] = np.int_(x[17:23])
        try:
            model.loc[0, "dip"] = 0
            model.loc[[1, 2, 3, 4, 5], "dip"] = x[23:28]
            model.loc[0, "strike"] = 0
            model.loc[[1, 2, 3, 4, 5], "strike"] = x[28:33]
            model.loc[[0, 1, 2, 3, 4, 5], "plunge"] = x[33:39]
            model.loc[[0, 1, 2, 3, 4, 5], "trend"] = x[39:45]
            model.loc[[0, 1, 2, 3, 4, 5], "ani"] = x[45:51]
        except:
            pass
    elif layers == 7:             # 7-layer model
        model.loc[[0, 1, 2, 3, 4, 5], "thickn"] = np.int_(x[0:6])
        model.loc[6, "thickn"] = 0
        model.loc[[0, 1, 2, 3, 4, 5, 6], "rho"] = np.int_(x[6:13])
        model.loc[[0, 1, 2, 3, 4, 5, 6], "vp"] = np.int_(x[13:20])
        model.loc[[0, 1, 2, 3, 4, 5, 6], "vs"] = np.int_(x[20:27])
        try:
            model.loc[0, "dip"] = 0
            model.loc[[1, 2, 3, 4, 5, 6], "dip"] = x[27:33]
            model.loc[0, "strike"] = 0
            model.loc[[1, 2, 3, 4, 5, 6], "strike"] = x[33:39]
            model.loc[[0, 1, 2, 3, 4, 5, 6], "plunge"] = x[39:46]
            model.loc[[0, 1, 2, 3, 4, 5, 6], "trend"] = x[46:53]
            model.loc[[0, 1, 2, 3, 4, 5, 6], "ani"] = x[53:60]
        except:
            pass
    
    obser_r = obser_rf[:, :426]
    obser_t = obser_rf[:, 426:]
    pred_data, _ = predict(geom, model)
    pred_r = pred_data[:, :426]
    pred_t = pred_data[:, 426:]
        
    t_contrib = t_contrib  # percentage of RFT contribution
    if norm_method == "stack":
        pred_r = np.mean(pred_r, axis=0)
        pred_t = np.mean(pred_t, axis=0)
        obser_r = np.mean(obser_r, axis=0)
        obser_t = np.mean(obser_t, axis=0)
    
    rfr_diff = pred_r - obser_r
    rft_diff = pred_t - obser_t
    # # loss option 1
    # error = (1-t_contrib) * rfr_diff + t_contrib * rft_diff 
    # # Huber loss
    # delta = 0.1
    # huber_loss = np.where(np.abs(error) <= delta, 0.5 * error**2, delta * (np.abs(error) - 0.5 * delta))
    # error = np.sum(huber_loss)

    # least square loss
    loss = ((1-t_contrib) * rfr_diff**2 + t_contrib * rft_diff**2)
    error = np.mean(loss)

    # --- loss
    # print(f"Error: {error:.3f} -- h: {model['thickn'].values} -- vp: {model['vp'].values}")
    return error
        

def do_inversion(cost_func, bounds: dict, initial_model: dict, geom: dict, obser_data: np.ndarray,
                 layers: pd.DataFrame, method: str ="dual_ann", norm_method:str="signal", verbose:bool=False,
                 tr_contrib:float=0.5):
    """asd
    Inputs:
    cost_func: function
        cost function to be minimized
    bounds: list
        list of bounds for the parameters
    initial_model: pd.DataFrame
        initial model
    geom: Geometry 
        geometry of the station
    obser_data: np.array
        observed data
    layers: int
        number of layers
    method: str
        optimization method
    norm_method: str
        method to normalize the data (options; stack, individual)
    verbose: bool
        verbose mode
    
    Outputs:
    results: scipy.optimize.OptimizeResult
            """
    
    thickn_lc = np.zeros(len(bounds))
    thickn_lc[0:layers-1] = 1
    lc1 = LinearConstraint([thickn_lc], 30_000, 50_000)     # linear constraint 3 - thickness
    if method in ["dual_ann", "dual_annealing", "dual"]:
        results = dual_annealing(cost_func,                         # cost function func(x, *args)
                         bounds,                            # list of (min, max) pairs for each element in x
                         args=(initial_model, geom, obser_data, layers, norm_method, tr_contrib),
                         maxiter=10,
                         seed=42, 
                         )
    elif method in ["diff_evol","differential_evolution","diff"]:
        results = differential_evolution(cost_func,                         # cost function func(x, *args)
                         bounds,                            # list of (min, max) pairs for each element in x
                         args=(initial_model, geom, obser_data, layers, norm_method, tr_contrib),
                         maxiter=10,
                         constraints=[lc1],
                         disp=verbose
                         )
    elif method == "shgo":
        results = shgo(cost_func,                         # cost function func(x, *args)
                       bounds,                            # list of (min, max) pairs for each element in x
                       args=(initial_model, geom, obser_data, layers, norm_method),
                        constraints=[lc1],
                        )
    return results     


def print_and_save(scipy_result, station, layers):
    dict_result = {"layers": layers,
                   "fun": round(scipy_result.fun, 3),
                   "num_iter": scipy_result.nit,
                   "num_func_eval": scipy_result.nfev
                   }
    print(dict_result)
    df = pd.DataFrame(dict_result, index=[0])
    df.to_csv(f"inv/results/{station}/{station}_layers_{layers}_result.csv", index=False)


def plot_rfr_and_rft(pred_stacked, obser_stacked, text=""):
    fig, ax = plt.subplots(1, 2, figsize=(15, 3))
    time = np.linspace(-0.1*426, 0.1*426, int(0.5*pred_stacked.shape[0]))#[0:215]
    ax[0].plot(time, pred_stacked[:426], label="Predicted", linestyle="--", color="red")
    ax[0].plot(time, obser_stacked[:426], label="Real", color="black")
    ax[0].legend()
    ax[0].set_xlabel("Time (s)")
    ax[0].set_ylabel("Amplitude")
    ax[0].set_title("RFR")
    ax[1].plot(time, pred_stacked[426:], label="Predicted", linestyle="--", color="red")
    ax[1].plot(time, obser_stacked[426:], label="Real", color="black")
    ax[1].legend()
    ax[1].set_title("RFT")
    ax[1].set_xlabel("Time (s)")
    fig.suptitle(text)
    fig.tight_layout()
    return fig   

def stacking_obser_data(obser, baz, slow, **kwargs):
    # stacking rfs based on the back azimuth and slowness grided by 45 and 0.03
    baz_increment = kwargs.get("baz_increment", 45)
    slow_increment = kwargs.get("slow_increment", 0.03)
    baz_bands = np.arange(0, 360, baz_increment)
    slow_bands = np.arange(0.04, 0.09, slow_increment)
    new_obser = []
    new_baz = []
    new_slow = []
    for bz in baz_bands:
        for sl in slow_bands:
            idx = np.where((np.array(baz) > bz) & (np.array(baz) < bz+baz_increment) & (np.array(slow) > sl) & (np.array(slow) < sl+slow_increment))
            if len(idx[0]) > 1:
                sum_obser = np.sum(obser[idx], axis=0)
                sum_obser[:426] = sum_obser[:426] / np.max(np.abs(sum_obser[:426]))
                sum_obser[426:] = sum_obser[426:] / np.max(np.abs(sum_obser[426:]))
                new_obser.append(sum_obser)
                new_baz.append(bz+baz_increment/2)
                new_slow.append(sl+slow_increment/2)
    return np.array(new_obser), new_baz, new_slow