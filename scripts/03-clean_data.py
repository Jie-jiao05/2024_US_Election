#### Preamble ####
# Purpose: Cleans the raw US elections polls dataset for analysis.
# Author: Aman Rana, Shanjie Jiao, Kevin Shen
# Date: 25 October 2024
# Contact: aman.rana@mail.utoronto.ca
# License: MIT
# Pre-requisites: `pandas` must be installed (pip install pandas)

#### Workspace setup ####
import pandas as pd
df = pd.read_csv('../data/01-raw_data/raw_data.csv')
#We are only interested in polls with a numeric grade of 3.0 or higher
df = df[df['numeric_grade'] >= 3.0]

df_lean = df[['pct', 'state', 'start_date', 'end_date' , 'pollscore', 'partisan', 'pollster_id', 'pollster' ,'party', 'sample_size']]
df_lean['partisan'].fillna('Non-Partisan', inplace=True)
df_lean['start_date'] = pd.to_datetime(df_lean['start_date'])
df_lean['end_date'] = pd.to_datetime(df_lean['end_date'])
df_lean = df_lean[df_lean['start_date'] >= '2024-07-21'].reset_index(drop=True)

#We are only interested in non-partisan pollsters
df_lean = df_lean[df_lean['partisan'] == 'Non-Partisan'].reset_index(drop=True)

#These pollsters were found to have very few observations in the exploratory step.
df_lean = df_lean[~df_lean['pollster_id'].isin([1492, 1704, 486, 1700, 1901])].reset_index(drop=True)

df_lean['end_date'] = df_lean['end_date'].dt.strftime('%m-%d-%Y')
df_lean[['pct', 'state', 'party', 'end_date', 'pollster', 'sample_size']].to_parquet('../data/02-analysis_data/analysis_data.parquet')