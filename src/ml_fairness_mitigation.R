source(file.path(getwd(),"src","ml_model.R"))
source(file.path(getwd(),"src","fairness_metrics.R"))
source(file.path(getwd(),"src","mitigation_methods.R"))
source(file.path(getwd(),"src","reevaluate_algorithm.R"))
#===============================================================================
# ML, Fairness, Mitigation, and Reevaluation
#===============================================================================
ml_fairness_mitigation <- function(data_input, ml_method, fairness_method, mitigation_method, param_exp){

  # data_input <- list("training" = training_data, "testing" = testing_data)
  # ml_method <- "rf" # "rf", "gbm"
  # fairness_method <- "equalized-odd"
  # mitigation_method <- "disparate-impact-remover" # "reweight", "resample"
  # target_var <- "readmitted"
  # protected_var <- "gender"
  # privileged_class <- "Female" # "Male", "Female"
  # param_exp = list("target" = target_var, 
  #                     "protected" = protected_var, "privileged" = privileged_class)
  #
  # Note: data_input - data after date preparation stage and comprising training and testing data
  #-------------------------------------------------------------------
  
  
  #-------------------------------------------------------------------
  # STAGE 1 - Machine Learning Model
  #-------------------------------------------------------------------
  ml_output = ml_model(data_input, param_exp$target, ml_method)
  ml_res <- ml_results(get(param_exp$target[1],data_input$testing), ml_output$class)
  #-------------------------------------------------------------------
  # STAGE 2 - Fairness Metric
  #-------------------------------------------------------------------
  param_fairness_metric = list("protected" = param_exp$protected, "privileged" = param_exp$privileged)
  fairness_score <- fairness_metric(ml_output$model, data_input$testing, param_exp$target, param_exp)
  #-------------------------------------------------------------------
  # STAGE 3 - Mitigation Method
  #-------------------------------------------------------------------
  training_data_m <- bias_mitigation(mitigation_method, data_input$training, param_exp$target, param_exp)
  testing_data_m <- bias_mitigation(mitigation_method, data_input$testing, param_exp$target, param_exp)
  #-------------------------------------------------------------------
  # STAGE 4 - Re-evaluation
  #-------------------------------------------------------------------
  if(names(training_data_m) == "data"){
    data_reevaluation <- list("type" = names(training_data_m), "training" = training_data_m$data, "testing" = data_input$testing)
  }
  else if(names(training_data_m) == "weight"){
    data_reevaluation <- list("type" = names(training_data_m), "training" = data_input$training, "testing" = data_input$testing, "weight" = training_data_m$weight)
  }
  else if(names(training_data_m) == "index"){
    data_reevaluation <- list("type" = names(training_data_m), "training" = data_input$training, "testing" = data_input$testing, "index" = training_data_m$index)
  }
  res_reval <- reevaluate_algorithm(ml_method, data_reevaluation, param_exp$target, param_exp)
  #-------------------------------------------------------------------------------
  # STAGE 5 - Comparison
  #-------------------------------------------------------------------------------
  # prediction (probability)
  pred_prob <- ml_output$probability
  #pred_prob <- apply(pred_prob,1,max) # delete: adjusted in the ml model code
  # prediction (class)
  pred_class <- ml_output$class
  # true (class)
  testing_data <- data_input$testing
  true_class <- get(param_exp$target[1], testing_data)
  # protection variable (class)
  protected_class <- get(param_exp$protected[1], testing_data)
  #-------------------------------------------------------------------------------
  # PRE-MITIGATION
  #-------------------------------------------------------------------------------
  res_pre <- list("ml_method" = ml_method, "ml_results" = ml_res,
                      "fairness_method" = fairness_method, "fairness_results" = fairness_score,
                      "mitigation_method" = mitigation_method,
                      "pred_prob" = pred_prob, "true_class"= true_class, "protected_class" = protected_class)
  #-------------------------------------------------------------------------------
  # POST-MITIGATION
  #-------------------------------------------------------------------------------
  res_post <- list("ml_method" = ml_method, "ml_results" = res_reval$ml_results,
                       "fairness_method" = fairness_method, "fairness_results" = res_reval$fairness_test,
                       "mitigation_method" = mitigation_method,
                       "pred_prob" = res_reval$pred_prob, "true_class"= res_reval$true_class, "protected_class" = res_reval$protected_class)
  #-------------------------------------------------------------------------------
  results <- list("pre" = res_pre, "post"= res_post)
  return(results)
  
}