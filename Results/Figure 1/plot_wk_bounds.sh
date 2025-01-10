
lonmid=-85
latmid=75
# # Standard parallels for projection
latstd1=55
latstd2=80
latmin=54.5
latmax=84
lonmin=-102
lonmax=-65
# # Projection: Lambert conic
proj="-JL$lonmid/$latmid/$latstd1/$latstd2/6i -R$lonmin/$lonmax/$latmin/$latmax"


gmt begin wk_bounds_map
  # Download SRTM data for Canada (adjust URL accordingly)
  # gmt grdcut @earth_relief_01m.grd -R$lonmin/$lonmax/$latmin/$latmax -Gcanada_topo.grd
  gmt grdimage canada_topo.grd -Cgeo -I+d $proj -Bafg -BWSne
  #gmt coast $proj -A10000 -BWenS -Ba10f2 -Di -Glightgoldenrod2 -W0.1p,lightgoldenrod3 
  gmt plot WK_bounds/WK_merged.shp -W2p,black
  gmt plot WK_bounds/buffer_line.shp -W1.5p,red
  gmt text WK_bounds/WK_labels.txt -F+a0+jML+f13,Helvetica-Bold,black -Dj0.1i/0.1i
  gmt plot net.txt -St0.6 -Cred,purple,blue,black -B200 -W0.5p,black
gmt end show


# gmt begin GMT_mercator
# 	gmt set GMT_THEME cookbook
# 	gmt set MAP_FRAME_TYPE fancy-rounded
# 	gmt coast -R-130/80/40/80 -Jm0.03c -Bxa60f15 -Bya30f15 -Dc -A5000 -Gred
#   gmt grdimage @earth_relief_10m -I+d -Cgeo 
#   gmt plot -W0.5p,black -St0.35 -Cred,purple,blue,black,yellow net.txt
# gmt end show

