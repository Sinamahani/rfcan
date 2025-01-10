# #!/bin/sh
#reading the csv file
len=1.5
awk -F"," 'NR > 1 {print $3, $2, $9+90, $7/2.5}' data.csv > dip.temp
awk -F"," 'NR > 1 {print $3, $2, $8, $6/2.5}' data.csv > ani.temp
awk -F"," 'NR > 1 {print $3, $2, $1}' data.csv > text.temp
# # Range to plot
lonExtend=10
latExtend=1.5
lonmin=`awk -v lonEx=$lonExtend '{print $1-lonEx}' dip.temp | sort -n | head -1`
lonmax=`awk -v lonEx=$lonExtend '{print $1+lonEx}' dip.temp | sort -n | tail -1`
latmin=`awk -v latEx=$latExtend '{print $2-latEx}' dip.temp | sort -n | head -1`
latmax=`awk -v latEx=$latExtend '{print $2+latEx}' dip.temp | sort -n | tail -1`
# # Get midpoint
lonmid=`echo $lonmin $lonmax | awk '{print ($1+$2)/2}'`
latmid=`echo $latmin $latmax | awk '{print ($1+$2)/2}'`
# # Standard parallels for projection
latstd1=50
latstd2=79
# # Projection: Lambert conic
proj="-JL$lonmid/$latmid/$latstd1/$latstd2/6i -R$lonmin/$lonmax/$latmin/$latmax"

# # Plot
gmt begin map-dip
  gmt grdimage canada_topo.grd -Cnuuk -I+d $proj -Bafg -BWSne
  gmt coast $proj -Dh -A1000 -W1p,black -BWenS -B5
  gmt plot dip.temp -Sv0.085i+ea+jc -Gred -W2.5p,red
  gmt plot dip.temp -Sc0.05i -Gred -W2.5p,red
gmt end show

gmt begin map-ani
  gmt grdimage canada_topo.grd -Cnuuk -I+d $proj -Bafg -BWSne
  gmt coast $proj -Dh -A1000 -W1p,black -BWenS -B5
  gmt plot ani.temp -Sv0.085i+ea+jc -Gred -W2.5p,red 
  gmt plot ani.temp -Sc0.05i -Gred -W2.5p,red
  # gmt text text.temp -F+f12p,Helvetica-Bold,black+j -D0.1c/0.1c
gmt end show

# rm dip.temp ani.temp text.temp