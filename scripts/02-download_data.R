#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
#### Workspace setup ####
library(dplyr)
library(readr)

#### Load data from Desktop ####
# Define the file path to your dataset on the Desktop
local_dataset_path <- "~/Desktop/president_polls.csv"

# Load the dataset (from Desktop in this case)
loaded_data <- read_csv(local_dataset_path)

#### Save data to project directory ####
# Define the output path relative to your GitHub project structure
output_file <- "data/01-raw_data/raw_data.csv"

# Write the loaded data to the specified path in your project directory
write_csv(loaded_data, output_file)
