
library(ggplot2)
library(factoextra) 

combined_data <- read_csv("data.csv")
combined_data[is.na(combined_data)] <- "Unknown"

# for pca
vars_to_include <- c("age_at_baseline", "sex", "race", "education_level_years", 
                     "tobacco_ever_used", 
                     "alcohol_ever_used", 
                     "prop2_B", "prop2_CD4", "prop2_CD8", 
                     "prop2_Monocytes", "prop2_NK", "prop2_Other")

data_for_pca <- combined_data[, vars_to_include]

# cate to binary
data_for_pca$sex <- as.numeric(as.factor(data_for_pca$sex))
# data_for_pca$race <- as.numeric(as.factor(data_for_pca$race))

data_for_pca$race <- as.factor(data_for_pca$race)
race_dummies <- model.matrix(~ race - 1, data = data_for_pca)
data_for_pca <- cbind(data_for_pca, as.data.frame(race_dummies))
data_for_pca$race <- NULL

data_for_pca$tobacco_ever_used <- as.numeric(as.factor(data_for_pca$tobacco_ever_used))
data_for_pca$alcohol_ever_used <- as.numeric(as.factor(data_for_pca$alcohol_ever_used))

data_for_pca$education_level_years <- factor(
  data_for_pca$education_level_years,
  levels = c("Unknown", "Less than 12 years", "12-16 years", "Greater than 16 years"),
  ordered = TRUE
)

data_for_pca$education_level_years  <- as.numeric(as.factor(data_for_pca$education_level_years ))

# standard
data_for_pca_scaled <- scale(data_for_pca)

pca_result <- prcomp(data_for_pca_scaled, center = TRUE, scale. = TRUE)
pca_result2 <- prcomp(data_for_pca_scaled[,-c(12:17)], center = TRUE, scale. = TRUE)


group_var <- combined_data$Case[!is.na(combined_data$Case)]  # 

# PCA plot
jpeg(filename = "PCA_plot1.jpg", width =8, height = 6, units = "in", res = 300)
fviz_pca_ind(pca_result,
             geom.ind = "point",   
             col.ind = group_var,  
             palette = c("#00AFBB", "#E7B800"),  
             addEllipses = FALSE,   
             legend.title = "Group") + labs(title = "PCA") + 
  theme_minimal()

dev.off()


jpeg(filename = "PCA_plot2.jpg", width = 8, height = 6, units = "in", res = 300)

fviz_pca_ind(pca_result2,
             geom.ind = "point",   
             col.ind = group_var,  
             palette = c("#00AFBB", "#E7B800"),  
             addEllipses = FALSE,   
             legend.title = "Group") + labs(title = "PCA-without-Race") + 
  theme_minimal()

dev.off()


jpeg(filename = "PCA_plot3.jpg", width = 8, height = 6, units = "in", res = 300)

fviz_pca_ind(pca_result,
             geom.ind = "point",   
             col.ind = as.factor(data_for_pca$raceWhite),  
             palette = c("#00AFBB", "#E7B800"),  
             addEllipses = FALSE,   
             legend.title = "White") + labs(title = "PCA-by-White") + 
  theme_minimal()

dev.off()
