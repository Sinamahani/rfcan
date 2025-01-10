# #!/bin/sh
#reading the csv file
len=1.5
awk -F"," '{$8=(450-$8)%360} NR> 1 {print $3, $2, $11, $9*3, $9*3}' hk-hd.csv > hdpm-2lobed.temp
awk -F"," '{$9=(450-$9)%360} NR> 1 {print $3, $2, $12, $10*3, $10*3}' hk-hd.csv > hdpm-4lobed.temp
awk -F"," -v len=$len '{$10=(450-$10)%360} NR> 1 {print $3, $2, $6, len, len}' hk-hd.csv > hdpm-rfpy.temp
# # Range to plot
lonExtend=10
latExtend=1.5
lonmin=`awk -v lonEx=$lonExtend '{print $1-lonEx}' hdpm-2lobed.temp | sort -n | head -1`
lonmax=`awk -v lonEx=$lonExtend '{print $1+lonEx}' hdpm-2lobed.temp | sort -n | tail -1`
latmin=`awk -v latEx=$latExtend '{print $2-latEx}' hdpm-2lobed.temp | sort -n | head -1`
latmax=`awk -v latEx=$latExtend '{print $2+latEx}' hdpm-2lobed.temp | sort -n | tail -1`
#remove the temporary file
# rm hdpm.temp
# # Get midpoint
lonmid=`echo $lonmin $lonmax | awk '{print ($1+$2)/2}'`
latmid=`echo $latmin $latmax | awk '{print ($1+$2)/2}'`
# # Standard parallels for projection
latstd1=50
latstd2=79
# # Projection: Lambert conic
proj="-JL$lonmid/$latmid/$latstd1/$latstd2/6i -R$lonmin/$lonmax/$latmin/$latmax"


gmt begin HarmoDec-PM
#   # Download SRTM data for Canada (adjust URL accordingly)
  # gmt grdcut @earth_relief_02m.grd -R$lonmin/$lonmax/$latmin/$latmax -Gcanada_topo.grd
  gmt grdimage canada_topo.grd -Cnuuk -I+d $proj -Bafg -BWSne
  gmt coast $proj -Dh -A1000 -W1p,black -BWenS -B5
  gmt plot hdpm-2lobed.temp -SV3.5i+jc+ea -W3.5p,darkblue
  gmt plot hdpm-4lobed.temp -SV3.5i+jc+ea -W3.5p,darkred
  gmt plot hdpm-2lobed.temp -Sc0.075i -W0.01p -Baf -Gblack 
gmt end show

gmt begin HarmoDec-RfPy
  gmt grdimage canada_topo.grd -Cnuuk -I+d $proj -Bafg -BWSne
  gmt coast $proj -Dh -A1000 -W1p,black -BWenS -B5
  gmt coast $proj -Dh -A1000 -W1p,black -BWenS -B5
  gmt plot hdpm-rfpy.temp -SV2.5i+jc+ea -W2.5p,darkblue
  gmt plot hdpm-rfpy.temp -Sc0.05i -W0.01p -Baf -Gblack
gmt end show

# rm hdpm-2lobed.temp
# rm hdpm-4lobed.temp
# rm hdpm-rfpy.temp