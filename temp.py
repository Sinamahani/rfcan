import pandas as pd
import os



WORKDIR = "inv/plot3d/flatmoho/"
file_list = os.listdir(WORKDIR)
file_list_short = [f"{WORKDIR}{f}" for f in file_list if f.endswith("short.csv")]
extract_moho_depth_and_velocity(file_list_short)

