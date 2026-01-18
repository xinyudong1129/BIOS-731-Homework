# first we load the necessary libraries
library(dplyr)
library(scales)
library(tidyr)
library(ggplot2)
# then we read in the data with predicted values
CGM_data_pred <- read.csv(here("data", "CGMdata_pred.csv"))

# model analysis: confusion matrix visualization & interpretation

# first we recode the data into a clean dataframe 
cm_df <- CGM_data_pred %>%
  mutate(
    Truth = factor(start_ind, levels = c(0, 1)),
    Prediction = factor(pred_class, levels = c(0, 1))
  ) %>%
  count(Truth, Prediction, name = "n") %>%
  complete(Truth, Prediction, fill = list(n = 0))
# plot 1: confusion matrix by count
matrix_count <- ggplot(cm_df, aes(x = Prediction, y = Truth, fill = n)) +
  geom_tile(color = "white", linewidth = 1) +
  geom_text(aes(label = n), size = 6, fontface = "bold") +
  scale_fill_gradient(low = "lightblue", high = "navy", name = "Count") +
  labs(
    title = "Confusion Matrix (Counts)",
    subtitle = paste0("Threshold = ", threshold, ", Accuracy = ", round(accuracy, 3)),
    x = "Predicted class",
    y = "True class"
  ) +
  coord_equal() +
  theme_minimal(base_size = 14)


# plot 2: confusion matrix by proportion
cm_prop <- cm_df %>%
  group_by(Truth) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

matrix_prop <- ggplot(cm_prop, aes(x = Prediction, y = Truth, fill = prop)) +
  geom_tile(color = "white", linewidth = 1) +
  geom_text(aes(label = percent(prop, accuracy = 0.1)),
            size = 6, fontface = "bold") +
  scale_fill_gradient(low = "#FFF5F0", high = "#67000D",
                      labels = percent, name = "Row %") +
  labs(
    title = "Confusion Matrix (Row-normalized)",
    subtitle = paste0("Threshold = ", threshold, ", Accuracy = ", round(accuracy, 3)),
    x = "Predicted class",
    y = "True class"
  ) +
  coord_equal() +
  theme_minimal(base_size = 14)

# create directories and store the images
dir.create(here("results"), showWarnings = FALSE)
ggsave(
  filename = here("results", "confusion_matrix_counts.png"),
  plot     = p_count,
  width    = 7,
  height   = 6,
  dpi      = 300
)

ggsave(
  filename = here("results", "confusion_matrix_row_normalized.png"),
  plot     = p_prop,
  width    = 7,
  height   = 6,
  dpi      = 300
)



