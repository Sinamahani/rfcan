import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import RegularGridInterpolator, griddata, interpn

df = pd.read_csv("plot3d.csv")
resolution = 2
# plt.scatter(df["lat"], df["lon"], c=df["depth"], cmap="viridis")
lat = df["lat"]
lon = df["lon"]
depth = df["depth"]
m = df["vp"]
sta = df["sta"]
#interpolation
x = lon
y = lat
z = depth
m = m

zlevels = 5
resolution = 20

x = np.linspace(lon.min(), lon.max(), resolution)
y = np.linspace(lat.min(), lat.max(), resolution)
z = np.linspace(depth.min(), depth.max(), zlevels)
grid_x, grid_y, grid_z = np.meshgrid(x, y, z, indexing='ij')
grid_m = griddata((lon, lat, depth), m, (grid_x, grid_y, grid_z), method='nearest')
# grid_m = interpn((grid_x, grid_y, grid_z), m, (lon, lat, depth), method='linear', bounds_error=False, fill_value=None)
kw = {
    "levels": np.linspace(m.min(), m.max(), 10)
}

# plot
fig = plt.figure(figsize=(10, 10))
ax = fig.add_subplot(111, projection='3d')
#z
for i in range(zlevels):
    C = ax.contourf(grid_x[:,:,i], grid_y[:,:,i], grid_m[:,:,i], zdir='z', offset=grid_z[:,:,i].min(), **kw)
    
xmin, xmax = grid_x.min(), grid_x.max()
ymin, ymax = grid_y.min(), grid_y.max()
zmin, zmax = grid_z.min(), grid_z.max()
ax.set(xlim=[xmin, xmax], ylim=[ymin, ymax], zlim=[zmin, zmax])


# Set labels and zticks
ax.set(
    xlabel='X [km]',
    ylabel='Y [km]',
    zlabel='Z [m]',
    zticks=[0, 1, 2, 3, 4, 5],
)

ax.view_init(-150, -75, "z")
ax.set_box_aspect(None, zoom=0.9)

fig.colorbar(C, ax=ax, fraction=0.02, pad=0.1, label='Vp [km/s]')
for i, txt in enumerate(sta):
    ax.scatter(lon[i], lat[i], -1, c='r', s=10, marker='o', label='station')
    ax.text(lon[i], lat[i], -1, txt, color='black', fontsize=8, visible=True)

ax.set_xlabel('Longitude')
ax.set_ylabel('Latitude')
ax.set_zlabel('Depth')
plt.show()

print(grid_z.shape)