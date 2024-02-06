from pyraysum import prs, Geometry, Model, Control
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import dual_annealing
from numpy.linalg import norm
import pandas as pd
import os
import obspy as op


def read_all_data(keyword):
    npts = 426 * 2
    dt = 0.2
    ############################
    baz = []
    slow = []
    path = "DATA/waveforms_list.csv"
    waveforms_list = pd.read_csv(path)
    filtered_files = waveforms_list[waveforms_list['sta_code']==keyword].copy()
    filtered_files = filtered_files[filtered_files['rf_quality'] == 1].copy()
    path = "DATA/RF/"
    obs_mat = np.zeros((len(filtered_files), npts))
    idx = 0
    for _, row in filtered_files.iterrows():
        wave_path = os.path.join(path, row['file_name']+".pkl")
        st = op.read(wave_path)
        data_RFR = st.select(channel="RFR")[0].data
        data_RFT = st.select(channel="RFT")[0].data
        data_RFR = normalize(data_RFR)
        data_RFT = normalize(data_RFT)
        obs_mat[idx, :] = np.concatenate([data_RFR, data_RFT])
        baz.append(st[0].stats.baz)
        slow.append(st[0].stats.slow)
        idx += 1
        time = np.linspace(0, len(obs_mat)*dt, len(obs_mat))
    return obs_mat, baz, slow, time

def normalize(trace):
    #normalizing
    trace = trace - np.mean(trace)
    trace_max = np.max(np.abs(trace))
    trace = trace/trace_max
    return trace

def predict(geom, model):
    npts = 426
    dt = 0.2
    ani = model.ani
    flag = [1 if i == 0 else 0 for i in ani]
    model = Model(model.thickn, model.rho, model.vp, vs=model.vs, dip = model.dip, strike = model.strike, plunge = model.plunge, trend = model.trend, flag = flag, ani = ani)
    geom = Geometry(geom.baz, geom.slow)
    rc = Control(wvtype="P", rot=1, mults=2, verbose=False, npts=npts, dt=dt, align = 1, shift=10)
    result = prs.run(model, geom, rc, rf=True)
    result.filter('rfs', 'lowpass', freq=1., zerophase=True, corners=2)
    #
    #Extracting waveforms and concatenatig radial and transverse components
    pred = np.zeros((len(result), npts*2))
    idx = 0
    for i in result:
        RFR = normalize(i[1][0].data)
        RFT = normalize(i[1][1].data)
        data = np.concatenate((RFR, RFT), axis = 0)
        pred[idx, :] = data
        idx += 1
    return pred, result, geom, model

class model_:
    def __init__(self, num_layers):
        self.num_layers = num_layers
        self.thickn = np.zeros(num_layers)
        self.vp = np.ones(num_layers)
        self.vs = np.ones(num_layers)
        self.rho = np.ones(num_layers)
        self.dip = np.zeros(num_layers)
        self.strike = np.zeros(num_layers)
        self.plunge = np.zeros(num_layers)
        self.trend = np.zeros(num_layers)   
        self.ani = np.zeros(num_layers)

class geom_: 
    def __init__(self, baz, slow):
        self.baz = baz
        self.slow = slow
    



obs, baz, slow, time = read_all_data("CRLN")


#initiate model and geom
model = model_(num_layers=2)
geom = geom_(baz, slow)
pred, results, geom, model = predict(geom, model)

fig, axs = plt.subplots(nrows=2, ncols =1, figsize=(10, 5))
axs[0,].imshow(pred, aspect='auto')
axs[1].imshow(obs, aspect='auto')
plt.show()