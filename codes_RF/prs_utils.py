import numpy as np
import matplotlib.pyplot as plt

def harm_dec_calc(result, sig_len=1000):
    len_data = len(result.rfs)
    rfs_np = np.zeros([2*len_data, sig_len])
    weight_mat = np.zeros([2*len_data, 5])

    counter = 0

    for stream in result.rfs:
        for trace in stream:
            baz_tr = trace.stats.baz
            baz_tr = np.deg2rad(baz_tr)
            channel_tr = trace.stats.channel
            if channel_tr == "RFR":
                # print("RFR --", counter)
                weight_line = np.array([1, np.cos(baz_tr), np.sin(baz_tr), np.cos(2*baz_tr), np.sin(2*baz_tr)], dtype=object)
            if channel_tr == "RFT":
                # print("RFT --", counter)
                weight_line = np.array([0, np.cos(baz_tr + np.pi/2), np.sin(baz_tr + np.pi/2), np.cos(2*baz_tr + np.pi/4), np.sin(2*baz_tr + np.pi/4)], dtype=object)
            rfs_np[counter,:] = trace.data
            weight_mat[counter,:] = weight_line
            counter += 1

    G = weight_mat
    RF = rfs_np
    GT = np.transpose(G)
    GTG = np.matmul(GT,G)
    GTG_inv = np.linalg.inv(GTG)
    GTRF = np.matmul(GT,RF)
    X = np.matmul(GTG_inv, GTRF)
    return X, trace.stats.taxis



def plot_har_dec(X, time, **kwargs):
    linewidth = kwargs.get("linewidth", 1.5)
    upper_color = kwargs.get("upper_color", "red")
    lower_color = kwargs.get("lower_color", "blue")
    lower_bond_show = kwargs.get("lower_bond_show", -.5)
    upper_bond_show = kwargs.get("upper_bond_show", 25)
    figsize = kwargs.get("figsize", (5, 5)) 

    # Create a figure and a set of subplots (3 columns, 1 row)
    fig, ax = plt.subplots(nrows=1, ncols=5, sharey = True, figsize=figsize)

    A, B, C, D, E = X[0], X[1], X[2], X[3], X[4]
    golbal_max = np.max([np.max(A), np.max(B), np.max(C), np.max(D), np.max(E)])
    A, B, C, D, E = A/golbal_max, B/golbal_max, C/golbal_max, D/golbal_max, E/golbal_max
    
    
    def fill_bet_func(i, time, curve, upper_color, lower_color):
        ax[i].fill_betweenx(time, curve, 0, where=curve>0, color=upper_color)
        ax[i].fill_betweenx(time, curve, 0, where=curve<0, color=lower_color)


    # fill_color
    # A
    ax[0].plot(A, time, "black", label="Isotropic", linewidth=linewidth)
    A_diff = np.abs((np.max(A) - np.min(A))*0.1)
    fill_bet_func(0, time, A, upper_color, lower_color)
    ax[0].set_xlim([np.min(A)-A_diff, np.max(A)+A_diff])
    ax[0].set_xticks([])

    # B
    ax[1].plot(B, time, "black", label="Cos($\phi$)", linewidth=linewidth)
    B_diff = np.abs((np.max(B) - np.min(B))*0.1)
    fill_bet_func(1, time, B, upper_color, lower_color)
    ax[1].set_xlim([np.min(B)-B_diff, np.max(B)+B_diff])
    ax[1].set_xticks([])

    # C
    ax[2].plot(C, time, "black", label="Sin($\phi$)", linewidth=linewidth)
    C_diff = np.abs((np.max(C) - np.min(C))*0.1)
    fill_bet_func(2, time, C, upper_color, lower_color)
    ax[2].set_xlim([np.min(C)-C_diff, np.max(C)+C_diff])
    ax[2].set_xticks([])

    # D
    ax[3].plot(D, time, "black", label="Cos(2$\phi$)", linewidth=linewidth)
    D_diff = np.abs((np.max(D) - np.min(D))*0.1)
    fill_bet_func(3, time, D, upper_color, lower_color)
    ax[3].set_xlim([np.min(D)-D_diff, np.max(D)+D_diff])
    ax[3].set_xticks([])

    # E
    ax[4].plot(E, time, "black", label="Sin(2$\phi$)", linewidth=linewidth)
    E_diff = np.abs((np.max(E) - np.min(E))*0.1)
    fill_bet_func(4, time, E, upper_color, lower_color)
    ax[4].set_xlim([np.min(E)-E_diff, np.max(E)+E_diff])
    ax[4].set_xticks([])

    # set time axis
    ax[0].set_ylim([lower_bond_show, np.max(time)])    
    ax[0].set_ylabel("time (sec)")
    
    # Corrected line to invert y-axis
    ax[0].invert_yaxis()
    
    # Custom x-axis labels
    fontsize = 6
    ax[0].set_xlabel("Constant", color='black')
    ax[0].set_title(f"Range~ {np.round(np.max(A)-np.min(A), 2)}", fontsize=fontsize)
    ax[1].set_xlabel("Cos($\phi$)\nE-W", color='black')
    ax[1].set_title(f"Range~ {np.round(np.max(B)-np.min(B), 2)}", fontsize=fontsize)
    ax[2].set_xlabel("Sin($\phi$)\nN-S", color='black')
    ax[2].set_title(f"Range~ {np.round(np.max(C)-np.min(C), 2)}", fontsize=fontsize)
    ax[3].set_xlabel("Cos(2$\phi$)\nE-W", color='black')
    ax[3].set_title(f"Range~ {np.round(np.max(D)-np.min(D), 2)}", fontsize=fontsize)
    ax[4].set_xlabel("Sin(2$\phi$)\nN-S", color='black')
    ax[4].set_title(f"Range~ {np.round(np.max(E)-np.min(E), 2)}", fontsize=fontsize)
    plt.tight_layout()
    plt.show()


