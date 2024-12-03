
# generate box data sorted 
# box_data.R

library(tidyverse)
library(foreach)


combined_data<-read_csv("data.csv")
prop_all <- readRDS( "prop_all.rds")
prop2<-as.data.frame(prop_all$est_CT_prop2)# we used from imply(2), not used cibersort(1)
prop2_o<-prop2

# long table take the mean of cell type for meta data For box plot and plot about cell type:
subject_ID=combined_data$participant_id
subject_name<-unique(combined_data$participant_id) #572 patients 399 case
comp_prop_mtx=c()
for(i in 1:length(subject_name)){
  nm = subject_name[i]
  idx = which(subject_ID==nm)
  tmpm = prop2_o[idx,]
  tmpm_mean=apply(tmpm[,1:6],2,mean)
  comp_prop_mtx=rbind(comp_prop_mtx,tmpm_mean)
}
rownames(comp_prop_mtx)<-subject_name
head(comp_prop_mtx)

###make a comparison table for plot
t_comp_prop_mtx<-t(comp_prop_mtx)

Patient<-c(unlist(foreach(i=subject_name) %do% rep(i,6)))
Cell_type<-rep(colnames(comp_prop_mtx),length(subject_name))
Cell_prop=c(t_comp_prop_mtx[,1:ncol(t_comp_prop_mtx)])
comparsion<-data.frame(Patient,Cell_type,Cell_prop)

disease<-c(rep(NA,nrow(comparsion)))
comp_disease<-cbind(comparsion,disease)
case_ID<-unique(combined_data[which(combined_data$case==1),'participant_id']) 
comp_disease[,'disease'][which(comparsion$Patient %in% as.character(case_ID[[1]]))]='Case'
comp_disease[,'disease'][-which(comparsion$Patient %in% as.character(case_ID[[1]]))]='Control'


write_csv(comp_disease,"prop2_long.csv")



sorted_id <-comp_disease %>%
  arrange(factor(disease, levels = c("Control", "Case"))) %>%
  group_by(Patient, disease) %>%
  arrange(
    case_when(
      Cell_type == "B" & disease == "Control" ~ -Cell_prop,
      Cell_type == "B" & disease == "Case" ~ Cell_prop
    ),
    Cell_type
  ) %>%
  ungroup() %>%  
  select(Patient) %>%  
  distinct() %>%  # 
  slice_head(n = 572) %>%  # 
  pull(Patient)  # only Patient

comp_disease_sorted <- comp_disease %>%
  mutate(Patient = factor(Patient, levels = sorted_id)) %>%  # index
  arrange(Patient)  



#  get sort patient
control_length <- comp_disease_sorted %>% filter(disease == "Control") %>% 
  distinct(Patient, .keep_all = TRUE)  %>% pull(Patient) %>% length()
case__length <- comp_disease_sorted %>% filter(disease == "Case") %>% 
  distinct(Patient, .keep_all = TRUE)  %>% pull(Patient) %>% length()
start_value <- 0
end_value <- 20 

index1 <- seq(start_value, end_value, length.out = control_length)  
index2 <- seq(start_value+end_value, 2*end_value, length.out = case__length)

index <- c(rep(index1,each=6), rep(index2,each=6))

# 
comp_disease_sorted <- comp_disease_sorted %>% mutate(index=index)
# 
head(comp_disease_sorted)


write_csv(comp_disease_sorted,"prop2_sortl.csv")

