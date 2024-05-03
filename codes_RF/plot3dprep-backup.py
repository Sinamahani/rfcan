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
    df = pd.read_csv(file_name)
    df.drop("index", axis=1, inplace=True)
    df["depth"] = df["thickn"].cumsum()
    return df

async def process_file(file_name):
    df = await add_depth_column(file_name)
    df.to_csv(file_name, index=False)

async def add_depth_column_to_all_files(file_list):
    tasks = [process_file(file_name) for file_name in file_list]
    await asyncio.gather(*tasks)
        

if __name__ == "__main__":
    file_list = os.listdir("inv/plot3d/flatmoho/bird-view/")
    file_list = [f"inv/plot3d/flatmoho/bird-view/{f}" for f in file_list if f.endswith(".csv")]
#    asyncio.run(add_depth_column_to_all_files(file_list))


    def make_file_for_plot(file_name: str, depth_points: int=80, **kwargs) -> None:
        if not isinstance(depth_points, int):
            raise ValueError("depth_points should be an integer.")
        if not isinstance(file_name, str):
            raise ValueError("file_name should be a string.")
        max_depth = kwargs.get("max_depth", depth_points)
        
        # lat, lon, depth, vp, vs, rho, ani
        df = pd.DataFrame(columns=["lat", "lon", "depth", "vp", "vs", "rho", "ani"])
        file_name_list = file_name.split("/")[-1].split(".csv")[0].split("%")
        sta_code = file_name_list[0]
        layers = file_name_list[1]
        lat = file_name_list[2]
        lon = file_name_list[3]
        depth = np.linspace(0, max_depth, depth_points)
        for i in depth:
            df = df.append({"lat": lat, "lon": lon, "depth": i, "vp": 0, "vs": 0, "rho": 0, "ani": 0}, ignore_index=True)
        print(df.head(10))
            
        
    make_file_for_plot(file_list[0], 80)
    
    