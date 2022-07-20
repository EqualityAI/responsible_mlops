#===============================================================================
# FAIRNESS METRIC RECOMMENDATION
#===============================================================================
fairness_tree_metric <- function(ftree_df) {
  # Fairness metric recommendation based on questionnaire
  #
  # INPUT
  # ftree_df (data.frame)     : Fairness tree questionnaire (fetch from csv file)
  # List of attributes in fairness tree questionnaire csv file
  # [1] "Node"            - Current node
  # [2] "Answer"          - Possible user response
  # [3] "Emphasizes       - Emphasis (remove)
  # [4] "Previous"        - Number of the previous node
  # [5] "Next"            - Number of the next node
  # [6] "Responses"       - 
  # [7] "Question"        - User question
  # [8] "Example"         -             
  # [9] "Recommendation"   
  #
  # OUTPUT
  # results (list)        - Fairness metric recommendation along with the node number
  #-------------------------------------------------------------------
  NODE_START <- 1 # Number of the node from which the questionnaire will start
  NODE_END <- -1 # Number of the node at which the questionnaire will end
  node_ <- NODE_START # current node of the iteration
  while(node_ != NODE_END)
  {
    # Step 1: Filter Node rows
    node_data <- ftree_df[which(ftree_df$Node == node_),] 
    rownames(node_data) <- NULL # reset index
    # Wrong condition
    #if(length(node_data$Next) == 1){
    if(node_data[1,]$Next == NODE_END){
      #print("BREAK")
      break
    }
    #}
    # Step2: Question, Example, and Responses
    question_ <- node_data[1,]$Question # picking the questionnaire
    example_ <- node_data[1,]$Example
    responses_ <- node_data[1,]$Responses
    
    print(paste0("QUESTION: ",question_))
    #------------------------------------------------------------
    # Example
    #------------------------------------------------------------
    if(nchar(example_) > 0){
      print(paste0("EXAMPLE: ", example_))
    }
    print(paste0("ANSWER: ", responses_))
    if(nchar(responses_) == 0)
    {
      responses_ = "Yes/No"
    }
    # User response
    user_response_ = user_prompt()
    print(paste0("User response: ", user_response_))
    if((tolower(user_response_) == "y") || (tolower(user_response_) == "yes")){
      user_response_ = "Y"
      print(user_response_)
    }
    else if((tolower(user_response_) == "n") || (tolower(user_response_) == "no")){
      user_response_ = "N"
      print(user_response_)
    }
    # Update node value
    node_data <- node_data[which(node_data$Answer == user_response_),]
    rownames(node_data) <- NULL # reset index
    node_ <- node_data$Next
  }
  #Debug
  #print(paste0("Fairness Metric: ",node_data$Recommendation))
  print(paste0("Fairness Metric: ",node_data[1,]$Recommendation))
  #results = list("node" = node_, "fairness_metric" = node_data$Recommendation)
  results = list("node" = node_, "fairness_metric" = node_data[1,]$Recommendation)
  return(results)
}

#===============================================================================
# MITIGATION MAPPING
#===============================================================================
mitigation_mapping_method <- function(mitigation_mapping_info, fairness_metric_name) {
  # Mitigation method based on the fairness metric
  #
  # INPUT
  # mitigation_mapping_info (data.frame) : Mitigation methods information (fetch from csv file)
  # List of attributes in mitigation methods csv file
  # [1] "Fairness Metric"     - Name of the fairness metric
  # [2] "Mitigation Method"   - Name of the mitigation method based on the fairness metric
  # [3] "Available"           - Mitigation method availability in the github repository
  #
  # OUTPUT
  # mitigation_methods_ (character)            - Mitigation method
  #-----------------------------------------------------------------------------
  # filter rows based on the given fairness metric
  mitigation_methods_ <- mitigation_mapping_info[which(mitigation_mapping_info$Fairness.Metric == fairness_metric_name),]
  # filter mitigation methods available in the EAI github repository
  mitigation_methods_ <- mitigation_methods_[which(mitigation_methods_$Available == TRUE),] 
  rownames(mitigation_methods_) <- NULL # reset index
  # list of mitigation methods based on the input fairness metric
  mitigation_methods_ <- as.vector(unlist(mitigation_methods_$Mitigation.Method))
  if(length(mitigation_methods_) > 1){
    print(paste0("Mitigation methods recommended for ", fairness_metric_name))
    for (x in 1:length(mitigation_methods_)){
      print(paste0(x, ' - ', mitigation_methods_[x]))
    }
    print(paste0("Select number between 1 - ", length(mitigation_methods_)))
    user_response_ = user_prompt()
    user_response_ <- as.integer(user_response_)
    mitigation_methods_ <- mitigation_methods_[user_response_]
    return(mitigation_methods_)
  }
  else{
    return(mitigation_methods_)
  }
}

#-------------------------------------------------------------------------------
# USER PROMPT
# ------------------------------------------------------------------------------  
user_prompt <- function(msg=" ") {
  # User prompt based on the message
  if(interactive() ) {
    user_input <- readline(msg)
  } else {
    cat(msg);
    user_input <- readLines("stdin",n=1);
  }
  return(user_input)
}
#-------------------------------------------------------------------------------

