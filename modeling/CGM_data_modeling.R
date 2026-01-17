# first we load the necessary libraries
library(dplyr)
library(here)
# then we read in the clean data
CGM_data_clean <- read.csv(here("data_clean", "CGMdata_clean.csv"))

# further prepare the data for our binary logistic regession model

CGM_data_clean <- CGM_data_clean %>%
  mutate(
    start_ind  = as.integer(start_ind),   # must be 0/1
    patient_id = as.factor(patient_id)    # treat patient as categorical
  )

