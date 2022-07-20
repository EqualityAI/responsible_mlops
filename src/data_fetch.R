
#===============================================================================
# DATA FETCH
#===============================================================================
data_fetch <- function(data_name = "Diabetes", data_type = "default", local_copy = FALSE) {
  # Fetch dataset from local directory or online
  #
  # INPUT
  # data_name (character)    : Name of the dataset
  # data_type (character)    : Variations in dataset to do different experiments
  # local_copy (logical)     : Fetch data from local drive location
  #
  # OUTPUT
  # data_ (list)             : Data along with the meta data information related to 
  #                            target variable, protected variable, privileged class, etc
  #-----------------------------------------------------------------------------
  # DIABETES DATASET
  #-----------------------------------------------------------------------------
  if(tolower(data_name) == "diabetes"){
    if(data_type == "default"){
      data_training <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vRq-g0W_LCrd_ITJnlw1t0dW8MHb-CwouAfp4QGpv0XN6a0NP83b5SFiDGFwAjQm5guiTQHNrHeHJDB/pub?output=csv')
      data_testing <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vSuPc58yA2uYjRMA7aiwPiM2dzxa6_Y8ixsxIPZE_u8VAPQ6UQBjNhDFUWtlg1VIdaVQ3tbxdbFQYsP/pub?output=csv')
      data = list("training" = data_training, "testing" = data_testing)
    }
    else if(data_type == "majority_gender_female"){
      data_training <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vTKRPENQnNFcZ0myYh_qzN_3jbzunIWjac9sGFmdZp6jccjNQ1QLpN-I0vQg8ycKzk125ncDMddNQ2r/pub?output=csv')
      data = list("training" = data_training)
    }
    else if(data_type == "majority_gender_male"){
      data_training <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vSXesxOzU6H4hto83ZVSCapMerQbG__7Bc95_uc-sb9Q_6ZnnjqcU5_7futPNYdd9sPfv2ZgYSO_NQN/pub?output=csv')
      data = list("training" = data_training)
    }
    else if (data_type == "testing_v1"){
      data_training <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vT5GVvP20EuO_5zEvi3-aqWayyG-GgS3mwIxoIkRaYb1UZDPnGLfKzLzsAp5INCuHy3T3ENAXHJYtUP/pub?output=csv')
      data_testing <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vTQy3tcA2gZsQyEEXOXMKBN33sgn403G1-8RW9_34lNtdXVx9eyLzGwTzUlMnAxoE5o_CLTZ7-3kiWR/pub?output=csv')
      data = list("training" = data_training, "testing" = data_testing)
    }
    else if (data_type == "training_short"){
      data_training <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vQ0EboaYR5QUn1u6eiZiMRP47WFce2aoRv5Q-obfbRmUQjKadTdkc_ndqAZlsdnbt6eHe8WJJmADkKF/pub?output=csv')
      data_testing <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vSuPc58yA2uYjRMA7aiwPiM2dzxa6_Y8ixsxIPZE_u8VAPQ6UQBjNhDFUWtlg1VIdaVQ3tbxdbFQYsP/pub?output=csv')
      data = list("training" = data_training, "testing" = data_testing)
    }
  }
  #-----------------------------------------------------------------------------
  # NHAMCS DATASET
  #-----------------------------------------------------------------------------
  else if(tolower(data_name) == "nhamcs"){
    # https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHAMCS/
    if(data_type == "default"){
      path_data <- file.path(getwd(), "_data", "NHAMCS", "sascode2019",'ed2019_sas.sas7bdat')
      data_ <-read_sas(path_data)
      data_ <- data.frame(data_)
      data_ = list("data" = data_, "target_variable" = "HOS", 
                    "target_variable" = "HOS", "protected_var" = "RACERETH", "privileged_class" = 1)
      return(data_)
    }
    # else if(data_type == "all"){
    #   path_data <- file.path(getwd(), "_data", "NHAMCS", "sascode2018",'ed2018_sas.sas7bdat')
    #   data_2018 <-read.sas(path_data)
    #   path_dir <- file.path(getwd(), "_data", "NHAMCS", "sascode2019",'ed2019_sas.sas7bdat')
    #   data_2019 <-read.sas(path_data)
    #   data_ <- data.frame(data_)
    #   data_ = list("2018" = data_2018, "2019" = data_2019, 
    #                "target_variable" = "HOS", "protected_var" = "RACERETH", "privileged_class" = 1)
    #   return(data_)
    #}
  }
}