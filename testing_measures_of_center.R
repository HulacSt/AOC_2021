# day 7.
# which measure of center minimizes absolute errors?

Harmonic.Mean <- function(x, na.rm = TRUE) {
  if (na.rm == FALSE & any(is.na(x))) {
    avg <- NA
  } else{
    avg <- 1 / mean(1 / x, na.rm = TRUE)
  }
  return(avg)
}
vals <- runif(100)

get_mae <- function(vals, moc) {
  sum(abs(vals - moc)) / length(vals)
}; 

get_results <- function() {
  vals <- runif(100)
  
  # arithmetic mean
  arit_mean <- get_mae(vals = vals, moc = mean(vals))
  
  # median
  median <- get_mae(vals = vals, moc = median(vals))
  
  # geometric mean
  geo_mean <- get_mae(vals = vals, moc = exp(mean(log(vals[vals>0]))))
  
  # harmonic mean
  harm_mean <- get_mae(vals = vals, moc = Harmonic.Mean(vals))
  
  tribble(~moc, ~val,
          "arithmetic mean", arit_mean,
          "median", median,
          "geometric mean", geo_mean,
          "harmonic mean", harm_mean) %>% 
    slice_min(val) %>% 
    pull(moc)
}; get_results()


