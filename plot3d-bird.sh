PROJECTNAME="Plot3D of RF models"
echo $PROJECTNAME

# write the python code
cat <<EOF > plot3d-bird.py
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.ensemble import RandomForestRegressor
