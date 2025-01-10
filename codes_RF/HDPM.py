"""
This package is for plotting particle motion of first and second order harmonic
decomposition of receiver functions.

For seeing the usage of the package, please see the example below.

station = "fcc"
station = station.upper()
wave_df = pd.read_csv("DATA/waveforms_list.csv")
wave_df = wave_df[(wave_df["sta_code"] == station) & (wave_df["rf_quality"] == 1)]
wave_list = [f"DATA/RF/{i}.pkl" for i in wave_df["file_name"]]


wave, G = info_extract(wave_list)
m = harmonic_decomp(wave, G)
address = "Results/HARMINIC_DECOMP/ParticleMotion"
particlemotion(m, type="2-lobed", xmin=1, xmax=7, save_folder=address, station=station)
"""

import pandas as pd
import obspy as op
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Circle

def baz_func(baz, type="radial", modelled=True):
    """
    Calculate the azimuthal angle for each row of the matrix G.
    """
    first_element = 1 if type == "radial" else 0
    phi = 0 if type == "radial" else np.pi/2
    phi = phi if modelled else -phi

    return [first_element, np.cos(baz*np.pi/180+phi), np.sin(baz*np.pi/180+phi),
            np.cos(2*baz*np.pi/180+phi/2), np.sin(2*baz*np.pi/180+phi/2)]

def signal_to_noise_ratio(st):
    """
    Calculate the signal to noise ratio of a waveform.
    """
    noise = st[2].data[:215]
    signal = st[2].data[215:265]
    noise_spec_mean = np.mean(noise**2)
    signal_spec_mean = np.mean(signal**2)
    return signal_spec_mean/noise_spec_mean

def info_extract(wave_list):
    """
    Building matrix G and radial and transverse waveforms 
    for calculation of harmonic decomposition.

    Parameters:
    wave_list: an iterable list of waveforms.
    """
    wave_rd = np.array([])
    wave_tr = np.array([])
    G_rd = np.array([])
    G_tr = np.array([])
    counter = 0
    for wave in wave_list:
        st = op.read(wave)
        if signal_to_noise_ratio(st) < 3:
            continue
        baz = st[0].stats.baz
        baz_rd = baz_func(baz)
        G_rd = np.append(G_rd, baz_rd)
        baz_tr = baz_func(baz, type="transverse")
        G_tr = np.append(G_tr, baz_tr)
        wave_rd = np.append(wave_rd, st[1].data)
        wave_tr = np.append(wave_tr, st[2].data)
        counter += 1
    G_rd = G_rd.reshape(counter, 5)
    G_tr = G_tr.reshape(counter, 5)
    G = np.append(G_rd, G_tr, axis=0)
    wave_rd = wave_rd.reshape(counter, -1)
    wave_tr = wave_tr.reshape(counter, -1)
    wave = np.append(wave_rd, wave_tr, axis=0)
    return wave, G, counter

def harmonic_decomp(wave, G):
    """
    Calculate the harmonic decomposition of the waveforms.

    Parameters:
    wave: a matrix of waveforms.
    G: a matrix of azimuthal angles.

    Output:
    m: components of the harmonic decomposition.
    """
    Gt = np.transpose(G)
    GtG = np.dot(Gt, G)
    GtG_inv = np.linalg.inv(GtG)
    GtG_invGt = np.dot(GtG_inv, Gt)
    m = np.dot(GtG_invGt, wave)
    m_positive = m[:,213:]
    return m_positive

def particlemotion(m, type="2-lobed", xmin=0, xmax=10, save_folder=None, station=None, datasize=None):
    
    if xmin < 0 or xmax > len(m[0])*0.2:
        raise ValueError("xmin and xmax must be within the range of the waveforms")
    
    time = np.linspace(0, 213*0.2, len(m[0]))
    lower_bond_show = 0
    upper_color = "red"
    lower_color = "blue"
    linewidth = 0.5
    
    #plot
    fig, ax = plt.subplots(nrows=1, ncols=5, sharey = True, figsize=(4,4))
    A, B, C, D, E = m[0], m[1], m[2], m[3], m[4]
    globalMax = np.max([np.max(np.abs(A)), np.max(np.abs(B)), np.max(np.abs(C)), 
                        np.max(np.abs(D)), np.max(np.abs(E))])
    A, B, C, D, E = A/globalMax, B/globalMax, C/globalMax, D/globalMax, E/globalMax

    def fill_betw_func(i, time, curve, upper_color, lower_color):
        ax[i].fill_betweenx(time, curve, 0, where=curve>0, color=upper_color)
        ax[i].fill_betweenx(time, curve, 0, where=curve<0, color=lower_color)

    # fill_color
    # A
    ax[0].plot(A, time, "black", label="Isotropic", linewidth=linewidth)
    A_diff = np.abs((np.max(A) - np.min(A))*0.1)
    fill_betw_func(0, time, A, upper_color, lower_color)
    ax[0].set_xlim([np.min(A)-A_diff, np.max(A)+A_diff])
    ax[0].set_xticks([])
    

    # B
    ax[1].plot(B, time, "black", label=r"Cos($\phi$)", linewidth=linewidth)
    B_diff = np.abs((np.max(B) - np.min(B))*0.1)
    fill_betw_func(1, time, B, upper_color, lower_color)
    ax[1].set_xlim([np.min(B)-B_diff, np.max(B)+B_diff])
    ax[1].set_xticks([])

    # C
    ax[2].plot(C, time, "black", label=r"Sin($\phi$)", linewidth=linewidth)
    C_diff = np.abs((np.max(C) - np.min(C))*0.1)
    fill_betw_func(2, time, C, upper_color, lower_color)
    ax[2].set_xlim([np.min(C)-C_diff, np.max(C)+C_diff])
    ax[2].set_xticks([])

    # D
    ax[3].plot(D, time, "black", label=r"Cos(2$\phi$)", linewidth=linewidth)
    D_diff = np.abs((np.max(D) - np.min(D))*0.1)
    fill_betw_func(3, time, D, upper_color, lower_color)
    ax[3].set_xlim([np.min(D)-D_diff, np.max(D)+D_diff])
    ax[3].set_xticks([])

    # E
    ax[4].plot(E, time, "black", label=r"Sin(2$\phi$)", linewidth=linewidth)
    E_diff = np.abs((np.max(E) - np.min(E))*0.1)
    fill_betw_func(4, time, E, upper_color, lower_color)
    ax[4].set_xlim([np.min(E)-E_diff, np.max(E)+E_diff])
    ax[4].set_xticks([])

    # set time axis
    timeUpperBond = 30 #sec
    timeLowerBond = 0 #sec   
    ax[0].set_ylim([timeLowerBond, timeUpperBond])    
    ax[0].set_ylabel("time (sec)")

    # Corrected line to invert y-axis
    ax[0].invert_yaxis()

    # Custom x-axis labels
    fontsize = 6
    ax[0].set_xlabel("Constant", color='black')
    ax[0].set_title(f"Range~ {np.round(np.max(A)-np.min(A), 2)}", fontsize=fontsize)
    ax[1].set_xlabel(r"Cos($\phi$)", color='black')
    ax[1].set_title(f"Range~ {np.round(np.max(B)-np.min(B), 2)}", fontsize=fontsize)
    ax[2].set_xlabel(r"Sin($\phi$)", color='black')
    ax[2].set_title(f"Range~ {np.round(np.max(C)-np.min(C), 2)}", fontsize=fontsize)
    ax[3].set_xlabel(r"Cos(2$\phi$)", color='black')
    ax[3].set_title(f"Range~ {np.round(np.max(D)-np.min(D), 2)}", fontsize=fontsize)
    ax[4].set_xlabel(r"Sin(2$\phi$)", color='black')
    ax[4].set_title(f"Range~ {np.round(np.max(E)-np.min(E), 2)}", fontsize=fontsize)
    plt.tight_layout()
    if save_folder:
        if not station:
            station = "XXXX"
        plt.savefig(f"{save_folder}/{station}-HD.png", dpi=300)
        
    fig1, ax = plt.subplots(nrows=1, ncols=2, figsize=(5,3))
    half = 0  # starting sample of the second half of the waveform equal to P arrival time
    wave_const = m[0][half+xmin*5:half+xmax*5]
    
    for counter, i in enumerate(["2-lobed", "4-lobed"]):
        type = i
        if type == "2-lobed":
            ax[0].set_xlabel(r"cos($\phi$)")
            ax[0].set_ylabel(r"sin($\phi$)")
            comp1 = 1
            comp2 = 2
        elif type == "4-lobed":
            comp1 = 3
            comp2 = 4
            ax[1].set_xlabel(r"cos(2$\phi$)")
            ax[1].set_ylabel(r"sin(2$\phi$)")
        wave_x = m[comp1][half+xmin*5:half+xmax*5]
        wave_y = m[comp2][half+xmin*5:half+xmax*5]
        hdStrength = np.sqrt(np.sum(wave_x**2) + np.sum(wave_y**2)) / np.sqrt(np.sum(wave_const**2)) #HD strength
        #covariance matrix
        cov = np.cov(wave_x, wave_y)
        #eigenvalues and eigenvectors
        eigval, eigvec = np.linalg.eig(cov)
        L = np.abs(eigval[0]-eigval[1])/np.sum(eigval) #Linearity
        ax[counter].plot(wave_x, wave_y, ":k")
        R = np.max(np.append(np.abs(wave_x), np.abs(wave_y)))
        circle = Circle((0, 0), 1.5*R, fill=False, color='k')
        ax[counter].add_patch(circle)


        ax[counter]
        #remove axis values
        ax[counter].set_yticklabels([])
        ax[counter].set_xticklabels([])
        #remove axis lines
        # ax[counter].spines['left'].set_visible(False)
        # ax[counter].spines['bottom'].set_visible(False)
        # ax[counter].spines['right'].set_visible(False)
        # ax[counter].spines['top'].set_visible(False)
        #remove ticks
        ax[counter].xaxis.set_ticks_position('none')
        ax[counter].yaxis.set_ticks_position('none')
        ax[counter].set_aspect('equal')
    
        #line fitting
        from scipy.optimize import curve_fit
        def func(x, a, b):
            return a*x + b

        popt, _ = curve_fit(func, wave_x.data, wave_y.data, method="dogbox")
        ax[counter].plot(wave_x, func(wave_x, *popt), 'r', lw=2)
        angle_az = (450 - np.arctan(popt[0])*180/np.pi) % 360   #converting to azimuthal angle
        ax[counter].set_title(f"{i}: {angle_az:.0f}°")
        print(f"{station}, {i}, {hdStrength:.2f}, {angle_az}, {datasize}, {L:.2f}")  
    if save_folder:
        if not station:
            station = "XXXX"
        plt.savefig(f"{save_folder}/{station}-PM.png", dpi=300)