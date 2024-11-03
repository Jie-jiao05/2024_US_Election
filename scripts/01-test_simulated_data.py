#### Preamble ####
# Purpose: Tests the structure and validity of the simulated US elections polls dataset.
# Author: Aman Rana, Shanjie Jiao, Kevin Shen
# Date: 02 November 2024
# Contact: aman.rana@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - `pandas` must be installed (pip install pandas)
# - `numpy` must be installed (pip install numpy)

#### Workspace setup ####
import pandas as pd

# Load the simulated data
analysis_data = pd.read_parquet("../data/00-simulated_data.parquet")

# Test if the data was successfully loaded
if 'analysis_data' in locals():
    print("Test Passed: The dataset was successfully loaded.")
else:
    raise Exception("Test Failed: The dataset could not be loaded.")

#### Test data ####

# Check if the dataset has 500 rows
if len(analysis_data) == 500:
    print("Test Passed: The dataset has 500 rows.")
else:
    raise Exception("Test Failed: The dataset does not have 500 rows.")

# Check if the dataset has 7 columns
expected_columns = ['pct', 'pollster', 'party', 'state', 'partisan', 'days_to_election', 'poll_score']
if list(analysis_data.columns) == expected_columns:
    print("Test Passed: The dataset has the expected columns.")
else:
    raise Exception("Test Failed: The dataset does not have the expected columns.")

# Check if all values in the 'pollster' column are valid
valid_pollsters = ["Pollster_A", "Pollster_B", "Pollster_C", "Pollster_D", "Pollster_E"]
if all(analysis_data['pollster'].isin(valid_pollsters)):
    print("Test Passed: The 'pollster' column contains only valid pollster names.")
else:
    raise Exception("Test Failed: The 'pollster' column contains invalid pollster names.")

# Check if the 'party' column contains only valid party names
valid_parties = ["DEM", "REP"]
if all(analysis_data['party'].isin(valid_parties)):
    print("Test Passed: The 'party' column contains only valid party names.")
else:
    raise Exception("Test Failed: The 'party' column contains invalid party names.")

# Check if the 'state' column contains only valid US state names
valid_states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut",
                "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
                "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
                "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
                "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
                "Wisconsin", "Wyoming"]
if all(analysis_data['state'].isin(valid_states)):
    print("Test Passed: The 'state' column contains only valid US state names.")
else:
    raise Exception("Test Failed: The 'state' column contains invalid state names.")

# Check if the 'partisan' column contains only valid values
valid_partisan_bias = ["REP", "DEM", 0]
if all(analysis_data['partisan'].isin(valid_partisan_bias)):
    print("Test Passed: The 'partisan' column contains only valid values.")
else:
    raise Exception("Test Failed: The 'partisan' column contains invalid values.")

# Check if there are any missing values in the dataset
if analysis_data.isnull().sum().sum() == 0:
    print("Test Passed: The dataset contains no missing values.")
else:
    raise Exception("Test Failed: The dataset contains missing values.")

# Check if the 'pct' values are within the range of 30 to 70
if all(analysis_data['pct'].between(30, 70)):
    print("Test Passed: All 'pct' values are between 30 and 70.")
else:
    raise Exception("Test Failed: There are 'pct' values outside the range of 30 to 70.")

# Check if the 'days_to_election' values are between 1 and 365
if all(analysis_data['days_to_election'].between(1, 365)):
    print("Test Passed: All 'days_to_election' values are between 1 and 365.")
else:
    raise Exception("Test Failed: There are 'days_to_election' values outside the range of 1 to 365.")

# Check if the 'poll_score' values are between -3 and 3
if all(analysis_data['poll_score'].between(-3, 3)):
    print("Test Passed: All 'poll_score' values are between -3 and 3.")
else:
    raise Exception("Test Failed: There are 'poll_score' values outside the range of -3 to 3.")