library(tidyverse)
reticulate::source_python('day6.py')
# did it all in python and that worked well. Now I want to explore David Robinson's
# solution https://twitter.com/drob/status/1467727330663534594
input <- read_lines("day6.input")

n <- as.numeric(str_split (input, ",")[[1]])
# Start with O in position O, as well as in 6, 7, and 8
start<- c(0, table(n), 0, 0, 0)
m<- matrix(0, nrow = 9, ncol = 9)
m[cbind(2:9, 1:8)] <- 1
m[1, c(7,9)]<- 1

reduce(1:256, ~ . %*% m, .init = start) %>% sum() %>% as.character()

