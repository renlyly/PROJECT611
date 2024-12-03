
# Figure A 
# Plot_A.R
# Shilin
# barplot
# check for error if write as output in boxplot
# package need:

library(ggnewscale)
library(tidyverse)
comp_disease<-read_csv("prop2_long.csv")

# prepared for plot Boxplot and scatter plot
####A comparison barplot case vs. control######
barplot <- ggplot(comp_disease, aes(fill=fct_reorder(Cell_type,Cell_prop,.desc=TRUE), y=Cell_prop, x=fct_reorder(Patient,Cell_prop,.desc=TRUE))) + 
  geom_bar(position="fill", stat="identity") +
  scale_fill_manual(values=c("#FC8D62",'springgreen3','skyblue', 'gold2','mediumpurple1',"#E78AC3"))+
  facet_wrap(~disease,scales = 'free_x') +
  scale_y_continuous(expand = c(0, 0)) +
  theme(axis.text = element_text(size = 14), 
        axis.title.x = element_text(size = 16),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        axis.title.y = element_text(size = 16),
        legend.text = element_text(size = 14))+
  theme(legend.position ="bottom",legend.title = element_text(size=16)) + 
  guides(fill= guide_legend(nrow = 1,byrow = T))+      
  xlab('Subject')+ylab("Proportion")+labs(fill='Celltype')+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),plot.margin = margin(0.1, 0.1, 0.1, 0.1, "cm"))

ggsave(filename = "bar_plot.jpg", plot = barplot, device = "jpeg", width = 10, height = 6, units = "in", dpi = 300)



#  A2

comp_disease_sorted<-read_csv("prop2_sortl.csv")


barplotsort <- ggplot(comp_disease_sorted, aes(fill = Cell_type, y = Cell_prop, x = Patient)) + 
  geom_bar(position="fill", stat="identity") +
  scale_fill_manual(values=c("#FC8D62",'springgreen3','skyblue', 'gold2','mediumpurple1',"#E78AC3"), name = "Cell type")+
  ylab("Proportion") +
  new_scale_fill() +
  geom_tile(comp_disease_sorted, mapping = aes(x = Patient, y = 1.07, fill = factor(comp_disease_sorted$disease, levels = c("Control","Case")), height = 0.08),show.legend = FALSE) + 
  geom_segment(aes(x =length(comp_disease_sorted[which(comp_disease_sorted$disease == "Control"),]$Patient)/6, y = 0, 
                   xend = length(comp_disease_sorted[which(comp_disease_sorted$disease == "Control"),]$Patient)/6, yend = 1)) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_brewer(name = "Disease", labels = c("Control", "Case"), palette = "Pastel2")  +
  theme(axis.text = element_text(size = 14), 
        axis.title.x = element_text(size = 16),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        axis.title.y = element_text(size = 16),
        legend.text = element_text(size = 12)) + 
  theme(legend.position ="bottom",legend.title = element_text(size=16)) + 
  guides(fill= guide_legend(nrow = 1,byrow = T))+      
  xlab('Subject')+ylab("Proportion")+labs(fill='Celltype')+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),plot.margin = margin(0.1, 0.1, 0.1, 0.1, "cm"))


ggsave(filename = "bar_plot_sort.jpg", plot = barplotsort, device = "jpeg", width = 10, height = 6, units = "in", dpi = 300)

#  A3
barplotsort2 <- ggplot(comp_disease_sorted, aes(fill = Cell_type, y = Cell_prop, x = index)) + 
  geom_bar(position = "fill", stat = "identity", width = 0.2) +  # 确保宽度为 1，使柱子之间无空隙
  scale_fill_manual(values = c("#FC8D62", 'springgreen3', 'skyblue', 'gold2', 'mediumpurple1', "#E78AC3"),name = "Cell type" ) +
  ylab("Proportion") +
  
  new_scale_fill() +
  
  # use  `index` for both `geom_tile` and `geom_bar` 
  geom_tile(mapping = aes(x = index-0.2, y = 1.05, fill = factor(disease, levels = c("Control", "Case")), height = 0.1), 
            width = 0.2,show.legend = FALSE) +  # width to avoid gap 
  scale_fill_brewer(name = "Disease", labels = c("Control", "Case"), palette = "Pastel2") +
  
  # vline in black
  geom_vline(xintercept = comp_disease_sorted$index[sum(comp_disease_sorted$disease=="Control")], 
             color = "black", linetype = "dashed") +
  
  scale_y_continuous(expand = c(0, 0)) +
  
  theme(
    axis.text = element_text(size = 14), 
    axis.title.x = element_text(size = 16),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank(),
    axis.title.y = element_text(size = 16),
    legend.text = element_text(size = 12),
    legend.position = "bottom",
    legend.title = element_text(size = 16),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    plot.margin = margin(0.1, 0.1, 0.1, 0.1, "cm")
  ) +
  guides(fill = guide_legend(nrow = 1, byrow = TRUE)) +      
  xlab('Subject') + ylab("Proportion") + labs(fill = 'Celltype')+
  xlim(0,40)

# save
ggsave(filename = "bar_plot_sort2.jpg", plot = barplotsort2, device = "jpeg", width = 8, height = 7, units = "in", dpi = 300)





