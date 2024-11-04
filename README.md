# Starter folder

## Overview

This repository includes the files and code used to develop a Bayesian Spline model predicting the outcome of the upcoming US presidential election using aggregated polling data. The project involves data cleaning, analysis, and modeling from sources like FiveThirtyEight and Survey design. The analysis examines the impact of factors such as pollster ratings, sample size, and poll scores on the predicted vote percentage for Kamala Harris through looking at the democratic party.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from FiveThirtyEight.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage
LLM are used in this Work.
ChatGPT was used to critique the result section, for plotting in R, and for code review.
Copilot was used in the python sections for adhoc code completion.
The entire chat history is available in inputs/llms/usage.txt.

## Data Reference
FiveThirtyEight: https://projects.fivethirtyeight.com/polls/president-general/2024/national/
