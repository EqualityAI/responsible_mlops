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
# This method first imputes the missing values in the training set, 
# and store the model which is then used to impute the missing values in the test set
# This method is only applicable to the mice package.
data_prep_missing_values_sep = function(data_input, method_missing, param_missing=list("max_iter_mi"=50)){
  # library required: mice
  # method_missing can be one of complete_case, mi_impute, and rf_impute
  # if method_missing is mi_impute, max_iter_mi may be provided (default = 50)
  if(method_missing == "complete_case"){
    data_input$training <- data_input$training[complete.cases(data_input$training), ]
    data_input$testing <- data_input$testing[complete.cases(data_input$testing), ]
  }
  else if(method_missing == "mi_impute"){
    max_iter <- param_missing$max_iter_mi
    x_train <- data_input$training[-1]
    y_train <- data_input$training[1]
    x_test <- data_input$testing[-1]
    y_test <- data_input$testing[1]
    x_train <- mice(x_train,m=1, maxit = max_iter, printFlag = FALSE)
    x_test <- mice.reuse(x_train, x_test, maxit = 1)
    #x_train <- x_train$data
    x_train <- complete(x_train)
    x_test <- x_test$`1`
    
    data_input$training = cbind(y_train, x_train)
    data_input$testing = cbind(y_test, x_test)
  }
  return(data_input)
}

# Example usage

#method_missing = "complete_case"
#data_prep_missing_values_sep(data_input, method_missing=method_missing)


# method_missing = "mi_impute"
# data_prep_missing_values_sep(data_input, method_missing=method_missing)

# method_missing = "mi_impute"
# max_iter_mi = 10
# param_missing = list("max_iter_mi"=max_iter_mi)
# data_prep_missing_values_sep(data_input, method_missing=method_missing, param_missing=param_missing)


# This method first imputes the missing values in the training set, then combine the imputed training set with the test set,
# impute the combined dataset, and extract the imputed test set.
data_prep_missing_values_merge = function(data_input, method_missing, param_missing=list("max_iter_mi"=50, "max_iter_rf"=5)){
  # library required: mice
  
  # method_missing can be one of complete_case, mi_impute, and rf_impute
  # if method_missing is mi_impute, max_iter_mi may be provided (default = 50)
  
  
  if(method_missing == "complete_case"){
    data_input$training <- data_input$training[complete.cases(data_input$training), ]
    data_input$testing <- data_input$testing[complete.cases(data_input$testing), ]
  }
  else if(method_missing == "mi_impute"){
    max_iter <- param_missing$max_iter_mi
    x_train <- data_input$training[-1]
    y_train <- data_input$training[1]
    x_test <- data_input$testing[-1]
    y_test <- data_input$testing[1]
    n_train <- nrow(x_train)
    n_test <- nrow(x_test)
    
    x_train <- mice(x_train, m=1, maxit = max_iter, printFlag = FALSE)
    x_train <- complete(x_train)
    x_comb <- rbind(x_train, x_test)
    x_comb <- mice(x_comb, m=1, maxit = max_iter, printFlag = FALSE)
    x_comb <- complete(x_comb)
    x_test = x_comb[(n_train+1): (n_train+n_test),]
    
    data_input$training = cbind(y_train, x_train)
    data_input$testing = cbind(y_test, x_test)
  }
  else if(method_missing == "rf_impute"){
    max_iter <- param_missing$max_iter_rf
    x_train <- data_input$training[-1]
    y_train <- data_input$training[1]
    x_test <- data_input$testing[-1]
    y_test <- data_input$testing[1]
    n_train <- nrow(x_train)
    n_test <- nrow(x_test)
    
    x_train <- missForest(x_train, maxiter=max_iter, ntree=1)$ximp
    x_comb <- rbind(x_train, x_test)
    x_comb <- missForest(x_comb, maxiter=max_iter, ntree=1)$ximp
    x_test = x_comb[(n_train+1): (n_train+n_test),]
    
    data_input$training = cbind(y_train, x_train)
    data_input$testing = cbind(y_test, x_test)
  }
  return(data_input)
}

