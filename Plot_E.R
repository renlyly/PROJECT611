# E 

# Shilin Yu
# Plot_E.R
# ROC plot

library(tidyverse)
library(pROC)

combined_data <- read_csv("data.csv")
#subject_name<-unique(combined_data$participant_id)

####F####
roc_obj <- roc(combined_data$case, combined_data$prop2_CD8) # 2prop
auc_val <- auc(roc_obj)
ci_auc <- ci.auc(roc_obj)
ci_lower <- ci_auc[1]
ci_upper <- ci_auc[3]


jpeg(filename = "ROC_CD8.jpg", width = 5.2, height = 5, units = "in", res = 300)

plot(1 - roc_obj$specificities, roc_obj$sensitivities, type = 'l', 
     main = "", xlab = "1 - Specificity", ylab = "Sensitivity", cex.axis = 1.3, cex.lab = 1.5,
     xlim = c(0, 1), lty = 1, col = '#998ec3', lwd = 2.5)
abline(0, 1, col = 'black', lty = 2)
# auc and ci
auc_text <- sprintf("AUC = %.3f (95%% CI: %.3f - %.3f)", auc_val, ci_lower, ci_upper)
text(x = 0.01, y = 0.95, labels = auc_text, cex = 0.8, adj = 0)

dev.off()