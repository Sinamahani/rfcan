"""
Author: Sina Sabermahani (2024)
Description: for plotting 3d, we need to have depth column in the csv files.
            This script adds the depth column to all the csv files in the specified directory.
"""


import pandas as pd
import os
import asyncio

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
    asyncio.run(add_depth_column_to_all_files(file_list))