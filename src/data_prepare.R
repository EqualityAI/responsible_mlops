


# data_prepare <- function(data_input, params){
#   
#   # Feature Engineering (One hot encoding)
#   if(params$encoding == TRUE){
#     data_ = encoding_onehot(data_input$training, data_input$testing)
#     
#     training_data <- data_$training
#     testing_data <- data_$testing
#     
#     training_data$readmitted <- as.factor(training_data$readmitted)
#     testing_data$readmitted <- as.factor(testing_data$readmitted)
#     
#     data_input = list("training" = training_data, "testing" = testing_data)
#   }
#   
#   # Feature Engineering (Factor variables)
#   if(params$factor == TRUE){
#     data_ = factor_variables(data_input$training)
#     training_data <- data_$data
#     
#     data_ = factor_variables(data_input$testing)
#     testing_data <- data_$data
#     
#     data_input = list("training" = training_data, "testing" = testing_data)
#   }
#   
#   return(data_input)
#   
# }
#====================================================================
# ONE HOT ENCODING
#====================================================================
encoding_onehot <- function(training_data, testing_data) {
  dummy <- dummyVars(" ~ .", data=training_data)
  training_data <- data.frame(predict(dummy, newdata = training_data))
  testing_data <- data.frame(predict(dummy, newdata = testing_data))
  
  data = list("training" = training_data, "testing" = testing_data)
  
  return(data)
}


#====================================================================
# FACTOR VARIABLES
#====================================================================
factor_variables <- function(data_input) {
  # target variable (as numeric)
  
  data_input$readmitted <- as.numeric(data_input$readmitted) 
  
  
  data_input$gender = as.factor(data_input$gender)
  data_input$race = as.factor(data_input$race)
  data_input$age = as.factor(data_input$age)
  data_input$discharge_disposition = as.factor(data_input$discharge_disposition)
  data_input$max_glu_serum = as.factor(data_input$max_glu_serum)
  data_input$A1Cresult = as.factor(data_input$A1Cresult)
  data_input$metformin = as.factor(data_input$metformin)
  data_input$insulin = as.factor(data_input$insulin)
  data_input$change = as.factor(data_input$change)
  data_input$diabetesMed = as.factor(data_input$diabetesMed)
  
  data = list("data" = data_input)
  
  return(data)
  
}

#=============================================================================
# MISSING VALUES
#===============================================================================
# Method 1: Remove rows having missing values >= 1
# Method 2: Mice package multiple imputations (predicting value using other features) [Single Imputation]
# [numeric, factor (ordered, unordered)] --> Data Types needed (James)
# Method 3: Random Forest for prediction (Single Imputation)

#data_missing_values <- function(data_input, method_missing, param_missing)
# Input:
# data_input - columns are of data type numeric or factor
# param_missing - list
  
  
# Output
# data_
#=============================================================================
# DATA SPLIT (TRAIN, TEST)
#===============================================================================
train_test_split <- function(data_input, target_var, train_size = 0.7) {
  set.seed(2345)
  idx_train <- createDataPartition(data_input[[target_var]], p = train_size, list = FALSE, times = 1)

  training_data <- data_input[ idx_train,]
  testing_data  <- data_input[-idx_train,]

  rownames(training_data) <- NULL
  rownames(testing_data) <- NULL
  
  data_ = list("training" = training_data, "testing" = testing_data)
  return(data_)
}


#=============================================================================
# DATA BALANCING
#===============================================================================
data_balancing <- function(data_input, target_var, method_balancing) {
  # Data balancing 
  # Temporary rename target variable to 'Class'
  colnames(data_input)[colnames(data_input) == target_var] <- 'Class'
  data_input$Class <- as.factor(data_input$Class)
  if(method_balancing == "over"){
    # Over-sampling
    data_input <- upSample(x = data_input[, -1],
                             y = data_input$Class)
  } 
  else if (method_balancing == "under"){
    data_input <- downSample(x = data_input[, -1],
                             y = data_input$Class)
  }
  # rename 'Class' to  original target variable name
  colnames(data_input)[colnames(data_input) == 'Class'] <- target_var
  data_input <- data_input[, c(target_var,names(data_input)[names(data_input) != target_var])]
  return(data_input)
}

#=============================================================================
# MISSING VALUES
#===============================================================================
data_prep_missing_values = function(data_input, method_missing, param_missing=list("max_iter_mi"=50, "max_iter_rf"=5)){
  # library required: mice, missForest
  
  # method_missing can be one of complete_case, mi_impute, and rf_impute
  # if method_missing is mi_impute, max_iter_mi may be provided (default = 50)
  # if method_missing is rf_impute, max_iter_rf may be provided (default = 5)
  if(method_missing == "complete_case"){
    data_imp <- data_input[complete.cases(data_input), ]
  }
  else if(method_missing == "mi_impute"){
    max_iter <- param_missing$max_iter_mi
    data_imp <- mice::mice(data_input, m=1, maxit = max_iter, printFlag = FALSE)
    data_imp <- mice::complete(data_imp)
  }
  else if(method_missing == "rf_impute"){
    max_iter <- param_missing$max_iter_rf
    data_imp <- missForest(data_input, maxiter=max_iter, ntree=1)
    data_imp <- data_imp$ximp
  }
  return(data_imp)
}


# Example usage

#method_missing = "complete_case"
#data_prep_missing_values(data_input, method_missing=method_missing)


# method_missing = "mi_impute"
# data_prep_missing_values(data_input, method_missing=method_missing)

# method_missing = "mi_impute"
# max_iter_mi = 10
# param_missing = list("max_iter_mi"=max_iter_mi)
# data_prep_missing_values(data_input, method_missing=method_missing, param_missing=param_missing)

# method_missing = "rf_impute"
# data_prep_missing_values(data_input, method_missing=method_missing)

# method_missing = "rf_impute"
# max_iter_rf = 10
# param_missing = list("max_iter_rf"=max_iter_rf)
# data_prep_missing_values(data_input, method_missing=method_missing, param_missing=param_missing)
