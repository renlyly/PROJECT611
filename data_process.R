
# Data processing
# data_process.R
# Shilin Yu
# Generate all the data we need in later analysis
# prop_all.rds and PDBP_metadata.csv are initial dataset.

# Q: X col is what? 

## package 
library(tidyverse)
library(foreach)

#
prop_all <- readRDS( "prop_all.rds")
metadata<-read_csv('PDBP_metadata.csv',col_names = T) #2599 5 tibble
prop1<-as.data.frame(prop_all$est_CT_prop1)
prop2<-as.data.frame(prop_all$est_CT_prop2)# we used from imply(2), not used cibersort(1)
write.csv(prop2,"Prop_imply.csv")
prop2_o<-prop2
# Prop_imply used for show imply results

metadata <- metadata %>%  arrange(participant_id, visit_month)
metadata <- metadata %>%  unite("sample_ID_match", participant_id, visit_month, sep = "_", remove = FALSE) %>%
  select(-...1) %>%  select(sample_ID_match, everything())
write_csv(metadata[,-which(colnames(metadata) == "smoked_100_more_cigarettes")],"meta.csv")


prop1 <- as_tibble(prop1)
prop2 <- as_tibble(prop2)
prop1 <- prop1 %>%
  rename_with(~ paste0("prop1_", .), everything()) 
prop2 <- prop2 %>%
  rename_with(~ paste0("prop2_", .), everything()) 
combined_data <- bind_cols(metadata, prop1, prop2)

combined_data <- combined_data %>%
  column_to_rownames(var = colnames(combined_data)[1])


combined_data$visit_month <- as.factor(combined_data$visit_month)
combined_data$Case <- NA
combined_data$Case[combined_data$case == 1] <- 'Case'
combined_data$Case[combined_data$case == 0] <- 'Control'

write_csv(combined_data,"data.csv")




##### 1 ####
# long table take the mean of cell type for meta data For bar plot and plot about cell type:
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
case_ID<-unique(combined_data[,'participant_id'][which(combined_data$case==1)])#399
comp_disease[,'disease'][which(comparsion$Patient %in% case_ID)]='Case'
comp_disease[,'disease'][-which(comparsion$Patient %in% case_ID)]='Control'




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
  distinct() %>%  # unique
  slice_head(n = 572) %>%  
  pull(Patient)  # only patient

comp_disease_sorted <- comp_disease %>%
  mutate(Patient = factor(Patient, levels = sorted_id)) %>%  # 将 Patient 转换为因子类型，按 sorted_id 顺序排列
  arrange(Patient)  



# 1. Control 和 Case 
control_length <- comp_disease_sorted %>% filter(disease == "Control") %>% 
  distinct(Patient, .keep_all = TRUE)  %>% pull(Patient) %>% length()
case__length <- comp_disease_sorted %>% filter(disease == "Case") %>% 
  distinct(Patient, .keep_all = TRUE)  %>% pull(Patient) %>% length()
start_value <- 0
end_value <- 20 

index1 <- seq(start_value, end_value, length.out = control_length)  
index2 <- seq(start_value+end_value, 2*end_value, length.out = case__length)

index <- c(rep(index1,each=6), rep(index2,each=6))

comp_disease_sorted <- comp_disease_sorted %>% mutate(index=index)

head(comp_disease_sorted)

write_csv(comp_disease_sorted,"prop2_sortl.csv")




##### test ####






