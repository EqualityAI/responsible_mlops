
dataframe_to_csv <- function(data_input, path_save){
  # save dataframe to path_save location
  # path_save : complete absolute path along with the filename 
  write.csv(data_input, path_save, row.names = FALSE)
  
}
