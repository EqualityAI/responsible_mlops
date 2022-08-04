#===============================================================================
# MACHINE LEARNING MODELS
#===============================================================================
ml_model <- function(data_input, target_var, ml_method, param_ml = NULL) {
  # Train and test machine learning model based on the specified method
  #
  # INPUT
  # data_input (list)       :   Input data comprising training and testing data
  #                             e.g. training_data <- data_input$training, 
  #                             testing_data <- data_input$testing
  #
  # target_var (character)  : Name of the target variable in the input data
  #
  # ml_method (character)   : Name of the machine learning method 
  #                           e.g. 'rf' - Random Forest
  #                                'gbm'- Gradient Boosting Machine
  #
  # param_ml (list)         :  Hyper-parameters related to machine learning model training
  #                            e.g. "weights" - Weights for the machine learning model
  #
  # OUTPUT
  # results (list)          : Trained machine learning model along with the predicted results  
  #                           The elements of the lists are 'pred_class', 'probability', and 'model'
  #                               - 'pred_class' - predicted class of the testing data
  #                               - 'probability' - probability values of the testing data
  #                               - 'model' - trained machine learning model
  #
  # ----------------------------------------------------------------------------
  # training data
  training_data <- data_input$training
  # testing data
  testing_data <- data_input$testing
  # Machine learning method - Random Forest (RF)
  if(tolower(ml_method) == "rf"){
    ml_results = ml_model_rf(training_data, testing_data, target_var, param_ml)
  }
  # Gradient Boosting Machine (GBM)
  else if(tolower(ml_method) == "gbm") {
    ml_results = ml_model_gbm(training_data, testing_data, target_var, param_ml)
  }
  return(ml_results)
}
#===============================================================================
# RANDOM FOREST (RF)
#===============================================================================
#-------------------------------------------------------------------------------
# RANDOM FOREST - TRAINING & TESTING
# ------------------------------------------------------------------------------
ml_model_rf <- function(training_data, testing_data, target_var, param_ml = NULL) {
  # Train and test Random Forest machine learning classifier using training and testing data respectively
  #
  # INPUT
  # training_data (data.frame)    : Training data
  # testing_data (data.frame)     : Testing data
  # target_var (character)        : Target variable for the classifier
  # param_ml (list)               : Hyper-parameters for Random Forest
  #                                 e.g. 'ntree', 'mtry'
  # OUTPUT
  # results (list)                : Trained Random Forest model as well as predicted results 
  #
  # ----------------------------------------------------------------------------
  # Training Random Forest Classifier
  mdl_clf = rf_train(training_data, target_var, param_ml)
  
  # Testing Random Forest Classifier
  ml_res = rf_test(testing_data, target_var, mdl_clf)
  
  results = list("class" = ml_res$class, "probability" = ml_res$probability, "model" = mdl_clf)
  return(results)
}
# ------------------------------------------------------------------------------
# RANDOM FOREST - TRAINING
# ------------------------------------------------------------------------------
rf_train <- function(training_data, target_var, param_ml) {
  # Train Random Forest machine learning model
  #
  # INPUT
  # training_data (data.frame)    : Training data
  # target_var (character)        : Target variable for the classifier
  # param_ml (list)               : Hyper-parameters for Random Forest
  #                                 e.g. 'ntree', 'mtry'
  #
  # OUTPUT
  # mdl_clf (list)                : Trained Random Forest model
  #
  # ----------------------------------------------------------------------------
  # converting target variable feature to factor
  training_data[[target_var]] = as.factor(training_data[[target_var]])
  # ----------------------------------------------------------------------------
  # ntree       -     Number of trees in the forest. It should be a large number (default - 500). 
  #                   For stable error rate use large value for ntree approximately 10 times the number of features in the dataset 
  #
  # mtry        -     Number of features (randomly sampled) to be considered at each split
  #                   Classification (default:  sqrt(p)), Regression (default: p/3),
  #                   where p is number of variables in the data
  # weights     -     A vector of length same as y that are positive weights used only in sampling data to grow each tree
  #
  # replace     -     Sampling of cases be done with or without replacement (default - True)
  # 
  # sampsize    -     Number of samples to draw (e.g. c(200,150))
  #
  # nodesize    -     Minimum size of terminal nodes. Using larger number causes smaller trees (less computational time)
  #                   Classification (default: 1), Regression (default: 5)
  #
  # maxnodes    -     Maximum number of terminal nodes trees in the forest can have. (default: NULL)
  #
  # importance  -     Calculate importance of features (default: TRUE)
  #
  # ---------------------------------------------------------------------------
  # ntree ---> 
  if(!"ntree"  %in% names(param_ml)) {
    ntree_ <- 500
  } else {
    ntree_ <- param_ml$ntree
  }
  # mtry ---> 
  if(!"mtry"  %in% names(param_ml)) {
    mtry_ <- round(sqrt(ncol(training_data)), 0)
  } else {
    mtry_ <- param_ml$mtry
  }
  # replace --> 
  if(!"replace"  %in% names(param_ml)) {
    replace_ <- TRUE
  } else {
    replace_ <- param_ml$replace
  }
  # nodesize --> 
  # TODO - Check default values
  if(!"nodesize"  %in% names(param_ml)) {
    nodesize_ <- if (!is.null(training_data[[target_var]]) && !is.factor(training_data[[target_var]])) 5 else 1
  } else {
    nodesize_ <- param_ml$nodesize
  }
  # maxnodes --> 
  if(!"maxnodes"  %in% names(param_ml)) {
    maxnodes_ <- NULL
  } else {
    maxnodes_ <- param_ml$maxnodes
  }
  # importance --> 
  if(!"importance"  %in% names(param_ml)) {
    importance_ <- TRUE
  } else {
    importance_ <- param_ml$importance
  }
  # ----------------------------------------------------------------------------
  # Without using weights
  if(!"weights"  %in% names(param_ml)){
    # Remove - Sprint 5
    #mdl_clf <- randomForest(readmitted ~ ., data=training_data, ntree = 100)
    #mdl_clf <- randomForest(HOS ~ ., data=training_data, ntree = 300)
    mdl_clf <- randomForest(x = training_data[-1], y = training_data[[target_var]], ntree = ntree_, mtry = mtry_,
                            nodesize = nodesize_, maxnodes = maxnodes_, importance = importance_,
                            replace = replace_, sampsize = if (replace_) nrow(training_data) else ceiling(.632*nrow(training_data)))
  }else {
    if(is.null(param_ml["weights"])){  # weight values not available
      print('Model weights not available')
    } else {
      #mdl_clf <- randomForest(readmitted ~ ., data=training_data, ntree = 100, weights = model_weights)
      #mdl_clf <- randomForest(HOS ~ ., data=training_data, ntree = 300, weights = model_weights)
      mdl_clf <- randomForest(x = training_data[-1], y = training_data[[target_var]], ntree = ntree_, mtry = mtry_,
                              nodesize = nodesize_, maxnodes = maxnodes_, importance = importance_,
                              replace = replace_, sampsize = if (replace_) nrow(training_data) else ceiling(.632*nrow(training_data)),
                              weights = param_ml$weights)
    }
  }

  return(mdl_clf)
}
# ------------------------------------------------------------------------------
# RANDOM FOREST - TESTING
# ------------------------------------------------------------------------------
rf_test <- function(testing_data, target_var, mdl_clf) {
  # Testing Random Forest machine learning model of testing data
  #
  # INPUT
  # testing_data (data.frame)    : Testing data
  # target_var (character)       : Target variable used for the trained classifier
  # mdl_clf (list)               : Trained Random Forest classifier
  #
  # OUTPUT
  # results (list)                : Predicted results (output classes along with the probability of outcomes)
  #
  # ----------------------------------------------------------------------------
  pred_class <- predict(mdl_clf, newdata=testing_data[, -which(names(testing_data) == target_var)])
  pred_prob <- predict(mdl_clf, newdata=testing_data[, -which(names(testing_data) == target_var)] , type="prob")
  # pred_prob: [samples, output_class]
  #pred_prob <- apply(pred_prob,1,max)
  pred_prob <- as.numeric(pred_prob[,2]) 
  results = list("class" = pred_class, "probability" = pred_prob)
  # ----------------------------------------------------------------------------
  
  return(results)
}

#===============================================================================
# MACHINE LEARNING MODEL - Gradient Boosting Machine (GBM)
#===============================================================================
#-------------------------------------------------------------------------------
# Gradient Boosting Machine - TRAINING & TESTING
# ------------------------------------------------------------------------------
ml_model_gbm <- function(training_data, testing_data, target_var, param_ml) {
  # Train and test Gradient Boosting machine learning classifier using training and testing data respectively
  #
  # INPUT
  # training_data (data.frame)    : Training data
  # testing_data (data.frame)     : Testing data
  # target_var (character)        : Target variable for the classifier
  # param_ml (list)               : Hyper-parameters for GBM
  #                                 e.g. 'n.trees', 'interaction.depth'
  # OUTPUT
  # results (list)                : Trained GBM model as well as predicted results 
  #
  # ----------------------------------------------------------------------------
  # Training Classifier
  ml_clf = gbm_train(training_data, target_var, param_ml)
  
  # Testing Classifier
  ml_res = gbm_test(testing_data, target_var, mdl_clf,param_ml)
  
  results = list("class" = pred_class, "probability" = pred_prob, "model" = mdl_clf)
  return(results)
}

# ------------------------------------------------------------------------------
# GBM - TRAINING
# ------------------------------------------------------------------------------
gbm_train <- function(training_data, target_var, param_ml) {
  # Train GBM machine learning model
  #
  # INPUT
  # training_data (data.frame)    : Training data
  # target_var (character)        : Target variable for the classifier
  # param_ml                      : Hyper-parameters for GBM
  #                                 e.g. 'n.trees', 'interaction.depth'
  #
  # OUTPUT
  # mdl_clf (list)                : Trained GBM model
  #
  # ----------------------------------------------------------------------------
  # converting target variable feature to factor
  #training_data[[target_var]] = as.factor(training_data[[target_var]])
  # ----------------------------------------------------------------------------
  # n.trees     -     Number of trees in the forest. It should be a large number (default - 500). 
  #                   For stable error rate use large value for ntree approximately 10 times the number of features in the dataset 
  #
  # weights     -     A vector of length same as y that are positive weights used only in sampling data to grow each tree
  #
  # interaction.depth     -   Integer specifying the maximum depth of each tree (i.e., the highest level of variable interactions allowed). 
  #                           A value of 1 implies an additive model, a value of 2 implies a model with up to 2-way interactions, 
  #                           etc. Default is 1.
  # 
  # n.minobsinnode        -   integer specifying the minimum number of observations in the terminal nodes of the trees. 
  #                           Note that this is the actual number of observations, not the total weight (default - 10).
  # shrinkage    -    a shrinkage parameter applied to each tree in the expansion. Also known as the learning rate or step-size reduction; 
  #                   0.001 to 0.1 usually work, but a smaller learning rate typically requires more trees. Default is 0.1.
  #
  # bag.fraction    -    the fraction of the training set observations randomly selected to propose the next tree in the expansion. (default: 0.5)
  #
  # train.fraction  -    The first train.fraction * nrows(data) observations are used to fit the gbm and the remainder are used for 
  #                      computing out-of-sample estimates of the loss function. (default: 1)
  #
  # ---------------------------------------------------------------------------
  # ntree ---> 
  if(!"n.trees"  %in% names(param_ml)) {
    n.trees_ <- 500
  } else {
    n.trees_ <- param_ml$n.trees
  }
  # interaction.depth ---> 
  if(!"interaction.depth"  %in% names(param_ml)) {
    interaction.depth_ <- 1
  } else {
    interaction.depth_ <- param_ml$interaction.depth
  }
  # n.minobsinnode --> 
  if(!"n.minobsinnode"  %in% names(param_ml)) {
    n.minobsinnode_ <- 10
  } else {
    n.minobsinnode_ <- param_ml$n.minobsinnode
  }
  # shrinkage --> 
  if(!"shrinkage"  %in% names(param_ml)) {
    shrinkage_ <- .1
  } else {
    shrinkage_ <- param_ml$shrinkage
  }
  # bag.fraction --> 
  if(!"bag.fraction"  %in% names(param_ml)) {  
    bag.fraction_ <- 0.1
  } else {
    bag.fraction_ <- param_ml$bag.fraction
  }
  
  # train.fraction --> 
  if(!"train.fraction"  %in% names(param_ml)) {  
    train.fraction_ <- 1
  } else {
    train.fraction_ <- param_ml$train.fraction
  }
  
  
  # ----------------------------------------------------------------------------
  if(!"weights"  %in% names(param_ml)){
    mdl_clf <- gbm(as.formula(paste0(target_var,"~.")), n.trees = n.trees_, interaction.depth=interaction.depth_,
                   n.minobsinnode=n.minobsinnode_,shrinkage=shrinkage_,bag.fraction=bag.fraction_,train.fraction=train.fraction_,
                   data=training_data)
  }else {
    if(is.null(param_ml["weights"])){
      print('Model weights not available')
    } else {
      mdl_clf <- gbm(as.formula(paste0(target_var,"~.")), n.trees = n.trees_, interaction.depth=interaction.depth_,
                     n.minobsinnode=n.minobsinnode_,shrinkage=shrinkage_,bag.fraction=bag.fraction_,train.fraction=train.fraction_,
                     weights = weights,data=training_data)
    }
  }
  
  return(mdl_clf)
}
# ------------------------------------------------------------------------------
# GBM - TESTING
# ------------------------------------------------------------------------------
gbm_test <- function(testing_data, target_var, mdl_clf,param_ml) {
  # Testing GBM machine learning model of testing data
  #
  # INPUT
  # testing_data (data.frame)    : Testing data
  # target_var (character)       : Target variable used for the trained classifier
  # mdl_clf (list)               : Trained GBM classifier
  # param_ml (list)              : Get number of trees
  #
  # OUTPUT
  # results (list)                : Predicted results (output classes along with the probability of outcomes)
  #
  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  
  if(!"n.trees"  %in% names(param_ml)) {
    n.trees_ <- 500
  } else {
    n.trees_ <- param_ml$n.trees
  }
  
  pred_class <- as.numeric(predict(mdl_clf, newdata=testing_data, type="response")>.5)
  pred_prob <- predict(mdl_clf, newdata=testing_data, type="response")
  # pred_prob: [samples, output_class]
  #pred_prob <- apply(pred_prob,1,max)
  results = list("class" = pred_class, "probability" = pred_prob)
  # ----------------------------------------------------------------------------
  return(results)
}
#====================================================================
# MACHINE LEARNING RESULTS
#====================================================================
ml_results <- function(y_true, y_pred, y_prob, param_results = NULL) {
  # Machine learning model performance 
  #
  # INPUT
  # y_true (integer)            : True values of the the target variable
  # y_pred (integer)            : Predicted values of the the target variable
  # y_prob (double)             : Predicted probability target variable
  # param_results (list) [ToDo] : List comprising names of the metrics to be calculated
  #                               (default: all metrics are calculated)
  #
  # OUTPUT
  # results (list)              : Machine learning model performance results
  #                               e.g. 'accuracy', 'F1', etc.
  #
  # ----------------------------------------------------------------------------
  confusion_matrix = table(y_true , y_pred)
  # Rows: True class (0, 1)
  # Columns: Predicted class (0, 1)
  TN = confusion_matrix[1,1]
  # TN: Value of actual class is 0 and value of predicted class is also 0
  TP = confusion_matrix[2,2]
  # TP: Value of actual class is 1 and value of predicted class is also 1
  FP = confusion_matrix[1,2]
  # FP: Value of actual class is 0 and value of predicted class is 1
  FN = confusion_matrix[2,1]
  # FN: Value of actual class is 1 and value of predicted class is 0
  precision =(TP)/(TP+FP)
  recall = (TP)/(TP+FN) 
  F1 = 2*((precision*recall)/(precision+recall))
  accuracy  = (TP+TN)/(TP+TN+FP+FN) # classification accuracy
  # TPR = (TP)/ (TP+FN)
  # FPR = (FP)/ (FP+TN)
  # Accuracy = (TP+TN)/(TP+TN+FP+FN)
  if("AUC"  %in% names(param_results)){
    if( param_results$AUC == FALSE){
      AUC = NULL
      } 
    }else{
      AUC  = auc_roc(y_prob, y_true)
    }
  
  results = list("TP" = TP, "TN" = TN, "FP" = FP, "FN" = FN, 
                 "precision" = precision, "recall"= recall, "F1" = F1, 
                 "accuracy" = accuracy, "AUC" = AUC)
  # "TP", "TN", "FP", "FN", "precision", "recall", "f1", "accuracy"
  return(results)
}

#===============================================================================
# AUC VALUE AND THRESHOLD
#===============================================================================
auc_results <- function(y_true, y_prob) {
  # AUC calculation and AUC threshold for prediction 
  #
  # INPUT
  # y_true (integer)            : True values of the the target variable
  # y_prob (double)             : Predicted probability target variable
  #
  # OUTPUT
  # results (list)              : AUC value and AUC optimal threshold for prediction
  #
  # ----------------------------------------------------------------------------
  auc_value <-plot.roc(y_true,xlim=c(1,0),ylim=c(0,1),y_prob,col='red')
  auc(auc_value)
  # calculating auc threshold
  auc_th <-as.numeric(coords(auc_value, "best", ret="threshold", transpose = FALSE))
  
  results = list("AUC" = as.numeric(auc_value$auc), "threshold" = auc_th) 
  return(results)
}

#====================================================================
# MACHINE LEARNING RESULTS  - Method II
#====================================================================
ml_results2 <- function(y_true, y_pred, param_results = NULL) {
  # Machine learning model performance 
  #
  # INPUT
  # y_true (integer)            : True values of the the target variable
  # y_pred (integer)            : Predicted values of the the target variable
  # param_results (list) [ToDo] : List comprising names of the metrics to be calculated
  #                               (default: all metrics are calculated)
  #
  # OUTPUT
  # results (list)              : Machine learning model performance results
  #                               e.g. 'accuracy', 'F1', etc.
  #
  # ----------------------------------------------------------------------------
  y_true <- factor(y_true)
  y_pred <- factor(y_pred)
  res_ <- confusionMatrix(y_pred, y_true, mode = "everything", positive="1")
  # Rows: Predicted class (0, 1)
  # Columns: True class (0, 1)
  TN = res_$table[1,1]
  # TN: Value of actual class is 0 and value of predicted class is also 0
  TP = res_$table[2,2]
  # TP: Value of actual class is 1 and value of predicted class is also 1
  FP = res_$table[2,1]
  # FP: Value of actual class is 0 and value of predicted class is 1
  FN = res_$table[1,2]
  # FN: Value of actual class is 1 and value of predicted class is 0
  precision =(TP)/(TP+FP)
  # res_$byClass['Precision']
  recall = (TP)/(TP+FN) 
  # res_$byClass['Recall']
  F1 = 2*((precision*recall)/(precision+recall))
  # res_$byClass['F1']
  accuracy  = (TP+TN)/(TP+TN+FP+FN) # classification accuracy
  # res_$byClass['Balanced Accuracy']
  # TPR = (TP)/ (TP+FN)
  # FPR = (FP)/ (FP+TN)
  # Accuracy = (TP+TN)/(TP+TN+FP+FN)
  
  results = list("TP" = TP, "TN" = TN, "FP" = FP, "FN" = FN, 
                 "precision" = precision, "recall"= recall, "F1" = F1, 
                 "accuracy" = accuracy)
  # "TP", "TN", "FP", "FN", "precision", "recall", "F1", "accuracy"
  return(results)
}
