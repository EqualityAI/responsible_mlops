#===============================================================================
# ML Results - Remove TP, TN, FP, FN
#===============================================================================
res_rem_tfpn <- function(ml_results){
  res_keys <- names(ml_results)
  # e.g. "TN", "TP", ...
  rem_key <- list("TP", "TN", "FP", "FN")
  for (key_ in res_keys) {
    if (key_ %in% rem_key) {
      ml_results[key_] <- NULL
    }
  }
  return(ml_results)
}