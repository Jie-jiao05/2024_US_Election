#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_data <- read_csv("~/2024_US_Election/data/01-raw_data/raw_data.csv")

cleaned_data <- raw_data %>%
  filter(transparency_score > 3) %>%
  select(pollster_id, pollster, methodology, numeric_grade, pollscore, sample_size, pct, party, answer) %>%
  mutate(
    # Transform 'party' into categorical: 0 for 'DEM' and 1 for 'REP'
    party = ifelse(party == "DEM", 0, ifelse(party == "REP", 1, NA)),
    
    # Transform 'answer' into categorical: 0 for 'Harris' and 1 for 'Trump'
    answer = ifelse(answer == "Harris", 0, ifelse(answer == "Trump", 1, NA))
  )

#### Save data ####
write_csv(cleaned_data, "~/2024_US_Election/data/02-analysis_data/analysis_data.csv")
