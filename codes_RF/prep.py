from obspy.clients.fdsn import Client
import numpy as np
from obspy import UTCDateTime
from obspy.taup import TauPyModel
from obspy.geodetics import locations2degrees
import os
import obspy
import pandas as pd
from codes_RF.rfpy_pkg import RFData
import matplotlib.pyplot as plt

# initializing client and taup
client = Client("IRIS")
taup = TauPyModel(model="iasp91")


class PREP:
    # preparing data for downloading
    @staticmethod
    def inv_report(ineventory, verbose=True):
        list = []
        for network in ineventory:
            for station in network:
                if verbose:
                    print(f"{network.code}.{station.code} | Lat: {station.latitude} | Long: {station.longitude} | Elevation: {station.elevation}")
                list.append(f"{network.code}.{station.code} | Lat: {station.latitude} | Long: {station.longitude} | Elevation: {station.elevation}")
                for channel in station:
                    if verbose:
                        print(f"--- {channel.code} | Sample Rate: {channel.sample_rate} | Start Time: {channel.start_date} | End Time: {channel.end_date}")
                    list.append(f"--- {channel.code} | Sample Rate: {channel.sample_rate} | Start Time: {channel.start_date} | End Time: {channel.end_date}")
        with open("REPORTS/stations.txt", "w") as f:
            for item in list:
                f.write("%s\n" % item)
        print("Report saved to REPORTS/stations.txt")
        ineventory.write("REPORTS/stations.xml", format="STATIONXML")


    @staticmethod
    def cat_report(cat, verbose=True):
        list = []
        for event in cat:
            if verbose:
                print(f"{event.origins[0].time} | Lat: {event.origins[0].latitude} | Long: {event.origins[0].longitude} | Depth: {event.origins[0].depth} | Mag: {event.magnitudes[0].mag}")
            list.append(f"{event.origins[0].time} | Lat: {event.origins[0].latitude} | Long: {event.origins[0].longitude} | Depth: {event.origins[0].depth} | Mag: {event.magnitudes[0].mag}")
        with open("REPORTS/events.txt", "w") as f:
            for item in list:
                f.write("%s\n" % item)
        cat.write("REPORTS/events.xml", format="QUAKEML")
        for event in cat:
            event.write(f"DATA/EVENTS/{event.resource_id.id.split('=')[-1]}.xml", format="QUAKEML")
        print("Report saved to REPORTS/events.txt")


    @staticmethod
    def taup_info(stala, stalo, evla, evlo, evdp, verbose=True, percision=2):
        arrival = taup.get_travel_times(source_depth_in_km=evdp, distance_in_degree=locations2degrees(stala, stalo, evla, evlo), phase_list=["P"])
        tt = round(arrival[0].time, percision)
        distance_in_deg = round(arrival[0].distance, percision)
        inc = round(arrival[0].incident_angle,percision)
        tk_angle = round(arrival[0].takeoff_angle, percision)
        slow = round(arrival[0].ray_param_sec_degree,percision)
        if verbose:
            print(f"travel time: {tt} | distance: {distance_in_deg} | incident angle: {inc} | takeoff angle: {tk_angle} | slow: {slow}")
        return tt, distance_in_deg, inc, tk_angle, slow


    @staticmethod
    def mk_list(cat, inv, year, verbose=True):
        # for progress status    
        counter = 0
        num_stas = sum(map(lambda net: sum(map(lambda sta: 1, net)), inv))
            
        num_wfs = 0 # counter for all waveforms
        all_wfs_list = [["file_name", "downloaded", "rf_created", "event_id", "ev_time", "ev_lat", "ev_long", "ev_depth", "ev_mag", "net_code", "sta_code", "sta_lat", "sta_long", "sta_elev", "tt", "distance_in_deg", "inc", "tk_angle", "slow"]]

        # Main job; loop through all stations
        for net in inv:
            for sta in net:
                if not sta.end_date:
                    sta.end_date = UTCDateTime.now()
                dur = sta.end_date - sta.start_date
                sta_working_year = int(dur/3600/24//365) #approximate years

                sta_lat = sta.latitude
                sta_long = sta.longitude
                sta_elev = sta.elevation

                if sta_working_year > year:
                    start_data = sta.end_date - year*365*24*3600
                else:
                    start_data = sta.start_date
                sliced_cat = cat.filter(f"time >= {start_data}",f"time <= {sta.end_date}")
                if verbose:
                    print(f"{sta.code} | {sta_working_year} | {len(sliced_cat)}")
                num_wfs += len(sliced_cat)
                # Loop through all events
                for event in sliced_cat:
                    # adding try-except to avoid errors when calculating travel time
                    try:
                        ev_lat = event.origins[0].latitude
                        ev_long = event.origins[0].longitude
                        ev_time = event.origins[0].time
                        ev_id = event.resource_id.id.split("=")[-1]
                        ev_mag = event.magnitudes[0].mag
                        ev_depth = event.origins[0].depth/1000 #km
                        tt, distance_in_deg, inc, tk_angle, slow = PREP.taup_info(sta_lat, sta_long, ev_lat, ev_long, ev_depth, verbose=False, percision=3)
                        file_name = f"{net.code}_{sta.code}_{ev_time.year}_{ev_time.month}_{ev_time.day}_{ev_time.hour}_{ev_time.minute}_{ev_time.second}"
                        all_wfs_list.append([file_name, "False", "False", ev_id, ev_time, ev_lat, ev_long, ev_depth, ev_mag, net.code, sta.code, sta_lat, sta_long, sta_elev, tt, distance_in_deg, inc, tk_angle, slow])
                    except:
                        # in case of error, skip the event
                        num_wfs -= 1
                counter += 1
                print(f"Progress: {round(counter/num_stas*100, 2)}%", end="\r")

        print(f"{'='*25}\nTotal number of waveforms: {num_wfs}\n{'='*25}")
        # saving the list of all waveforms
        with open("DATA/waveforms_list.csv", "w") as f:
            for item in all_wfs_list:
                f.write(f"{item[0]},{item[1]},{item[2]},{item[3]},{item[4]},{item[5]},{item[6]},{item[7]},{item[8]},{item[9]},{item[10]},{item[11]},{item[12]},{item[13]},{item[14]},{item[15]},{item[16]},{item[17]}\n")


    @staticmethod
    def create_directories():
        if not os.path.exists("DATA"):
            os.makedirs("DATA")
        if not os.path.exists("REPORTS"):
            os.makedirs("REPORTS")
        if not os.path.exists("DATA/RF"):
            os.makedirs("DATA/RF")
        if not os.path.exists("DATA/RAW_WF"):
            os.makedirs("DATA/RAW_WF")
        if not os.path.exists("DATA/EVENTS"):
            os.makedirs("DATA/EVENTS")




    @staticmethod
    def preparation(box, radius, mag, events, year, verbose=True):  
        # create directories
        PREP.create_directories()
        
        #download events
        client = Client("IRIS")
        catalog = client.get_events(starttime=UTCDateTime(f"{events[0]}-01-01"), endtime=UTCDateTime(f"{events[1]}-01-01"), latitude=sum(box[0:2])/2, longitude=sum(box[2:4])/2,
                                    minradius=radius[0], maxradius=radius[1], minmagnitude=mag[0], maxmagnitude=mag[1])
        PREP.cat_report(catalog, verbose=verbose) #saving the reports for later use
        #download stations
        inventory = client.get_stations(network = "*", channel = "BH?,HH?", minlatitude=box[0], maxlatitude=box[1], minlongitude=box[2], maxlongitude=box[3],
                                        starttime=UTCDateTime(f"{events[0]}-01-01"), endtime=UTCDateTime(f"{events[1]}-01-01"), level="channel")
        PREP.inv_report(inventory, verbose=verbose) #saving the reports for later use
        # make a list of all waveforms needed to be downloaded
        PREP.mk_list(catalog, inventory, year, verbose=verbose)



class DL:
    # reading the list of all waveforms and download them
    @staticmethod
    def reading_list():
        path = "DATA/waveforms_list.csv"
        if os.path.exists(path):
            list_df = pd.read_csv(path)
            return list_df
        else:
            raise FileExistsError('File does not exist, please check the "REPORTS/list_files.csv" file')
    

    @staticmethod
    def download_from_fdsn(excluded_list=[]):
        waveforms_list = DL.reading_list()
        print("Downloading waveforms from FDSN Webserver...")
        for i in range(len(waveforms_list)):
            # print(waveforms_list.iloc[i])
            if waveforms_list.iloc[i]['downloaded'] == False and waveforms_list.iloc[i]['net_code'] not in excluded_list: 
                file_name = waveforms_list.iloc[i]['file_name']     
                net = waveforms_list.iloc[i]['net_code']
                sta = waveforms_list.iloc[i]['sta_code']
                ttime = waveforms_list.iloc[i]['tt']
                evt = UTCDateTime(waveforms_list.iloc[i]['ev_time'])  #event time
                starttime = evt + ttime - 60 
                endtime = evt + ttime + 120
                try:
                    st = client.get_waveforms(net, sta, '*', '?HZ,?HN,?HE', starttime, endtime)
                    if len(st)>= 3:
                        st.write(f"DATA/RAW_WF/{file_name}.pkl", format="PICKLE")
                        waveforms_list.at[i, 'downloaded'] = True
                        waveforms_list.to_csv("DATA/waveforms_list.csv", index=False)
                except:
                    pass
        waveforms_list.to_csv("DATA/waveforms_list.csv", index=False)
        return waveforms_list


    @staticmethod
    def download_from_nrcan(net_list):
        waveforms_list = DL.reading_list()
        print("Downloading waveforms from Natural Resource Canada Webserver...")
        for i in range(len(waveforms_list)):
            # print(waveforms_list.iloc[i])
            if waveforms_list.iloc[i]['downloaded'] == False and waveforms_list.iloc[i]['net_code'] in net_list:  
                file_name = waveforms_list.iloc[i]['file_name']  
                net = waveforms_list.iloc[i]['net_code']
                sta = waveforms_list.iloc[i]['sta_code']
                ttime = waveforms_list.iloc[i]['tt']
                evt = UTCDateTime(waveforms_list.iloc[i]['ev_time'])
                starttime = evt + ttime - 60
                starttime_nr = f"{starttime.year}-{starttime.month}-{starttime.day}"
                endtime = evt + ttime + 120
                endtime_nr = f"{endtime.year}-{endtime.month}-{int(endtime.day)+1}"
                command = f"https://www.earthquakescanada.nrcan.gc.ca/fdsnws/dataselect/1/query?starttime={starttime_nr}&endtime={endtime_nr}&network={net}&station={sta}&nodata=404"
                try:
                    st = obspy.read(command)
                    if len(st)>= 3:
                        #trim
                        st.trim(starttime, endtime)
                        st.write(f"DATA/RAW_WF/{file_name}.pkl", format="PICKLE")
                        waveforms_list.at[i, 'downloaded'] = True
                        waveforms_list.to_csv("DATA/waveforms_list.csv", index=False)
                except:
                    pass
        waveforms_list.to_csv("DATA/waveforms_list.csv", index=False)        
        return waveforms_list


    @staticmethod
    def comprehensive_download(*args, nrcan=True):
        excluded_list = args
        DL.download_from_fdsn(excluded_list=excluded_list)
        
        if nrcan:
            DL.download_from_nrcan(net_list=args)
        print("The download is complete!\nIf you do it one more time, you may download more data.")



class RF():
    # creating rf from waveforms
    @staticmethod
    def read_event_station_waveforms(df_row,filters):
        """
        Read event, station, and waveforms from the dataframe row
        """
        ev_path = f"DATA/EVENTS/{df_row.event_id}.xml"
        st_path = "REPORTS/stations.xml"
        waveform_path = f"DATA/RAW_WF/{df_row['file_name']}.pkl"

        event = obspy.read_events(ev_path)[0]
        station = obspy.read_inventory(st_path).select(network=df_row.net_code, station=df_row.sta_code)[0][0]
        waveforms = obspy.read(waveform_path)
        waveforms.filter('bandpass', freqmin=filters[0], freqmax=filters[1], zerophase=True)
        return event, station, waveforms
    
    @staticmethod
    def mk_rf_by_RFPY(event, station, waveforms):
        rfdata = RFData(station)
        rfdata.add_event(event)
        rfdata.add_data(waveforms)

        rfdata.rotate(align="ZRT")
        rfdata.calc_snr()
        rfdata.deconvolve(method='water')
        rfstream = rfdata.to_stream()  
        rfstream.normalize()
        return rfstream
        
    
    @staticmethod
    def mk_rf(filters=[0.05,0.5], verbose=False):
        df = pd.read_csv("DATA/waveforms_list.csv")
        if "rf_quality" not in df.columns:
            df["rf_quality"] = -999
        df.to_csv("REPORTS/waveforms_list_[BACKUP].csv", index=False)
        
        if verbose:
            print("*** A column named 'rf_quality' is added to the dataframe for next step of manual quality control and all values are set to -999.\n")
            print(f"*** To backup you files, a copy of waveforms_list.csv is saved in REPORTS/waveforms_list_[BACKUP].csv\n","+-+-"*20)
        for i in range(len(df)):
            df_row = df.iloc[i]
            if df_row.downloaded == True:
                event, station, waveforms = RF.read_event_station_waveforms(df_row, filters)
                try:
                    rfstream = RF.mk_rf_by_RFPY(event, station, waveforms)
                    rfstream.write(f"DATA/RF/{df_row['file_name']}.pkl", format="PICKLE")
                    if verbose:
                        print(f"RF for {df_row['file_name']} is done")
                    df.loc[i, 'rf_created'] = True
                    df.loc[i, 'snr'] = round(rfstream[0].stats.snr, 2)
                    df.loc[i, 'snrh'] = round(rfstream[0].stats.snrh, 2)
                except AttributeError:
                    if verbose:
                        print(f"AttributeError: RF for {df_row['file_name']} is failed")
                    df.loc[i, 'snr'] = -999
                    df.loc[i, 'snrh'] = -999
                except ValueError:
                    if verbose:
                        print(f"ValueError: RF for {df_row['file_name']} is failed")
                    df.loc[i, 'snr'] = -999
                    df.loc[i, 'snrh'] = -999
            else:
                df.loc[i, 'snr'] = -999
                df.loc[i, 'snrh'] = -999

        #save the dataframe
        df.to_csv("DATA/waveforms_list.csv", index=False)
        return df
    


        
class QC:
    """
    This class is created for doing manual quality control on the receiver functions.
    """
    @staticmethod
    def guide(row, fig, time, max_amp=0.5):
        # Set axis labels and title
        fig.axes[0].set_xlabel("Time [s]")
        fig.axes[0].set_ylabel("Amplitude")
        if row.rf_quality != -999:
            fig.axes[0].set_title(f"rf_quality: {row.rf_quality}")
        else:
            fig.axes[0].set_title("rf_quality: Unknown")

        # Find maximum amplitude for annotations
        
        fig.axes[0].axvline(x=time, color="r", linestyle="--", label="P")
        # Add annotations (Ps, PPS, PSS)
        fig.axes[0].axvspan(time + 3.5, time + 6.5, facecolor="gold", alpha=0.15, label="Ps")
        fig.axes[0].text(time + 4, max_amp * 0.5, "ps", rotation=90, alpha=0.5)
        fig.axes[0].axvspan(time + 16.4, time + 19.5, facecolor="gold", alpha=0.15, label="PPS")
        fig.axes[0].text(time + 17, max_amp * 0.5, "pps", rotation=90, alpha=0.5)
        fig.axes[0].axvspan(time + 20.5, time + 23.5, facecolor="gold", alpha=0.15, label="PSS")
        fig.axes[0].text(time + 21 + 0.2, max_amp * 0.5, "pss", rotation=90, alpha=0.5)

        # Add reference line
        fig.axes[0].axhline(y=0, color="r", linestyle="--", label="Zero Amplitude")

    @staticmethod
    def update_quality(counter, list_df):
        i = counter
        # Ask user for quality assessment
        asking_quality = input("Is the quality of the receiver function good?\n Good --> [yes, y, 1, good]\nPoor --> [press Enter]\nSave --> [save, s]\nExit --> [exit, quit, q]\n [r1] ---> reverse polarity and save\n")

        # Update quality based on user input
        if asking_quality.lower() in ["y", "1", "yes", "good"]:
            list_df.loc[i, "rf_quality"] = 1
            return True, list_df
        elif asking_quality.lower() in ["q", "quit", "exit"]:
            print("Exiting...")
            return False, list_df
        elif asking_quality.lower() in ["save", "s"]:
            print("Saving...")
            list_df.to_csv("DATA/waveforms_list.csv", index=False)
            return False, list_df
        elif asking_quality == "r1": # it reverse the polarity and mark as 1
            list_df.loc[i, "rf_quality"] = 1
            st = obspy.read(f"DATA/RF/{list_df.file_name[i]}.pkl")
            st[1].data = -st[1].data
            st[2].data = -st[2].data
            st[1].plot()
            st.write(f"DATA/RF/{list_df.file_name[i]}.pkl", format="PICKLE")
            return True, list_df
        else:
            list_df.loc[i, "rf_quality"] = 0
            return True, list_df

        
    @staticmethod
    def manual_quality():
        """
        main function for manual quality control

        output:
            updated list_df
        """
        # Read list of waveforms
        list_df = DL.reading_list()

        for i in range(len(list_df)):
            # Check if rf is created and quality is unknown
            if (list_df.rf_created[i] and list_df.rf_quality[i] == -999):
                # Read receiver function data
                st = obspy.read(f"DATA/RF/{list_df.file_name[i]}.pkl").select(channel="RFR")
                # Get axis object from the returned value of st.plot()
                fig = st.plot(show=True, handle=True)
            
                # Calculate time for annotations
                time = st[0].stats.starttime + 0.5 * (st[0].stats.endtime - st[0].stats.starttime)
                row = list_df.iloc[i]
                max_amp = np.max(np.abs(st[0].data))
                QC.guide(row, fig, time, max_amp)
                plt.show()

                # Ask user for quality assessment
                up_qu, list_df = QC.update_quality(i, list_df)
                if up_qu == False:
                    break

        # Save final CSV
        list_df.to_csv("DATA/waveforms_list.csv", index=False)
        # Close plot window
        plt.close()
        print("Processing complete!")

    @staticmethod
    def quality_pred(test_set_keywords, already_labeled=True):
        """
        Using this function, we find the best model and use it to predict the quality of the waveforms.

        Parameters
        ----------
        test_set_keywords : list
            List of keywords to filter the waveforms. For example, ["net_code-eq-X5", "ev_mag-gt-5.0"] will only use the waveforms that have net_code = X5 and ev_mag > 5.0
        """

        from tensorflow.keras.models import load_model      #loading the required functions

        all_models = os.listdir("DATA/DEEP_QC/")
        all_models = [model for model in all_models if model.endswith(".h5")]
        max_acc = [[model, model.split("_")[1]] for model in all_models]
        max_acc.sort(key=lambda x: float(x[1]), reverse=True)
        best_model = max_acc[0][0]
        print(f"Best model is <<< {best_model} >>>")

        model = load_model(f"DATA/DEEP_QC/{best_model}")
        list_df = pd.read_csv("DATA/waveforms_list.csv")
        list_df = list_df[list_df["rf_created"] == True].copy()  #only use the waveforms that have rf_created = True
        list_df = list_df[list_df["snrh"] > -50].copy()     #only use the waveforms that have rf_quality != 2
        for filt in test_set_keywords:
            column = filt.split("-")[0]
            cond = filt.split("-")[1]
            value = QC.smart_convert(filt.split("-")[2])
            if cond == "eq":
                list_df = list_df[list_df[column] == value]
            elif cond == "lt":
                list_df = list_df[list_df[column] < float(value)]
            elif cond == "gt":
                list_df = list_df[list_df[column] > float(value)]

        #creating the confusion matrix
        true_pos = 0
        true_neg = 0
        false_pos = 0
        false_neg = 0

        new_df = pd.DataFrame()
        for i in range(len(list_df)):
            path = f"DATA/RF/{list_df.iloc[i]['file_name']}.pkl"
            data = obspy.read(path).select(component="R")[0].data[0:424]
            data = data.reshape(1, data.shape[0], 1)
            if data.shape[1] != 424:
                print(f"Data shape is not 424, it is {data.shape[1]} : {list_df.iloc[i]['file_name']}")
                continue
            pred_quality = model.predict(data, verbose=0)
            # print(pred_quality[0][0])

            # add the predicted quality to the dataframe
            new_df.loc[i,"file_name"] = list_df.iloc[i]["file_name"]
            new_df.loc[i,"sta_code"] = list_df.iloc[i]["sta_code"]
            new_df.loc[i,"net_code"] = list_df.iloc[i]["net_code"]
            new_df.loc[i,"ev_time"] = list_df.iloc[i]["ev_time"]
            new_df.loc[i,"ev_mag"] = list_df.iloc[i]["ev_mag"]
            new_df.loc[i,"ev_depth"] = list_df.iloc[i]["ev_depth"]
            new_df.loc[i,"ev_lat"] = list_df.iloc[i]["ev_lat"]
            new_df.loc[i,"ev_long"] = list_df.iloc[i]["ev_long"]
            new_df.loc[i,"sta_lat"] = list_df.iloc[i]["sta_lat"]
            new_df.loc[i,"sta_long"] = list_df.iloc[i]["sta_long"]
            new_df.loc[i,"sta_elev"] = list_df.iloc[i]["sta_elev"]
            new_df.loc[i,"snr"] = list_df.iloc[i]["snr"]
            new_df.loc[i,"snrh"] = list_df.iloc[i]["snrh"]
            new_df.loc[i,"event_id"] = list_df.iloc[i]["event_id"]

            if already_labeled:
                new_df.loc[i,"rf_quality_pred"] = int(round(pred_quality[0][0],0))
                new_df.loc[i,"rf_quality"] = list_df.iloc[i]["rf_quality"]
                # calculating the confusion matrix
                if list_df.iloc[i]["rf_quality"] == 1 and round(pred_quality[0][0],0) == 1:
                    true_pos += 1
                    new_df.loc[i,"pred_type"] = "true_pos"
                elif list_df.iloc[i]["rf_quality"] == 0 and round(pred_quality[0][0],0) == 0:
                    true_neg += 1
                    new_df.loc[i,"pred_type"] = "true_neg"
                elif list_df.iloc[i]["rf_quality"] == 1 and round(pred_quality[0][0],0) == 0:
                    false_neg += 1
                    new_df.loc[i,"pred_type"] = "false_neg"
                elif list_df.iloc[i]["rf_quality"] == 0 and round(pred_quality[0][0],0) == 1:
                    false_pos += 1
                    new_df.loc[i,"pred_type"] = "false_pos"
            else:
                new_df.loc[i,"rf_quality"] = int(round(pred_quality[0][0],0))

        if already_labeled:
            #reporting the results
            print(f"True Positive: {true_pos}")
            print(f"True Negative: {true_neg}")
            print(f"False Positive: {false_pos}")
            print(f"False Negative: {false_neg}")
            print(f"Accuracy: {round((true_pos+true_neg)/(true_pos+true_neg+false_pos+false_neg),3)}")
            print(f"Precision: {round(true_pos/(true_pos+false_pos),3)}")
            print(f"Recall: {round(true_pos/(true_pos+false_neg),3)}")
            print(f"F1 Score: {round(2*true_pos/(2*true_pos+false_pos+false_neg),3)}")

        #saving the results
        new_df.to_csv("DATA/waveforms_list_pred.csv", index=False)
        print("Results saved to DATA/waveforms_list_pred.csv")
        return new_df


    # @staticmethod
    def smart_convert(input: str):
        """
        converting the input from to the proper type like int, float, str or bool
        """
        try:
            return int(input)
        except ValueError:
            pass
        try:
            return float(input)
        except ValueError:
            pass
        if input == "True":
            return True
        elif input == "False":
            return False
        else:
            return input
    

    @staticmethod
    def preview(filters, data_type="rf", preview_type="list"):
        """
        This function is for previewing the data before running the QC or even after QC to have a better insight.

        Input:
            filter: a pattern to filter the data "column-condition-value". e.g. "network-eq-PO" means column network when it is eq to PO. other conditions are eq, gt and lt.
            data_type: type of the data. "rf" or "raw"
            preview_type: type of the output. "list" or "plot"
        Output:
            plot of the data
        """
    
        list_df = DL.reading_list()
        filter_keywords = []
        list_df = list_df[list_df["rf_created"]==True].copy()
        for filter in filters:
            column, condition, value = filter.split("-")
            conv_value = QC.smart_convert(value)    #coverting to the proper type

            if condition == "eq":
                list_df = list_df[list_df[column] == conv_value].copy()
            elif condition == "lt":
                list_df = list_df[list_df[column] <= conv_value].copy()
            elif condition == "gt":
                list_df = list_df[list_df[column] >= conv_value].copy()    
            filter_keywords.append(column)
            filter_keywords.append(value)

        if data_type == "rf":
            path_part="RF"
            channel = "RFR"
        elif data_type == "raw":
            path_part="RAW_WF"
            channel = "*HZ"
        os.makedirs(f"REPORTS/{path_part}_{'_'.join(filter_keywords)}/")
        if preview_type == "list":
            list_df.to_csv(f"REPORTS/{path_part}_{'_'.join(filter_keywords)}/list.csv", index=False)
        else:
            for i in range(len(list_df)):
                filename = list_df.iloc[i].file_name
                filename = f"DATA/{path_part}/{filename}.pkl"
                fig = obspy.read(filename).select(channel=channel).plot(show=False, handle=True)
                fig.axes[0].set_title(f"RF Quality: {list_df.iloc[i].rf_quality}")
                fig.savefig(f"REPORTS/{path_part}_{'_'.join(filter_keywords)}/{list_df.iloc[i].file_name}.png")
                plt.close(fig)