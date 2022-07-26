# library("fmsb") 
#library(pROC)
#-------------------------------------------------------------------------------
# PLOT 1 - AUC Protected Variable (Pre vs. Post Mitigation)
#-------------------------------------------------------------------------------
# Change of AUC Pre- and Post- Mitigation by Racial Groups
acc_metrics_compare <- function(data_viz_pre,data_viz_post, path_fig){
  # acc_metrics_compare(data_viz_pre,data_viz_post)
  
  x_w1<-plot.roc(data_viz_pre$true_class[data_viz_pre$protected_class==1],
                 data_viz_pre$pred_prob[data_viz_pre$protected_class==1]) 
  auc_w1<-auc(x_w1)
  
  x_b1<-plot.roc(data_viz_pre$true_class[data_viz_pre$protected_class==2],
                 data_viz_pre$pred_prob[data_viz_pre$protected_class==2]) 
  auc_b1<-auc(x_b1)
  
  x_w2<-plot.roc(data_viz_post$true_class[data_viz_post$protected_class==1],
                 data_viz_post$pred_prob[data_viz_post$protected_class==1]) 
  auc_w2<-auc(x_w2)
  
  x_b2<-plot.roc(data_viz_post$true_class[data_viz_post$protected_class==2],
                 data_viz_post$pred_prob[data_viz_post$protected_class==2]) 
  auc_b2<-auc(x_b2)
  
  acc<-c(auc_w1,auc_b1,auc_w2,auc_b2)
  label<-c('White','Black','White','Black')
  group<-c('Pre-mitigation','Pre-mitigation','Post-mitigation','Post-mitigation')
  data<-t(rbind(acc,label,group))
  proportion_data<-data.frame(data)
  
  ggplot(proportion_data, aes(x=factor(group,levels = c("Pre-mitigation", "Post-mitigation")), y=as.numeric(acc), group=label,color=label))+ 
    geom_line()+
    geom_point(aes(shape =label, color = label), size = 4)+
    scale_shape_manual(values = c(15, 17))+
    scale_color_manual(values = c('#404788FF','#238A8DFF'))+
    xlab("") + ylab("") + 
    ylim(0.6,0.9)+
    labs(shape="Metrics", colour="Metrics")+
    theme(text = element_text(size = 14))+ 
    geom_vline(xintercept = 1.5, linetype="dotted",color = "blue", size=0.8)+
    ggtitle("Change of AUC Pre- and Post- Mitigation by Racial Groups")
  path_fig <- file.path(getwd(),"_res", "acc_metrics_compare.png")
  ggsave(path_fig,width = 7, height = 7)
}
#-------------------------------------------------------------------------------
# PLOT 2 - ROC Protected Variable (Pre vs. Post Mitigation)
#-------------------------------------------------------------------------------
# comparing the ROC curve between each sensitive variable groups
roc_sensitive_variable <- function(label,pre_score, post_score,group_name, path_fig) {
  png(file.path(path_fig,"roc_sensitive_variable.png"),width = 7.5, height = 7.5, units = 'in', res = 300)
  sensitive_group<- unique(group_name)
  #par(mfrow=c(1,2))
  par(fig=c(0,0.5,0.25,0.75))
  plot.roc(label[group_name==sensitive_group[1]],main=sensitive_group[1],xlim=c(1,0),ylim=c(0,1), pre_score[group_name==sensitive_group[1]],col="#404788FF") 
  par(new = TRUE)
  plot.roc(label[group_name==sensitive_group[1]],xlim=c(1,0),ylim=c(0,1), post_score[group_name==sensitive_group[1]],col='#238A8DFF') 
  
  par(fig=c(0.5,1,0.25,0.75), new=TRUE)
  plot.roc(label[group_name==sensitive_group[2]],main=sensitive_group[2],xlim=c(1,0),ylim=c(0,1), pre_score[group_name==sensitive_group[2]],col="#404788FF") 
  par(new = TRUE)
  plot.roc(label[group_name==sensitive_group[2]], xlim=c(1,0),ylim=c(0,1),post_score[group_name==sensitive_group[2]],col='#238A8DFF') 
  
  par(fig=c(0,1,0,0.8), new=TRUE)
  legend("bottom",legend=c('Pre-mitigation','Post-mitigation'),fill = c("#404788FF",'#238A8DFF'),
         title = "Migigation Method",cex = 0.8,horiz=T,xpd = T)
  
  mtext("Comparision of the ROC curve pre- and post mitigation",side = 3, line = - 8, outer = TRUE,cex=1)
  dev.off()
}
#-------------------------------------------------------------------------------
# PLOT 4 - Protected Variable Proportion (Pre vs. Post Mitigation)
#-------------------------------------------------------------------------------
proportion_pre_post <- function(data_viz_pre,data_viz_post,path_fig){
  # proportion_pre_post(data_viz_pre,data_viz_post)
  pre<-prop.table(table(data_viz_pre$pred_class, data_viz_pre$protected_class),2)
  post<-prop.table(table(data_viz_post$pred_class, data_viz_post$protected_class),2)
  
  prop<-c(pre[2],pre[4],post[2],post[4])
  label<-c('White','Black')
  period<-c('Pre-mitigation','Pre-mitigation','Post-mitigation','Post-mitigation')
  
  data<-t(rbind(label,prop,period))
  proportion_data<-data.frame(data)
  proportion_data$label <- factor(proportion_data$label,levels = c('White','Black'))
  
  ggplot(proportion_data, aes(x=factor(period,levels = c("Pre-mitigation", "Post-mitigation")), 
                              y=as.numeric(prop), group=label,color=label))+ 
    geom_line()+
    geom_point(aes(shape =label, color = label), size = 4)+
    scale_shape_manual(values = c(15, 16))+
    scale_color_manual(values = c('#404788FF','#238A8DFF'))+
    xlab("")+ylab("Proportion of Predicted Hospitalizations") +
    ylim(0,0.6)+
    labs(shape="Racial Groups", colour="Racial Groups")+
    theme(text = element_text(size = 14),legend.spacing.x = unit(0.2, 'cm')) +
    ggtitle("Predicted Proportion of Hospitalizations by Racial Groups") 
  path_fig <- file.path(getwd(),"_res", "proportion_pre_post.png")
  ggsave(path_fig,width = 7, height = 7)
}
#-------------------------------------------------------------------------------
# Plot 5 - Output Class Comparison (Pre vs. post mitigation)
#-------------------------------------------------------------------------------
predictive_num_compare <- function(numb1,numb2, path_fig){
  #pre<-table(data_viz_pre$true_class, data_viz_pre$protected_class)
  #post<-table(data_viz_post$true_class, data_viz_post$protected_class)
  #numb_w<-c(pre[2],pre[1],post[2],post[1])
  #numb_b<-c(pre[4],pre[3],post[4],post[3])
  #predictive_num_compare(numb_w,numb_b)
  
  label<-c('Positive number','Negative number','Positive number','Negative number')
  group<-c('Pre-mitigation','Pre-mitigation','Post-mitigation','Post-mitigation')
  data1<-t(rbind(numb1,label,group))
  predictive_white<-data.frame(data1)
  
  data2<-t(rbind(numb2,label,group))
  predictive_black<-data.frame(data2)
  white<-ggplot(predictive_white, aes(x=factor(group,levels = c("Pre-mitigation", "Post-mitigation")), as.numeric(numb1), group=label,color=label))+ 
    geom_line()+
    geom_point(aes(shape =label, color = label), size = 4)+
    scale_shape_manual(values = c(15, 17))+
    scale_color_manual(values = c("#404788FF", "#238A8DFF"))+theme_classic()+
    xlab("") + ylab("") + 
    labs(shape="", colour="")+
    theme(text = element_text(size = 12))+ 
    geom_vline(xintercept = 1.5, linetype="dotted",color = "blue", size=0.8)+
    ggtitle("Whites")
  
  
  black<-ggplot(predictive_black, aes(x=factor(group,levels = c("Pre-mitigation", "Post-mitigation")), as.numeric(numb2), group=label,color=label))+ 
    geom_line()+
    geom_point(aes(shape =label, color = label), size = 4)+
    scale_shape_manual(values = c(15, 17))+
    scale_color_manual(values = c("#404788FF", "#238A8DFF"))+ theme_classic()+
    xlab("") + ylab("") + 
    labs(shape="", colour="")+
    theme(text = element_text(size = 12))+ 
    geom_vline(xintercept = 1.5, linetype="dotted",color = "blue", size=0.8)+
    ggtitle("Blacks")
  
  figure<-ggarrange(white, black,common.legend=T, nrow = 2,legend='right',heights=15)
  
  annotate_figure(figure, top = text_grob("Number of postive and negative cases predicted by the models",face = "bold", size = 16))
  path_fig <- file.path(getwd(),"_res", "predictive_num_compare.jpeg")
  ggsave(path_fig, width = 10, height = 10)
}