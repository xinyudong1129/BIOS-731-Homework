# first we load the necessary libraries
library(dplyr)
library(here)
# then we read in a data in a generalized format
CGM_data <- read.csv(here("data", "CGMdata.csv"))
CGM_data <- CGM_data[, 1:3]

#missing data are not clearly labeled in the data set, but rather, truncated. 

#I'll fill in the missing time stamps (not shown in the original dataset) 
#and create an indicator binary variable to indicate missingness.

unique_names <- unique(CGM_data$patient_id)
CGM_data$ind <- 1
CGM_data$start_ind <- 0
CGM_data_updated <- CGM_data

for (name in unique_names){
  for(i in 1:(nrow(CGM_data)-1)){
    if ((CGM_data[i,]$patient_id == name) & (CGM_data[i+1,]$patient_id == name)){
      time_stamp_current <- CGM_data[i,"time"]
      time_stamp_next <- CGM_data[i+1,"time"]
      if(time_stamp_next - time_stamp_current != 5){
        for(adds in 1:((time_stamp_next - time_stamp_current)/5-1)){
          if(adds == 1){
            new_row <- data.frame("patient_id" = name, "glucose" = 0, "time" =                                                   time_stamp_current+5*adds, "ind" = 0, "start_ind" = 1)
          }
          else{
            new_row <- data.frame("patient_id" = name, "glucose" = 0, "time" =                                                   time_stamp_current+5*adds, "ind" = 0, "start_ind" = 0)
          }
          CGM_data_updated <- rbind(CGM_data_updated, new_row)
        }
        
      }
    }
  }
}

CGM_data_sorted <- CGM_data_updated %>% 
  group_by(patient_id) %>%           
  arrange(time, .by_group = TRUE)

#CGM_data_sorted

#sanity check: did we add the data lines in correctly?

#we check if the lines are added such that each data line differs in terms of 
#time by five minutes, and that the initial time stamp for each new patient id is 0.

#if satisfied, the function would print out "TRUE".
unique_names <- unique(CGM_data$patient_id)
flag <- CGM_data_sorted %>%
  arrange(patient_id, time) %>%                
  group_by(patient_id) %>%
  mutate(
    dt  = lead(time) - time,                     
    ok1 = is.na(dt) | dt == 5,                   
    ok2 = lead(patient_id, default = patient_id[1]) == patient_id |
      lead(time, default = 0) == 0    
  ) %>%
  summarise(all_good = all(ok1 & ok2)) %>%
  summarise(flag = all(all_good)) %>%            
  pull(flag)

print(flag)

#create new directory and store clean data under folder data_clean
dir.create(here("data_clean"), showWarnings = FALSE)
write.csv(
  CGM_data_sorted,
  file = here("data_clean", "CGMdata_clean.csv"),
  row.names = FALSE
)

write.csv(
  CGM_data_sorted,
  file = here("data", "CGMdata_clean.csv"),
  row.names = FALSE
)
