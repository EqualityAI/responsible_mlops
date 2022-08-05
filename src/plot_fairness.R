

#-------------------------------------------------------------------------------
# PLOT 3 - ML and Fairness Metrics  (Pre vs. Post Mitigation)
#-------------------------------------------------------------------------------
metrics_compare <- function(acc,label,path_fig){
  #ML Metrics: AUC, Fairness Metrics: Statistical Parity]
  #acc<-c(data_viz_pre$ml_results$AUC,data_viz_pre$fairness_results$equal_opportunity,
  #       data_viz_post$ml_results$AUC,data_viz_post$fairness_results$equal_opportunity)
  #label<-c('AUC','Statistical Parity Ratio')
  #metrics_compare(acc,label)
  #-----------------------------------------------------------------------------
  label<-rep(label,2)
  group<-c('Pre-mitigation','Pre-mitigation','Post-mitigation','Post-mitigation')
  data<-t(rbind(acc,label,group))
  proportion_data<-data.frame(data)
  
  
  ggplot(proportion_data, aes(x=factor(group,levels = c("Pre-mitigation", "Post-mitigation")), 
                              y=as.numeric(acc), group=label,color=label))+ 
    geom_line()+
    geom_point(aes(shape =label, color = label), size = 4)+
    scale_shape_manual(values = c(15, 17))+
    scale_color_manual(values = c("#404788FF", "#238A8DFF"))+
    xlab("") + ylab("") + 
    ylim(0.5,1)+
    labs(shape="Metrics", colour="Metrics")+
    theme(text = element_text(size = 14))+
    geom_vline(xintercept = 1.5, linetype="dotted",color = "blue", size=0.8)+
    ggtitle("Change of Accuracy and Fairness Metrics")
  path_fig <- file.path(getwd(),"_res", "metrics_compare.png")
  ggsave(path_fig, width = 7, height = 7)
}
# #===============================================================================
# # Fairness Metric Using Bar Chart
# #===============================================================================
# # 2. plot_fairness_results(data_viz_)
# 
# plot_fairness_results <- function(data_viz_){
#   # plot_fairness_results(data_viz_pre)
#   # plot_fairness_results(data_viz_post)
#   
#   fairness_metrics <- as.numeric(data_viz_pre$fairness_results)
#   metric_name<- names(data_viz_pre$fairness_results)
#   barplot(fairness_metrics, main="Fairness Metrics",xlab="", 
#           names.arg =metric_name, cex.names = 0.6, beside=TRUE)
#   
# }
# 
# #===============================================================================
# # Fairness Comparison Using Bar Chart
# #===============================================================================
# # 3. plot_fairness_comparison(data_viz_pre, data_viz_post)
# plot_fairness_comparison <- function(data_viz_pre,data_viz_post){
#   # plot_fairness_comparison(data_viz_pre, data_viz_post)
#   
#   pre_metrics <- as.numeric(data_viz_pre$fairness_results)
#   post_metrics <- as.numeric(data_viz_post$fairness_results)
#   metric_name<- names(data_viz_post$fairness_results)
#   fairness_metrics<-t(cbind(pre_metrics,post_metrics))
#   barplot(fairness_metrics, main="Fairness Metrics",xlab="",col=c('red','blue'), 
#           names.arg =metric_name , cex.names = 0.6, beside=TRUE)
#   legend("topright",inset=c(0.01,0),legend=c('Pre-mitigation','Post-mitigation'), fill = c("red","blue"),
#          cex = 0.6,horiz=F,xpd = T)
# }
# 
# 
# 
# #===============================================================================
# # Fairness Comparison Using Bar Chart
# #===============================================================================
# # 4. plot_fairness_percentage(data_viz_pre, data_viz_post)
# plot_fairness_percentage<- function(data_viz_pre,data_viz_post){
#   # plot_fairness_percentage(data_viz_pre,data_viz_post)
#   
#   pre_metrics <- as.numeric(data_viz_pre$fairness_results)
#   post_metrics <- as.numeric(data_viz_post$fairness_results)
#   metric_name<- names(data_viz_post$fairness_results)
#   fairness_metrics<-t(cbind(pre_metrics,post_metrics))
#   
#   r_fairness_metric<-dim(fairness_metrics)[1]
#   fairness_metric1<- fairness_metrics[1,]
#   fairness_diff1<-100*(fairness_metrics[2,]-fairness_metrics[1,])/fairness_metrics[1,]
#   
#   barplot(fairness_diff1, main="Percent change of fairness metrics after mitigation",
#           xlab="",col='red', names.arg =metric_name, cex.names = 0.6, beside=TRUE)
#   
# }
# 
