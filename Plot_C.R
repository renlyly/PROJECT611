# Shilin

# This is the code for  true boxplot 
# focus on prop2 and cell type proportion
# explore the different between case and control

library(tidyverse)


combined_data <- read_csv("data.csv")



boxplot1 <- ggplot(combined_data, aes(x=fct_inorder(visit_month), y=prop2_CD8,fill=Case)) +
  geom_boxplot(width = 1, position = position_dodge(width = 0.9),alpha=1)+
  geom_point(shape=16, position=position_jitterdodge(0.5),size=0.6,color='black',alpha=0.6)+
  ggtitle("")+
  theme(plot.title = element_text(color="black", size=16, face="bold.italic"))+
  labs(fill = "Group",x='Month',y='Proportion')+
  scale_fill_brewer(palette="Pastel1")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        plot.margin = margin(1, 0, 1, 1, "cm"),
        axis.title = element_text(size = 18),
        axis.text = element_text(size = 15),
        legend.text = element_text(size = 18),
        legend.title = element_text(size = 0))+
  theme(legend.position ="bottom")+
  theme(plot.margin = margin(0.1, 0.1, 0.1, 0.1, "cm"))

ggsave(filename = "box_plot_1.jpg", plot = boxplot1, device = "jpeg", width = 6.5, height = 5, units = "in", dpi = 300)
