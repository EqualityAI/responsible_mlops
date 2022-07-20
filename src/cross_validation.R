#===============================================================================
# Machine Learning Model Score (k-fold Cross Validation)
#===============================================================================
ml_model_score <- function(x){
  # Note: Input data to be used for cross-validation should be stored in variable 'data_cv'
  # This function is used in 'ml_cv_kfold'
  # Generate message if variable 'data_cv' doesn't exist
  if(!exists("data_cv")){
    print("Assign data to variable 'data_cv' for cross-validation")
  }
  data_fold_test <- data_cv[-x,]
  data_fold_train <- data_cv[x,]
  
  if(tolower(ml_method) == "rf"){
    # Training Random Forest Classifier
    mdl_clf <- rf_train(data_fold_train, target_var, param_ml)
    
    # Testing Random Forest Classifier
    ml_res <- rf_test(data_fold_test, target_var, mdl_clf)
  }
  
  y_pred <- ml_res$class
  y_true <- as.integer(get(target_var[1],data_fold_test))
  ml_score <- ml_results(y_true, y_pred)
  
  if(tolower(param_cv$metrics_cv) == "accuracy"){
    score <- ml_score$accuracy
  }
  return(score)
}
#===============================================================================
# K-FOLD CROSS VALIDATION (METHOD 1)
#===============================================================================
ml_cv_kfold <- function(data_cv, target_var, param_cv, method_ml, param_ml = NULL) {
  # K-fold cross-validation to machine learning model
  #
  # INPUT
  # data_cv (list)          : Input data used for cross-validation
  # target_var (character)  : Name of the target variable in the input data (data_cv)
  # param_cv (list)         : Parameters for cross-validation
  # method_ml (character)   : Name of the machine learning model for cross-validation
  # param_ml (list)         : Hyper-parameters of the machine learning model
  #
  # OUTPUT
  # res_cv_mean (double)    : Average accuracy of machine learning model
  #
  # EXAMPLE
  # param_cv <- list(k_fold = 5, metrics_cv = "accuracy")
  # method_ml <- 'rf'
  # param_ml <- list(ntree = 100, mtry = 20)
  # cv_res <- ml_cv_kfold(data_clean$training, target_var, param_cv, method_ml, param_ml)
  #-----------------------------------------------------------------------------
  # changing the scope of data_cv to global variable
  assign("data_cv", data_cv, envir = .GlobalEnv) 
  # create data folds
  data_folds <- createFolds(data_cv[[target_var]],k = param_cv$k_fold)
  #-----------------------------------------------------------------------------
  # machine learning model results for each fold
  res_cv <- lapply(data_folds, ml_model_score)
  res_cv_mean <- mean(unlist(res_cv))
  rm(data_cv)
  return(res_cv_mean)
}