import obspy
from obspy.clients.fdsn import Client

client = Client("IRIS")

sta = client.get_stations(channel="?H?", minlatitude=55, maxlatitude=90, minlongitude=-105, maxlongitude=-70, level="channel")

#sta.plot(projection="local", resolution="i")

all = [["net", "sta", "lat", "lon"]]
for st in sta:
    if st.code not in ["SY", "8U"]:
        for s in st:
            print(st.code, "--", s.code, "--", s.latitude, s.longitude)
            all.append([st.code, s.code, s.latitude, s.longitude])

with open("sta.txt", "w") as f:
    for a in all:
        f.write(",".join([str(i) for i in a]) + "\n")
