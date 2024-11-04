#### Preamble ####
# Purpose: Simulates a dataset of polls for the outcomes of the US elections
# Author: Aman Rana,Shanjie Jiao, Kevin Shen
# Date: 02 November 2024
# Contact: aman.rana@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - `pandas` must be installed (pip install pandas)
import pandas as pd
import numpy as np

# Constants for simulation
pollsters = ["Pollster_A", "Pollster_B", "Pollster_C", "Pollster_D", "Pollster_E"]
parties = ["DEM", "REP"]
partisan_bias = ["REP", "DEM", 0]
states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut",
          "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
          "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
          "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
          "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
          "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
          "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
          "Wisconsin", "Wyoming"]

# Number of data points to simulate
num_rows = 500
np.random.seed(0)  # For reproducibility
if __name__ == "__main__":
    # Simulating data
    data = {
        "pct": np.random.uniform(30, 70, num_rows),  # Percentage between 30 and 70
        "pollster": np.random.choice(pollsters, num_rows),  # Randomly chosen pollster
        "party": np.random.choice(parties, num_rows),  # Randomly chosen party
        "state": np.random.choice(states, num_rows),  # Randomly chosen state
        "partisan": np.random.choice(partisan_bias, num_rows),  # Random partisan bias
        "days_to_election": np.random.randint(1, 366, num_rows),  # Days to election between 1 and 365
        "poll_score": np.random.uniform(-3, 3, num_rows)  # Poll score between -3 and +3
    }
    #### Save data ####
    df = pd.DataFrame(data)
    df.to_parquet("../data/00-simulated_data/simulated_poll_data.parquet", index=False)
