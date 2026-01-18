# BIOS 731 Homework 1 Xinyu Dong:
## Continuous Glucose Monitoring Data Analysis and Prediction

The *CGMdata.csv* dataset is a perturbed and truncated toy dataset of Continuous Glucose Measurements based (rather loosely) off real-world readings of glucose levels of patients residing in the Emory healthcare system. In real world scenarios, though the patient is monitored closely during their occupancy in a hospital, due to technical reasons the glucose readings may be partially *missing*. Ideally we could predict the start of these missing intervals and perform data imputation as a next step. 

Variables in the original dataset include:

-   **patient_id**: the encoded patient id of a patient, patient id differs across patients and are categorical.

-   **glucose**: a single numeric continuous glucose reading of a patient at time *t*, where t is indicated by the variable *time*.

-   **time**: the time of the glucose reading in minutes from baseline observation.

-   *x1*: an unknown feature variable in numerical form. Its value remains constant in patient, and could differ across patients.

-   *x2*: an unknown feature variable in numerical form. Its value remains constant in patient, and could differ across patients.


For simplicity, this analysis focuses on variables patient_id, glucose, and time only. The research question of this analysis is: Can we use a reasonable statistical method to accurately predict the start of a missing interval in the glucose readings of patients? What is the accuracy of prediction?

