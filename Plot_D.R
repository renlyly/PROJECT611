# Shilin

# This is the code for reg plot
# focus on prop2 and cell type proportion
#explore the correction between cell-type proportion


library(tidyverse)

combined_data <- read_csv("data.csv")
subject_name<-unique(combined_data$participant_id)


####D####
c1 <- rgb(0.2,0.8,1, alpha = 0.3, names = "lt.blue")
c2 <- rgb(255,192,203, max = 255, alpha = 70, names = "lt.pink")

prop_df<- combined_data[,c('prop2_B','prop2_CD4','prop2_CD8','prop2_Monocytes','prop2_NK','prop2_Other','visit_month','Case')]
prop_mean_total_bytime <- prop_df %>% group_by(visit_month) %>% 
  summarise(across(c('prop2_B','prop2_CD4','prop2_CD8','prop2_Monocytes','prop2_NK','prop2_Other'), mean),
            .groups = 'drop')  %>%
  as.data.frame()
prop_mean_total_bytime

prop_mean_case_bytime <- prop_df %>% group_by(visit_month,Case) %>% 
  summarise(across(everything(), mean),
            .groups = 'drop')  %>%
  as.data.frame()
prop_mean_case<-prop_mean_case_bytime[which(prop_mean_case_bytime$Case=='Case'),]
prop_mean_ctrl<-prop_mean_case_bytime[which(prop_mean_case_bytime$Case=='Control'),]

###prop2_CD4

jpeg(filename = "time_plotCD4.jpg", width = 10, height = 6, units = "in", res = 300)

par(mfrow=c(1,1))
par(mar=c(5,5,2,2))
plot(combined_data[1:5,]$visit_month,combined_data[1:5,]$prop2_CD4,type="p",cex=0.2,pch=20,col=c2,
     xlim=c(0,24),ylim=c(0,0.5),xaxt="n",xlab="Month",ylab="Proportion",
     cex.axis=2,cex.lab=2.5,cex.main=3,
     main="")
xtick<-c(0,6,12,18,24)
axis(side=1, at=xtick, labels = FALSE)
# used for loop to add more line for different patients
lab =c("0","6" ,"12","18 ","24") # label
text(x=xtick, y=-0.03,par("usr")[3], labels = lab, srt = 0, pos = 1,xpd=T,cex = 2)
lines(lowess(combined_data[1:5,]$visit_month,combined_data[1:5,]$prop2_CD4),col=c2)
legend(18,0.5,legend=c('Case','Control'),col=c('hotpink','dodgerblue'),lty=1,bty="n",cex=0.8,lwd=2.5)
#legend(locator(1), legend=c('Case', 'Control'), col=c('hotpink', 'dodgerblue'), lty=1, bty="n", cex=1.5, lwd=2.5)

for(i in 2:length(subject_name)){
  nm = subject_name[i]
  idx= which(combined_data$participant_id==nm)
  tmpm=combined_data[idx,]
  if(tmpm[1,]$Case=='Case'){
    tmpm_case=tmpm
    par(new=T)
    plot(tmpm_case$visit_month,tmpm_case$prop2_CD4,type="p",cex=0.2,pch=20,col=c2,
         xlim=c(0,24),ylim=c(0,0.5),xaxt="n",yaxt='n',
         xlab=" ",ylab=" ")
    lines(lowess(tmpm_case$visit_month,tmpm_case$prop2_CD4),col=c2)
  }else{
    tmpm_ctrl = tmpm
    par(new=T)
    plot(tmpm_ctrl$visit_month,tmpm_ctrl$prop2_CD4,type="p",cex=0.2,pch=20,col=c1,
         xlim=c(0,24),ylim=c(0,0.5),xaxt="n",yaxt='n',
         xlab=" ",ylab=" ")
    lines(lowess(tmpm_ctrl$visit_month,tmpm_ctrl$prop2_CD4),col=c1)
    
  }}
lines(lowess(prop_mean_case$visit_month,prop_mean_case$prop2_CD4),col='hotpink',lwd=2.5)
lines(lowess(prop_mean_ctrl$visit_month,prop_mean_ctrl$prop2_CD4),col='dodgerblue',lwd=2.5)

dev.off()

####E####
c3=c('#a1d76a')
c4=c('#beaed4')

jpeg(filename = "time_plotCD8.jpg", width = 10, height = 6, units = "in", res = 300)
par(mfrow=c(1,1))
par(mar=c(5,5,2,2))
plot(combined_data[1:5,]$visit_month,combined_data[1:5,]$prop2_CD8,type="p",cex=0.2,pch=20,col=c2,
     xlim=c(0,24),ylim=c(0,0.5),xaxt="n",xlab="Month",ylab="Proportion",
     cex.axis=2,cex.lab=2.5,cex.main=3,
     main=" ")
xtick<-c(0,6,12,18,24)
axis(side=1, at=xtick, labels = FALSE)
lab =c("0","6" ,"12","18 ","24") # label
text(x=xtick, y=-0.03,par("usr")[3], labels = lab, srt = 0, pos = 1,xpd=T,cex = 2)
lines(lowess(combined_data[1:5,]$visit_month,combined_data[1:5,]$prop2_CD8),col=c2)
legend(18,0.73,legend=c('Case','Control'),col=c('hotpink','dodgerblue'),lty=1,bty="n",cex=1.5,lwd=2.5)
for(i in 2:length(subject_name)){
  nm = subject_name[i]
  idx= which(combined_data$participant_id==nm)
  tmpm=combined_data[idx,]
  if(tmpm[1,]$Case=='Case'){
    tmpm_case=tmpm
    par(new=T)
    plot(tmpm_case$visit_month,tmpm_case$prop2_CD8,type="p",cex=0.2,pch=20,col=c2,
         xlim=c(0,24),ylim=c(0,0.5),xaxt="n",yaxt='n',
         xlab=" ",ylab=" ")
    lines(lowess(tmpm_case$visit_month,tmpm_case$prop2_CD8),col=c2)
  }else{
    tmpm_ctrl = tmpm
    par(new=T)
    plot(tmpm_ctrl$visit_month,tmpm_ctrl$prop2_CD8,type="p",cex=0.2,pch=20,col=c1,
         xlim=c(0,24),ylim=c(0,0.5),xaxt="n",yaxt='n',
         xlab=" ",ylab=" ")
    lines(lowess(tmpm_ctrl$visit_month,tmpm_ctrl$prop2_CD8),col=c1)
    
  }}
lines(lowess(prop_mean_case$visit_month,prop_mean_case$prop2_CD8),col='hotpink',lwd=2.5)
lines(lowess(prop_mean_ctrl$visit_month,prop_mean_ctrl$prop2_CD8),col='dodgerblue',lwd=2.5)

dev.off()

