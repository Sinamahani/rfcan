import numpy as np
import obspy
import os
from codes_RF.rfpy_pkg import RFData, HkStack
import pandas as pd

class HKCan():
    """
    This class is for calculating the H-k stacking based on RFPy package.
    """
    def __init__(self, file_path, station, test_mode=False, weights=[0.5, 0.3, 0.2]):
        self.station = station
        paths = pd.read_csv(file_path)
        #corrections for file reading
        filtered_paths = paths[paths['sta_code'].str.contains(station)].copy()
        self.filtered_paths = filtered_paths[filtered_paths['rf_quality'] == 1].copy()
        

        inv_path = "REPORTS/stations.xml"
        self.inventory = obspy.read_inventory(inv_path).select(station=station)
        self.weights = weights
        if test_mode:
            self.rf_paths = self.rf_paths[0:3]
    
        
    def hk(self, vp = 6.5, save_fig=True):
        self.save_fig = save_fig
        rf_all = obspy.Stream()
        for i in range(len(self.filtered_paths)):
            rf_sig_path = self.filtered_paths.iloc[i]['file_name']
            self.rf_sig = obspy.read(f"DATA/RF/{rf_sig_path}.pkl").select(channel="RFR")
            rf_all += self.rf_sig
        self.new_rf = rf_all.copy()
        self.len_signal = len(self.new_rf)
        print(f"Number of traces: {self.len_signal}")
        rfstream1 = self.new_rf
        rfstream2 = self.new_rf.copy()
        rfstream1.filter('bandpass', freqmin=0.05, freqmax=0.5, corners=2, zerophase=True)
        rfstream2.filter('bandpass', freqmin=0.02, freqmax=0.35, corners=2, zerophase=True)
        self.hkstack = HkStack(rfstream1, rfstream2)
        self.vp = vp
        self.hkstack.stack(vp=vp)
        self.hkstack.weights = self.weights
        self.hkstack.average()
        self.hkstack.plot()
        self.h0 = round(self.hkstack.h0,3)
        self.k0 = round(self.hkstack.k0,3)
        self.h_err = round(self.hkstack.err_h0,3)
        self.k_err = round(self.hkstack.err_k0,3)
        print(f"Current h0: {self.h0} -- Current k0: {self.k0} -- Current h_err: {self.h_err} -- Current k_err: {self.k_err}")
        print("-"*60)
        print("-"*60)
        
    
    def hk_change_param(self, auto_optimization=True, plot_on=True, **kwargs):

        self.weights = kwargs.get('weights', [0.5, 0.3, 0.2])
        self.hkstack.weights = self.weights
        if auto_optimization:
            self.optimize_weights()

        self.hkstack.average()
        if plot_on:
            self.hkstack.plot()
        self.h0 = round(self.hkstack.h0,3)
        self.k0 = round(self.hkstack.k0,3)
        self.h_err = round(self.hkstack.err_h0,3)
        self.k_err = round(self.hkstack.err_k0,3)
        print(f"Current weights: {self.weights}")
        print(f" h0: {self.h0} --  k0: {self.k0} --  h_err: {self.h_err} --  k_err: {self.k_err}")
        print("-"*60)
        print("-"*60)

    def optimize_weights(self, ref_h0 = 37, ref_k0 = 1.76):
        err = []
        w1 = np.arange(1, 100, 4)
        w2 = np.arange(1, 100, 4)
        w3 = np.arange(1, 100, 4)
        for i in w1:
            for j in w2:
                for k in w3:
                    weights = [i, j, k]
                    self.hkstack.weights = weights
                    self.hkstack.average()
                    self.h_err = round(self.hkstack.err_h0,3)
                    self.k_err = round(self.hkstack.err_k0,3)
                    self.h0 = round(self.hkstack.h0,3)
                    self.k0 = round(self.hkstack.k0,3)
                    min_h0_and_k0 = (self.h_err-ref_h0) + 2* (self.k_err-ref_k0)
                    min_err = self.h_err + self.k_err
                    err.append([weights, min_h0_and_k0, min_err])
        weights_l1 = [x for x in err if x[1] == min([x[1] for x in err])]
        weights_l2 = [x for x in weights_l1 if x[2] == min([x[2] for x in weights_l1])]
        weights_l3 = [x[0] for x in weights_l2]
        print(f"Suggested optimized weights: {weights_l3}") 
        self.weights = np.round(np.array(weights_l3[0])/sum(weights_l3[0]), 2)
        self.hkstack.weights = self.weights
