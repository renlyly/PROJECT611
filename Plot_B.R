####B####

# Shilin

# This is the code for corr plot
# focus on prop2 and cell type proportion
#explore the correction between cell-type proportion
library(tidyverse)
library(corrplot)
prop_meta <- read_csv("Prop_imply.csv")
correlations <- cor(prop_meta[,c(1:6)])
# Open a JPEG graphics device

jpeg(filename = "cor_plot.jpg", width = 6, height = 6, units = "in", res = 300)

# Generate the correlation plot
corrplot(correlations, method = "circle", tl.cex = 1.5, cl.cex = 1.2,
         tl.col = 'black', cl.pos = 'b', tl.srt = 60)

# Close the graphics device
dev.off()

