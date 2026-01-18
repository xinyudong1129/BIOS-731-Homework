# BIOS 731 Homework 1 Xinyu Dong:
# Continuous Glucose Monitoring Data Analysis and Prediction

## Data Description and Question of Interest:

The *CGMdata.csv* dataset is a perturbed and truncated toy dataset of Continuous Glucose Measurements based (rather loosely) off real-world readings of glucose levels of patients residing in the Emory healthcare system. In real world scenarios, though the patient is monitored closely during their occupancy in a hospital, due to technical reasons the glucose readings may be partially *missing*. Ideally we could predict the start of these missing intervals and perform data imputation as a next step. 

Variables in the original dataset include:

-   **patient_id**: the encoded patient id of a patient, patient id differs across patients and are categorical.

-   **glucose**: a single numeric continuous glucose reading of a patient at time *t*, where t is indicated by the variable *time*.

-   **time**: the time of the glucose reading in minutes from baseline observation.

-   *x1*: an unknown feature variable in numerical form. Its value remains constant in patient, and could differ across patients.

-   *x2*: an unknown feature variable in numerical form. Its value remains constant in patient, and could differ across patients.


For simplicity, this analysis focuses on variables patient_id, glucose, and time only. The research question of this analysis is: Can we use a reasonable statistical method to accurately predict the start of a missing interval in the glucose readings of patients? What is the accuracy of prediction?

## Workflow and file structure:

### `data/`  
Stores raw dataset and intermediate output data used throughout the project. Also contains the data cleaning script.

- **`CGMdata.csv`**  
  Original dataset downloaded from the source.

- **`CGMdata_clean.csv`**  
  Cleaned and organized dataset ready for further analysis.

- **`CGMdata_pred.csv`**  
  Contains results from both the clean data and predicited and fitted values after fitting the binary logistic regression model.
  
- **`CGMdata.csv`**
  The data cleaning script that processes the `CGMdata.csv` raw data file and should produce an exact match to `CGMdata_clean.csv`.

### `modeling/`  
Contains the modeling script.

- **`CGM_data_modeling.R`**
  The data modeling script that processes the `CGMdata_clean.csv` clean data file and should produce an exact match to `CGMdata_pred.csv`.

### `visualization/`  
Contains the visualization script.

- **`CGM_data_visualization.R`**
  The data visualization script that processes the `CGMdata_pred.csv` prediction data file and should produce an exact match to plots in the results folder.

### `results/`  
Contains the visualization results, stored as two .png files.

- **`confusion_matrix_counts.png`**
  The data visualization result for a confusion matrix by raw counts.
  
- **`confusion_matrix_row_normalized.png`**
  The data visualization result for a confusion matrix by row normalization.

### `final report/`  
Contains the final Rmd report and rendered outputs:

- **`CGM_analysis_report.Rmd`**
  An R Markdown file containing the full analysis pipeline.
- **`CGM_analysis_report.pdf`**
  A rendered PDF version of the report.

## Session Information:
The following is the output of **`sessionInfo()`** used for this analysis:
```{r}
> sessionInfo()
R version 4.4.2 (2024-10-31 ucrt)
Platform: x86_64-w64-mingw32/x64
Running under: Windows 10 x64 (build 19045)

Matrix products: default


locale:
[1] LC_COLLATE=English_United States.utf8  LC_CTYPE=English_United States.utf8   
[3] LC_MONETARY=English_United States.utf8 LC_NUMERIC=C                          
[5] LC_TIME=English_United States.utf8    

time zone: America/New_York
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] scales_1.4.0  tidyr_1.3.1   ggplot2_4.0.0 here_1.0.1    dplyr_1.1.4  

loaded via a namespace (and not attached):
 [1] bit_4.5.0.1        gtable_0.3.6       crayon_1.5.3       compiler_4.4.2    
 [5] tidyselect_1.2.1   parallel_4.4.2     dichromat_2.0-0.1  systemfonts_1.2.1 
 [9] textshaping_1.0.0  yaml_2.3.10        fastmap_1.2.0      readr_2.1.5       
[13] R6_2.6.1           labeling_0.4.3     generics_0.1.4     knitr_1.50        
[17] tibble_3.2.1       rprojroot_2.0.4    tzdb_0.5.0         pillar_1.11.0     
[21] RColorBrewer_1.1-3 rlang_1.1.4        xfun_0.54          S7_0.2.0          
[25] bit64_4.5.2        cli_3.6.3          withr_3.0.2        magrittr_2.0.3    
[29] digest_0.6.37      grid_4.4.2         vroom_1.6.5        rstudioapi_0.17.1 
[33] hms_1.1.3          lifecycle_1.0.4    vctrs_0.6.5        evaluate_1.0.4    
[37] glue_1.8.0         farver_2.1.2       ragg_1.3.3         rmarkdown_2.29    
[41] purrr_1.0.2        tools_4.4.2        pkgconfig_2.0.3    htmltools_0.5.8.1 
```


