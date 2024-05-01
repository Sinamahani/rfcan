import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import RegularGridInterpolator, griddata

df = pd.read_csv("plot3d.csv")
# plt.scatter(df["lat"], df["lon"], c=df["depth"], cmap="viridis")
lat = df["lat"]
lon = df["lon"]
depth = df["depth"]
m = df["vp"]
#interpolation
x = lon
y = lat
z = depth
m = m
grid_x = np.linspace(x.min(), x.max(), 5)
grid_y = np.linspace(y.min(), y.max(), 5)
grid_z = np.linspace(z.min(), z.max(), 5)
grid_m = griddata((x, y, z), m, (grid_x[None, :], grid_y[:, None], grid_z[:, None]))

#plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter(grid_x, grid_y, grid_z, c=grid_m, cmap='viridis')
ax.set_xlabel('X Label')
ax.set_ylabel('Y Label')
ax.set_zlabel('Z Label')
plt.show()