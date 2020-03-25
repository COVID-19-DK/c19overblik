remove_repeatedRow <- function(data, col, by){
  data[, col_lag := shift(get(col)), by = by]
  data <- data[is.na(get(col)) | get(col) != col_lag]
  data[, col_lag := NULL]
  return(data)
}