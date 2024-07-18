from obspy import read, Stream
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


#defining the decorator
def add_line_decorator(func):
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        print("================================================")
        return result
    return wrapper    


class viz():
    @add_line_decorator
    def __init__(self, sta_list, hist_bin, using_pred=False):
        self.sta_list = sta_list
        self.hist_bin = hist_bin
        self.using_pred = using_pred
        self.add_slow_baz()

        print("Dataframe has been updated\nslow and baz have been added to the dataframe")

    @add_line_decorator
    def add_slow_baz(self):
        """
        Add baz and slow to dataframe for each waveform has been created and has a quality of 1, otherwise add -999
        """
        list_df = pd.read_csv("DATA/waveforms_list.csv")   #reading the csv file
        
        # if self.using_pred == True:
        #     # replacing rf_quality with rf_quality_pred
        #     list_df = list_df.rename(columns={"rf_quality": "rf_quality_null"})
        #     # replacing rf_quality_pred with rf_quality
        #     list_df = list_df.rename(columns={"rf_quality_pred": "rf_quality"})

        df = list_df[list_df["sta_code"].isin(self.sta_list)].copy()   #shrinking the dataset to only include the stations in sta_list
        for index, row in df.iterrows():
            if row.rf_quality == 1:
                #file path
                path = f"DATA/RF/{row['file_name']}.pkl"
                # read in data
                st = read(path)
                # get baz and slow
                baz = st[0].stats.baz
                slow = st[0].stats.slow
                # add to dataframe
                df.loc[index, 'baz'] = baz
                df.loc[index, 'slow'] = slow
            else:
                df.loc[index, 'baz'] = -999
                df.loc[index, 'slow'] = -999
        list_df = df
        self.list_df = list_df[list_df["baz"] != -999].copy()   #shrinking the dataset to only include the waveforms with baz and slow

    @add_line_decorator
    def distribution_hist(self):
        #plotting the histogram of baz for each station in sta_list
        print("Plotting the histogram of baz for each station ...")
        for sta in self.sta_list:
            sublist_df = self.list_df[self.list_df["sta_code"] == sta].copy()   
            print(f"Number of waveforms for {sta} is {len(sublist_df)}")
            hist, bin_edges = np.histogram(2*np.pi*sublist_df["baz"]/360, bins=self.hist_bin, range=(0, 2*np.pi)) #histogram of baz 
            theta = np.linspace(0.0, 2 * np.pi, self.hist_bin, endpoint=False)
            colors = plt.cm.viridis(hist / 10.)
            plt.figure(figsize=(20, 7))
            ax = plt.subplot(131, projection='polar')
            ax.bar(theta, hist, color=colors, alpha=0.6)
            ax.set_xticks(theta)
            ax.set_title(f" Back-Azimuth Histogram for {sta}")
            ax = plt.subplot(1,5,(3,5))
            plt.hist(sublist_df["slow"], bins=self.hist_bin, color='khaki', alpha=0.8)
            plt.title(f"Slowness Histogram for {sta}")
            plt.xlabel("Slowness (s/km)")
            plt.ylabel("Count")
            plt.show()

    @add_line_decorator
    def plot_section(self, type="baz"):
        """
        Plotting the baz section for each station in sta_list
        """
        
        if type == "baz":
            print("Plotting the baz section for each station ...")
            col_type = self.list_df["baz"].values
            _, bin_edges = np.histogram(col_type, bins=self.hist_bin, range=(0, 360)) #histogram of baz
        elif type == "slow":
            print("Plotting the slow section for each station ...")
            col_type = self.list_df["slow"].values
            _, bin_edges = np.histogram(col_type, bins=self.hist_bin) #histogram of slow

        for sta in self.sta_list:
            st = Stream()
            sublist_df_sta = self.list_df[self.list_df["sta_code"] == sta].copy()
            for i in range(len(bin_edges)):
                if i == 0:
                    continue
                else:
                    sublist_df = sublist_df_sta[(sublist_df_sta[type] >= bin_edges[i-1]) & (sublist_df_sta[type] < bin_edges[i])].copy()
                    sliced_list = sublist_df[["file_name", type]].values
                    try:
                        st_p = Stream()
                        for row in sliced_list:
                            #file path
                            path = f"DATA/RF/{row[0]}.pkl"
                            tr = read(path).select(channel="RFR")[0]
                            tr.stats.distance = row[1]
                            tr.stats.starttime = 0
                            tr.data = np.fft.fftshift(tr.data)
                            st_p += tr
                        st_p.stack()
                        if type == "baz":
                            st_p[0].stats.distance = (bin_edges[i] + bin_edges[i-1]) *500
                        elif type == "slow":
                            st_p[0].stats.distance = (bin_edges[i] + bin_edges[i-1]) /2
                        st += st_p
                    except IndexError:
                        continue
            if len(st)>0:
                fig = st.plot(type='section', fig=plt.figure(figsize=(4.5, 7)), fillcolors=('black', 'lightgrey'), orientation='horizontal', recordlength=30, scale=2, handle=True, show=False) 
                if type == "baz":
                    fig.axes[0].set_title(f"Back-Azimuth Section for {sta}")
                    fig.axes[0].set_ylabel("Back-Azimuth (deg)")
                elif type == "slow":
                    fig.axes[0].set_title(f"Slowness Section for {sta}")
                    fig.axes[0].set_ylabel("Slowness (s/km)")
                plt.show()
                    