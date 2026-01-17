# first we load the necessary libraries
library(dplyr)
library(here)
# then we read in the clean data
CGM_data_clean <- read.csv(here("data_clean", "CGMdata_clean.csv"))

# 1) further prepare the data for our binary logistic regression model

CGM_data_clean <- CGM_data_clean %>%
  mutate(
    start_ind  = as.integer(start_ind),   # must be 0/1
    patient_id = as.factor(patient_id)    # treat patient as categorical variables
  )

# 2) Build a formula: start_ind ~ (all columns except start_ind and ind)
predictor_names <- setdiff(names(CGM_data_clean), c("start_ind", "ind"))
form <- as.formula(paste("start_ind ~", paste(predictor_names, collapse = " + ")))

# 3) Fit logistic regression
fit_logit <- glm(
  formula = form,
  data    = CGM_data_clean,
  family  = binomial(link = "logit")
)

summary(fit_logit)

# 4) Odds ratios + 95% CI
OR  <- exp(coef(fit_logit))
CI  <- exp(confint(fit_logit))
OR_table <- cbind(OR = OR, CI_low = CI[, 1], CI_high = CI[, 2])
OR_table

# 5) Predicted probabilities
CGM_data_clean <- CGM_data_clean %>%
  mutate(pred_prob = predict(fit_logit, type = "response"))

# 6) Gain prediction probabilities

threshold <- 0.5

CGM_data_clean$pred_class <- ifelse(
  CGM_data_clean$pred_prob >= threshold,
  1, 0
)

accuracy <- mean(
  CGM_data_clean$pred_class == CGM_data_clean$start_ind
)

accuracy

table(
  Truth      = CGM_data_clean$start_ind,
  Prediction = CGM_data_clean$pred_class
)
  
#store predicted data results under folder modeling
dir.create(here("modeling"), showWarnings = FALSE)
write.csv(
  CGM_data_clean,
  file = here("modeling", "CGMdata_pred.csv"),
  row.names = FALSE
)