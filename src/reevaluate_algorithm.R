#====================================================================
# REEVALUATE ALGORITHM (ML MODEL, FAIRNESS METRICS)
#====================================================================
reevaluate_algorithm <- function(ml_method, data_input, target_var, param_reevaluate_algorithm){
  # param_reevaluate_algorithm <- list("protected" = protected_var, "privileged" = privileged_class)
  #------------------------------------------------------------------------------
  # DATA TRANSFORMATION BASED METHOD
  #------------------------------------------------------------------------------
  if(data_input$type == 'data'){
    # Machine Learning Model
    ml_output_m = ml_model(data_input, target_var, ml_method, param_reevaluate_algorithm$param_ml)
    pred_class_m <-ml_output_m$class
    pred_prob_m <-ml_output_m$probability
    ml_clf_m <-ml_output_m$model
    # Machine Learning Model Results
    true_class <- as.integer(get(target_var[1],data_input$testing))
    ml_res <- ml_results(true_class, pred_class_m, pred_prob_m)
    # Fairness Metric
    fairness_score_training <- fairness_metric(ml_output_m$model, data_input$training, target_var, param_reevaluate_algorithm)
    fairness_score_testing <- fairness_metric(ml_output_m$model, data_input$testing, target_var, param_reevaluate_algorithm)
  }
  #------------------------------------------------------------------------------
  # MODEL WEIGHTS BASED METHODS
  #------------------------------------------------------------------------------
  else if(data_input$type == 'weight'){
    # Machine Learning Model
    ml_output_m = ml_model(data_input, target_var, ml_method, param_reevaluate_algorithm$param_ml)
    pred_class_m <-ml_output_m$class
    pred_prob_m <-ml_output_m$probability
    ml_clf_m <-ml_output_m$model
    # Machine Learning Model Results
    true_class <- as.integer(get(target_var[1],data_input$testing))
    ml_res <- ml_results(true_class, pred_class_m, pred_prob_m)
    # Fairness Metric
    fairness_score_training <- fairness_metric(ml_output_m$model, data_input$training, target_var, param_reevaluate_algorithm)
    fairness_score_testing <- fairness_metric(ml_output_m$model, data_input$testing, target_var, param_reevaluate_algorithm)
  }
  #------------------------------------------------------------------------------
  # REINDEX DATA FOR MODEL TRAINING
  #------------------------------------------------------------------------------
  else if(data_input$type == 'index'){
    data_index <- data_input$index
    tmp_training <- data_input$training # temporary store original training data
    data_input$training <- data_input$training[data_index,] # mitigated training data
    
    # Machine Learning Model
    ml_output_m = ml_model(data_input, target_var, ml_method, param_reevaluate_algorithm$param_ml)
    pred_class_m <-ml_output_m$class
    pred_prob_m <-ml_output_m$probability
    ml_clf_m <-ml_output_m$model
    
    # Machine Learning Model Results
    true_class <- as.integer(get(target_var[1],data_input$testing))
    ml_res <- ml_results(true_class, pred_class_m, pred_prob_m)
    
    # Fairness Metric
    fairness_score_training <- fairness_metric(ml_output_m$model, data_input$training, target_var, param_reevaluate_algorithm)
    fairness_score_testing <- fairness_metric(ml_output_m$model, data_input$testing, target_var, param_reevaluate_algorithm)
  }
  #testing_data <- data_input$testing
  protected_class <- get(param_reevaluate_algorithm$protected[1], data_input$testing)
  # Delete
  #true_class <- get(target_var[1], testing_data)
  results = list("ml_model" = ml_output_m$model, "ml_results" = ml_res, 
                 "fairness_train" = fairness_score_training, "fairness_test" = fairness_score_testing,
                 "pred_prob" = pred_prob_m, "true_class" = true_class, "protected_class" = protected_class)
  return(results)
}
