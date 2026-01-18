# first we load the necessary libraries
library(dplyr)
library(here)
# then we read in the clean data
CGM_data_clean <- read.csv(here("data", "CGMdata_clean.csv"))

# 1) further prepare the data for our binary logistic regression model

idx <- sample(seq_len(nrow(CGM_data_clean)), size = 0.7 * nrow(CGM_data_clean))

CGM_data_clean <- CGM_data_clean %>%
  mutate(
    start_ind  = as.integer(start_ind),   # must be 0/1
    patient_id = as.factor(patient_id)    # treat patient as categorical variables
  )


train_data <- CGM_data_clean[idx, ]
valid_data <- CGM_data_clean[-idx, ]

# 2) Build a formula: start_ind ~ (all columns except start_ind and ind)
predictor_names <- setdiff(names(CGM_data_clean), c("start_ind", "ind"))
form <- as.formula(paste("start_ind ~", paste(predictor_names, collapse = " + ")))

# 3) Fit logistic regression
fit_logit <- glm(
  formula = form,
  data    = train_data,
  family  = binomial(link = "logit")
)

summary(fit_logit)

# 4) Predicted probabilities
valid_data <- valid_data %>%
  mutate(pred_prob = predict(fit_logit, newdata = valid_data, type = "response"))

# 5) Gain prediction probabilities

threshold <- 0.5

valid_data <- valid_data %>%
  mutate(pred_class = ifelse(pred_prob >= threshold, 1L, 0L))


accuracy_val <- mean(valid_data$pred_class == valid_data$start_ind)
cat("\nValidation accuracy:", round(accuracy_val, 4), "\n\n")

cm <- table(
  Truth      = valid_data$start_ind,
  Prediction = valid_data$pred_class
)
print(cm)
  
#store predicted data results under folder data
#dir.create(here("modeling"), showWarnings = FALSE)

write.csv(
  valid_data,
  file = here("data", "CGMdata_pred.csv"),
  row.names = FALSE
)
