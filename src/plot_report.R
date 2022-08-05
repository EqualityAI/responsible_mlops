#===============================================================================
# REPORT - FAIRNESS METRICS/ML METRICS
#===============================================================================

# ------------------------------------------------------------------------------
# REPORT - DATA PREPARATION
# ------------------------------------------------------------------------------
plot_report_data <- function(data_clean, ml_output, ml_res, reval_res, param_report) {
  # data preparation for report data
  #
  # INPUT
  #
  # 
  # param_report <- list("target_var" = target_var, "ml_method" = ml_method,
  #                      "fairness_method" = fairness_method, "mitigation_method" = mitigation_method,
  #                      "protected" = protected_var, "privileged" = privileged_class,
  #                      "fairness_results" = fairness_score)
  #-----------------------------------------------------------------------------
  # prediction (probability)
  pred_prob <- ml_output$probability
  #pred_prob <- apply(pred_prob,1,max) # to delete
  # prediction (class)
  #pred_class <- ml_output$class 
  # true (class)
  testing_data <- data_clean$testing
  true_class <- get(param_report$target_var[1], testing_data)
  # protection variable (class)
  protected_class <- get(param_report$protected_var[1], testing_data)
  
  auc_post <- auc_results(true_class, reval_res$pred_prob)
  reval_res$pred_class<-reval_res$pred_prob
  reval_res$pred_class[reval_res$pred_class>=auc_post $threshold] <- 1
  reval_res$pred_class[reval_res$pred_class < auc_post $threshold] <- 0
  
  #-------------------------------------------------------------------------------
  data_viz_pre = list("ml_method" = param_report$ml_method, "ml_results" = ml_res,
                      "fairness_method" = param_report$fairness_method, 
                      "fairness_results" = param_report$fairness_results,
                      "mitigation_method" = param_report$mitigation_method,
                      "pred_prob" = pred_prob, "true_class"= true_class, 
                      "protected_class" = protected_class,"pred_class"=pred_class)
  #-----------------------------------------------------------------------------
  # VIZ DATA - POST MITIGATION
  #-----------------------------------------------------------------------------
  data_viz_post = list("ml_method" = param_report$ml_method, "ml_results" = reval_res$ml_results,
                       "fairness_method" = param_report$fairness_method, "fairness_results" = res_reval$fairness_test,
                       "mitigation_method" = param_report$mitigation_method,
                       "pred_prob" = reval_res$pred_prob, "true_class"= reval_res$true_class,
                       "protected_class" = reval_res$protected_class, "pred_class"=reval_res$pred_class)
  # ----------------------------------------------------------------------------
  results = list("pre" = data_viz_pre, "post" = data_viz_post)
  return(results)
}

# ------------------------------------------------------------------------------
# REPORTS 
# ------------------------------------------------------------------------------
plot_report_figures <- function(data_fig, fig_list, path_fig) {
  data_viz_pre <- data_fig$pre
  data_viz_post <- data_fig$post
  #-------------------------------------------------------------------------------
  # PLOT 1 - AUC Protected Variable (Pre vs. Post Mitigation)
  #-------------------------------------------------------------------------------
  if("acc_metrics_compare" %in% fig_list){
    acc_metrics_compare(data_viz_pre,data_viz_post, path_fig)
  }
  #-----------------------------------------------------------------------------
  # PLOT 2 - ROC Protected Variable (Pre vs. Post Mitigation)
  #-----------------------------------------------------------------------------
  if("roc_sensitive_variable" %in% fig_list){
    pre_score<-data_viz_pre$pred_prob
    post_score<-data_viz_post$pred_prob
    label <- data_viz_pre$true_class
    group_name<-data_viz_pre$protected_class
    
    class<-data.frame(data_viz_pre$protected_class)
    class$class1<-''
    class$class1[class$data_viz_pre.protected_class==1]='White'
    class$class1[class$data_viz_pre.protected_class==2]='Black'  
    
    group_name<-class$class1
    roc_sensitive_variable(label,pre_score,post_score,group_name,path_fig)
  }
  
  #-------------------------------------------------------------------------------
  # PLOT 3 - ML and Fairness Metrics  (Pre vs. Post Mitigation)
  #-------------------------------------------------------------------------------
  #ML Metrics: AUC, Fairness Metrics: Statistical Parity]
  if("metrics_compare" %in% fig_list){
    acc<-c(data_viz_pre$ml_results$AUC,data_viz_pre$fairness_results,
           data_viz_post$ml_results$AUC,data_viz_post$fairness_results$`Statistical Parity`)
    label<-c('AUC','Statistical Parity Ratio')
    metrics_compare(acc,label, path_fig)
  }
  #-------------------------------------------------------------------------------
  # PLOT 4 - Protected Variable Proportion (Pre vs. Post Mitigation)
  #-------------------------------------------------------------------------------
  if("proportion_pre_post" %in% fig_list){
    proportion_pre_post(data_viz_pre,data_viz_post, path_fig)
  }
  #-------------------------------------------------------------------------------
  # Plot 5 - Output Class Comparison (Pre vs. post mitigation)
  #-------------------------------------------------------------------------------
  if("predictive_num_compare" %in% fig_list){
    pre<-table(data_viz_pre$pred_class, data_viz_pre$protected_class)
    post<-table(data_viz_post$pred_class, data_viz_post$protected_class)
    
    numb_w<-c(pre[2],pre[1],post[2],post[1])
    numb_b<-c(pre[4],pre[3],post[4],post[3])
    
    predictive_num_compare(numb_w,numb_b, path_fig)
  }
}