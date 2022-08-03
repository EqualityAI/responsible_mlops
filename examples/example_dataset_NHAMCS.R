# INSTRUCTIONS
# 1. Install the packages listed below (0A - PACKAGES)
setwd(dirname(dirname(rstudioapi::getSourceEditorContext()$path)))
#====================================================================
# 0A - PACKAGES
#====================================================================
library("caret") 
library("dplyr") 
library("randomForest")
library("gbm")
library("dplyr")
library("DALEX")
library("fairmodels")
library("haven")
library("data.table")
library("mltools") 
library("hash")
library("pROC")
library("ggpubr")
#====================================================================
# 0B - SCRIPTS
#====================================================================
source(file.path(getwd(),"src","data_fetch.R"))
source(file.path(getwd(),"src","data_prepare.R"))
source(file.path(getwd(),"src","data_prepare_dataset.R"))
source(file.path(getwd(),"src","ml_model.R"))
source(file.path(getwd(),"src","cross_validation.R"))
source(file.path(getwd(),"src","fairness_recommendation.R")) 
source(file.path(getwd(),"src","fairness_metrics.R"))
source(file.path(getwd(),"src","mitigation_methods.R"))
source(file.path(getwd(),"src","reevaluate_algorithm.R"))
source(file.path(getwd(),"src","results_filter.R"))
source(file.path(getwd(),"src","plot_ml.R"))
source(file.path(getwd(),"src","plot_fairness.R"))
source(file.path(getwd(),"src","plot_report.R"))
source(file.path(getwd(),"src","export_data.R"))
#===============================================================================
# EXPERIMMENT CONFIGURATION
#===============================================================================
# Reevaluate ML model and fairness metrics after mitigation
reevaluate_method = TRUE
#===============================================================================
print('-----------------------------------------------------------------------')
print('DATA FETCH')
print('-----------------------------------------------------------------------')
# Name of the sample dataset
dataset_name <- "NHAMCS"
# path_dataset (input from user)
data_raw = data_fetch(data_name=dataset_name)

# User Input 
target_var <- "HOS"
protected_var <- "RACERETH"
privileged_class <- 1

print(paste('Raw data (dimensions): ', nrow(data_raw$data),ncol(data_raw$data)))
print(paste('Target variable: ', target_var))
print(paste('Protected variable: ', protected_var))
print(paste('Privileged class: ', privileged_class))

#===============================================================================
print('-----------------------------------------------------------------------')
print('FAIRNESS & MITIGATION RECOMMENDATION')
print('-----------------------------------------------------------------------')
# # Fairness metric questionnaire
fairness_tree_info <- read.csv(file.path(getwd(),"config","fairness_tree.csv"), sep=',')
#fairness_tree_info <- read_csv(file.path(getwd(),"config","fairness_tree.csv"))
fairness_metric_tree <- fairness_tree_metric(fairness_tree_info) 

fairness_method <- fairness_metric_tree$fairness_metric
print(paste0('Fairness metric: ',fairness_method))
 
# # Mitigation method mapping
mitigation_mapping_info <- read.csv(file.path(getwd(),"config","mitigation_mapping.csv"), sep=',')
mitigation_method <- mitigation_mapping_method(mitigation_mapping_info, fairness_method) 
print(paste0('Mitigation method: ',mitigation_method))

#===============================================================================
print('-----------------------------------------------------------------------')
print('DATA PREPARE')
print('-----------------------------------------------------------------------')
# method_prepare:'Zhang', 'Raita', 'default'
method_options<-list(method_prepare='Zhang',method_missing='mi_impute',max_iter=5)

# Data clean
data_clean <- data_prepare_nhamcs(data_raw$data, data_raw$target_variable, method_options)
print(paste('Clean data (dimensions): ', nrow(data_clean$data),ncol(data_clean$data)))

# Data split
train_data_size = 0.7
data_clean <- train_test_split(data_clean$data, target_var, train_size = train_data_size)
   

# # Data balancing
# method_balancing <- "under"
# # e.g "under": under-sampling, "over": over-sampling
# data_clean$training <- data_balancing(data_clean$training,target_var, method_balancing)


# Note: first column as target variable
#===============================================================================
print('-----------------------------------------------------------------------')
print('MACHINE LEARNING')
print('-----------------------------------------------------------------------')
# Training and testing machine learning model
# Machine learning (ML) method
ml_method <- "rf"
# "rf" - Random Forest
# "gbm" - Gradient Boosting Machine
# Parameters related to ML model
param_ml <- list(ntree = 500)
# data_clean_> training/testing
ml_output = ml_model(data_clean, target_var, ml_method, param_ml)

pred_class <-ml_output$class
pred_prob <-ml_output$probability
ml_clf <-ml_output$model

# Machine Learning Model Results
true_class <- as.integer(get(target_var[1],data_clean$testing))
ml_res <- ml_results(true_class, pred_class, pred_prob)
# "TP", "TN", "FP", "FN", "precision", "recall", "F1", "accuracy"

print(paste('TP: ', ml_res$TP))
print(paste('TN: ', ml_res$TN))
print(paste('FP: ', ml_res$FP))
print(paste('FN: ', ml_res$FN))
print(paste('recall: ', ml_res$recall))
print(paste('precision: ', ml_res$precision))
print(paste('F1: ', ml_res$F1))
print(paste('Classification Accuracy: ', ml_res$accuracy))
print(paste('AUC: ', ml_res$AUC))
#===============================================================================
print('-----------------------------------------------------------------------')
print('FAIRNESS METRIC')
print('-----------------------------------------------------------------------')
param_fairness_metric = list("protected" = protected_var, "privileged" = privileged_class)
fairness_scores <- fairness_metric(ml_output$model, data_clean$testing, target_var, param_fairness_metric)
fairness_score <- fairness_scores[[fairness_method]]
print(paste('Fairness Metric: ', fairness_method,', Score: ', fairness_score))

#===============================================================================
print('-----------------------------------------------------------------------')
print('MITIGATION')
print('-----------------------------------------------------------------------')
param_bias_mitigation = list("protected" = protected_var)
training_data_m <- bias_mitigation(mitigation_method, data_clean$training, target_var, param_bias_mitigation)
testing_data_m <- bias_mitigation(mitigation_method, data_clean$testing, target_var, param_bias_mitigation)

#==============================================================================
# 4 - RE-EVALUATION
#==============================================================================
print('=======================================================================')
print('STAGE 4 - RE-EVALUATION')
print('=======================================================================')
if(reevaluate_method == TRUE){
  param_reevaluate_algorithm <- list("protected" = protected_var, "privileged" = privileged_class,
                                     "param_ml" = param_ml)
  if(names(training_data_m) == "data"){
    data_reevaluation <- list("type" = names(training_data_m), "training" = training_data_m$data, "testing" = testing_data_m$data)
  }
  else if(names(training_data_m) == "weight"){
    param_reevaluate_algorithm[["param_ml"]][["weights"]] <- training_data_m$weight
    data_reevaluation <- list("type" = names(training_data_m), "training" = data_clean$training, "testing" = data_clean$testing)
    param_reevaluate_algorithm[["param_ml"]][["weights"]] <- NULL
  }
  else if(names(training_data_m) == "index"){
    data_reevaluation <- list("type" = names(training_data_m), "training" = data_clean$training, "testing" = data_clean$testing, 
                              "index" = training_data_m$index)
  }
  res_reval <- reevaluate_algorithm(ml_method, data_reevaluation, target_var, param_reevaluate_algorithm)
}
#==============================================================================
# 5 - REPORT/PLOTS
#==============================================================================
# ml_method: machine learning method
# ml_res: machine learning results
# fairness_method: fairness method
# fairness_score: fairness metric results
# mitigation_method: mitigation method
# res_reval: results of machine learning model and fairness metrics after re-evaluation
# res_reval --> "ml_model"     "ml_results"   "fairness_train" "fairness_test" 
#-------------------------------------------------------------------------------
# VIZ DATA - PRE MITIGATION
#-------------------------------------------------------------------------------
param_report <- list("target_var" = target_var, "ml_method" = ml_method,
                     "fairness_method" = fairness_method, "mitigation_method" = mitigation_method,
                     "protected_var" = protected_var, "privileged" = privileged_class,
                     "fairness_results" = fairness_score)
# data preparation for reports
data_fig <- plot_report_data(data_clean, ml_output, ml_res, res_reval, param_report)
# path of the figures
path_fig <- file.path(getwd(),"_res")

# generate figures for the report in the "path_fig" location
fig_list <- list("acc_metrics_compare", "roc_sensitive_variable", 
                 "metrics_compare", "proportion_pre_post", "predictive_num_compare")

plot_report_figures(data_fig, fig_list, path_fig)



                     
     