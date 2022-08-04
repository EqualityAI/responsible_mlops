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

#===============================================================================
# FILTER PROTECTED VARIABLE
#===============================================================================
var_rem <- function(data_input, var_rem) {
  # Remove variables from the data based on the given variable list 'var_list'
  #
  # INPUT
  # data_input (data.frame)     : Input data in dataframe format
  # var_list (character)        : Name of the variable to be removed
  #
  # OUTPUT
  # data_ (data.frame)          : Data after removing specific variables
  #
  # ----------------------------------------------------------------------------
  data_input <- data_input[colnames(data_input) != var_rem]
  return(data_input)
}

#===============================================================================
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
