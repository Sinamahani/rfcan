"""
Author: Sina Sabermahani (2024)
Description: for plotting 3d, we need to have depth column in the csv files.
            This script adds the depth column to all the csv files in the specified directory.
"""


import pandas as pd
import os
import asyncio
import numpy as np

async def add_depth_column(file_name):
    # As we already do not have the depth column, we need to add
    # it by summing the thickness of the layers.
    df = pd.read_csv(file_name)
    if "index" in df.columns:
        df.drop("index", axis=1, inplace=True)
    df["depth"] = df["thickn"].cumsum()
    df.to_csv(file_name, index=False)

async def add_depth_col_to_all_files(file_list):
    tasks = [add_depth_column(file_name) for file_name in file_list]
    await asyncio.gather(*tasks)
    
async def model_expansion(file_name, max_depth=50000, **kwargs):
    """
    This function is used to expand the model to the desired depth
    by adding depths and the output of this function is a csv file
    which is overwritten on the input file.
    """
    #kwargs: depth_interval
    depth_interval = kwargs.get("depth_interval", 2000)
    # phase1: reading file and preparing the dataframe
    file = pd.read_csv(file_name)
    if "thickn" in file.columns:
        file.drop(file.columns[0], axis=1, inplace=True)
    file.iloc[-1,-1] = max_depth
    # phase2: adding the depth column
    depth_points = np.arange(0, max_depth, depth_interval)
    # new_mat = np.zeros((len(depth_points), 9))
    new_mat = np.full((len(depth_points), 9), np.nan)
    new_mat[:,-1] = depth_points
    new_df = pd.DataFrame(new_mat, columns=file.columns)
    new_df = pd.concat([new_df, file], ignore_index=True).sort_values(by='depth')
    new_df.bfill(inplace=True)
    new_df.to_csv(file_name.split("%short.csv")[0]+"%expanded.csv", index=False)
    
async def model_expansion_all_files(file_list, **kwargs):
    tasks = [model_expansion(file_name, **kwargs) for file_name in file_list]
    await asyncio.gather(*tasks)
    
def collecting_all_stations_data(file_list: list) -> None:
    if not isinstance(file_list, list):
        raise ValueError("file_list should be a list.")
    
    complete_file = pd.DataFrame(columns=["sta","lat", "lon", "depth", "vp", "vs", "rho", "ani","model_layers"])
    # lat, lon, depth, vp, vs, rho, ani, model_layers
    row_no = 0
    for single_file in file_list:
        # df = pd.DataFrame(columns=["sta","lat", "lon", "depth", "vp", "vs", "rho", "ani"])
        file_name = single_file.split("/")[-1].split(".csv")[0].split("%")
        df = pd.read_csv(single_file)
        df["sta"] = file_name[0]
        df["lat"] = file_name[2]
        df["lon"] = file_name[3]
        df["model_layers"] = file_name[1]
        complete_file = pd.concat([complete_file, df], ignore_index=True)
    complete_file.to_csv("inv/plot3d/complete_file.csv", index=False)

def extract_moho_depth_and_velocity(file_list: list) -> None:
    """
    This function is used to extract the moho depth and the velocity of the moho
    from the csv files. The output is a csv file.
    """
    if not isinstance(file_list, list):
        raise ValueError("file_list should be a list.")
    
    moho_dep_and_vel = pd.DataFrame(columns=["sta", "lat", "lon", "moho_depth", "moho_vp", "moho_vs", "moho_rho"])
    count = 1
    for single_file in file_list:

        file_name = single_file.split("/")[-1].split(".csv")[0].split("%")
        df = pd.read_csv(single_file)
        moho_info = df[df.index == max(df.index)]
        moho_dep_and_vel.loc[count] = [file_name[0], file_name[2], file_name[3], moho_info['depth'].values[0],
                                       moho_info['vp'].values[0], moho_info['vs'].values[0], moho_info['rho'].values[0]]
        count += 1
    
    moho_dep_and_vel.to_csv("inv/plot3d/moho_depth_and_vel.csv", index=False)


    

if __name__ == "__main__":
    WORKDIR = f"inv/plot3d/data/"
    file_list = os.listdir(WORKDIR)
    file_list_short = [f"{WORKDIR}{f}" for f in file_list if f.endswith("short.csv")]
    file_list_expanded = [f"{WORKDIR}{f}" for f in file_list if f.endswith("expanded.csv")]
    print("size of the short files: ", len(file_list_short))
    print("size of the expanded files: ", len(file_list_expanded))
    asyncio.run(add_depth_col_to_all_files(file_list_short))
    asyncio.run(model_expansion_all_files(file_list_short, depth_interval=2000))
    collecting_all_stations_data(file_list_expanded)
    extract_moho_depth_and_velocity(file_list_short)