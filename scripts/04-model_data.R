library(tidyverse)
library(janitor)
library(lubridate)
library(broom)
library(modelsummary)
library(rstanarm)
library(splines)

data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

dem_data <- data |>
  filter(
    party == "DEM",
  ) |>
  mutate(
    state = if_else(is.na(state), "National", state),
    end_date = mdy(end_date)
  ) |>
  mutate(
    num_dem = round((pct / 100) * sample_size, 0)
  )

rep_data <- data |>
  filter(
    party == "REP",
  ) |>
  mutate(
    state = if_else(is.na(state), "National", state),
    end_date = mdy(end_date)
  ) |>
  mutate(
    num_rep = round((pct / 100) * sample_size, 0)
  )


dem_data <- dem_data |>
  mutate(
    pollster = factor(pollster),
    state = factor(state)
  )

rep_data <- rep_data |>
  mutate(
    pollster = factor(pollster),
    state = factor(state)
  )

# Change date to be number of days since she declared - it's a counter not a date
dem_data <- dem_data |>
  mutate(
    end_date_num = as.numeric(end_date - min(end_date))
  )

rep_data <- rep_data |>
  mutate(
    end_date_num = as.numeric(end_date - min(end_date))
  )

# Fit Bayesian model with spline and pollster as fixed effect
# cf bayesian_model_1 and bayesian_model_2 where it's a random effect - note the different interpretations
spline_model <- stan_glm(
  pct ~ ns(end_date_num, df = 5) + pollster, # Change df for the number of "bits" - higher numbers - more "wiggly" - but then need to worry about overfitting.
  data = dem_data,
  family = gaussian(),
  prior = normal(0, 5),
  prior_intercept = normal(50, 10),
  seed = 1234,
  iter = 2000,
  chains = 4,
  refresh = 0
)

rep_spline_model <- stan_glm(
  pct ~ ns(end_date_num, df = 5) + pollster, # Change df for the number of "bits" - higher numbers - more "wiggly" - but then need to worry about overfitting.
  data = rep_data,
  family = gaussian(),
  prior = normal(0, 5),
  prior_intercept = normal(50, 10),
  seed = 1234,
  iter = 2000,
  chains = 4,
  refresh = 0
)

# Summarize the model
summary(spline_model)
summary(rep_spline_model)

# Posterior predictive checks
pp_check(spline_model)
pp_check(rep_spline_model)

# Predict and plot
# Create new data for prediction
new_data <- data.frame(
  end_date_num = seq(
    min(dem_data$end_date_num),
    max(dem_data$end_date_num),
    length.out = 100
  ),
  pollster = factor("YouGov", levels = levels(dem_data$pollster))
)
rep_new_data <- data.frame(
  end_date_num = seq(
    min(dem_data$end_date_num),
    max(dem_data$end_date_num),
    length.out = 100
  ),
  pollster = factor("YouGov", levels = levels(dem_data$pollster))
)

# Predict posterior draws
posterior_preds <- posterior_predict(spline_model, newdata = new_data)
rep_posterior_preds <- posterior_predict(rep_spline_model, newdata = rep_new_data)


# Summarize predictions
pred_summary <- new_data |>
  mutate(
    pred_mean = colMeans(posterior_preds),
    pred_lower = apply(posterior_preds, 2, quantile, probs = 0.025),
    pred_upper = apply(posterior_preds, 2, quantile, probs = 0.975)
  )

rep_pred_summary <- rep_new_data |>
  mutate(
    pred_mean = colMeans(rep_posterior_preds),
    pred_lower = apply(rep_posterior_preds, 2, quantile, probs = 0.025),
    pred_upper = apply(rep_posterior_preds, 2, quantile, probs = 0.975)
  )

### Plot the spline fit####
ggplot(dem_data, aes(x = end_date_num, y = pct, color = pollster)) +
  geom_point() +
  geom_line(
    data = pred_summary,
    aes(x = end_date_num, y = pred_mean),
    color = "blue",
    inherit.aes = FALSE
  ) +
  geom_ribbon(
    data = pred_summary,
    aes(x = end_date_num, ymin = pred_lower, ymax = pred_upper),
    alpha = 0.2,
    inherit.aes = FALSE
  ) +
  labs(
    x = "Days since earliest poll",
    y = "Percentage",
    title = "Poll Percentage over Time with Spline Fit"
  ) +
  theme_minimal()

### Plot the spline fit
ggplot(rep_data, aes(x = end_date_num, y = pct, color = pollster)) +
  geom_point() +
  geom_line(
    data = pred_summary,
    aes(x = end_date_num, y = pred_mean),
    color = "blue",
    inherit.aes = FALSE
  ) +
  geom_ribbon(
    data = pred_summary,
    aes(x = end_date_num, ymin = pred_lower, ymax = pred_upper),
    alpha = 0.2,
    inherit.aes = FALSE
  ) +
  labs(
    x = "Days since earliest poll",
    y = "Percentage",
    title = "Poll Percentage over Time with Spline Fit"
  ) +
  theme_minimal()
###
colnames(dem_data)[colnames(dem_data) == "num_dem"] <- "num"
colnames(rep_data)[colnames(rep_data) == "num_rep"] <- "num"

# Combine the data
combined_data <- rbind(dem_data, rep_data)
pred_summary$party <- "DEM"
rep_pred_summary$party <- "REP"
# Combine prediction summaries
pred_summary_combined <- rbind(pred_summary, rep_pred_summary)

# Plot with ggplot
ggplot(combined_data, aes(x = end_date_num, y = pct, color = party)) +
  geom_point(aes(shape = pollster)) +
  geom_line(
    data = pred_summary_combined,
    aes(x = end_date_num, y = pred_mean, color = party),
    inherit.aes = FALSE
  ) +
  geom_ribbon(
    data = pred_summary_combined,
    aes(x = end_date_num, ymin = pred_lower, ymax = pred_upper, fill = party),
    alpha = 0.2,
    inherit.aes = FALSE
  ) +
  labs(
    x = "Days since earliest poll",
    y = "Percentage",
    title = "Poll Percentage over Time with Spline Fit"
  ) +
  scale_color_manual(values = c("blue", "red")) +
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()
