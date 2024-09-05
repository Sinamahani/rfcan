# #!/bin/sh
#reading the csv file
len=0.7
awk -F"," -v len=$len '{$8=(450-$8)%360} NR> 1 {print $3, $2, $8, len, len}' hk-hd.csv > hdpm-2lobed.temp
awk -F"," -v len=$len '{$9=(450-$9)%360} NR> 1 {print $3, $2, $9, len, len}' hk-hd.csv > hdpm-4lobed.temp
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
latstd1=62
latstd2=78
# # Projection: Lambert conic
proj="-JL$lonmid/$latmid/$latstd1/$latstd2/6i -R$lonmin/$lonmax/$latmin/$latmax"

gmt begin HarmoDec
#   # Download SRTM data for Canada (adjust URL accordingly)
#   gmt grdcut @earth_relief_02m.grd -R$lonmin/$lonmax/$latmin/$latmax -Gcanada_topo.grd
#   gmt grdimage canada_topo.grd -Cgeo -I+d $proj -Bafg -BWSne
  gmt coast -Di $proj -Bafg -BWSne -Ggrey -Sazure2 
  gmt plot hdpm-2lobed.temp -Sv0.5i -W1.5p,red -Baf 
  gmt plot hdpm-4lobed.temp -Sv0.5i -W1.5p,blue -Baf
  gmt plot hdpm-2lobed.temp -Sc0.1i -W0.1p -Baf -Gblack 
gmt end show

rm hdpm-2lobed.temp
rm hdpm-4lobed.temp