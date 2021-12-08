library(tidyverse)



# x <- c(16,1,2,0,4,2,7,1,2,14)
x <- read_lines('day7.input') %>% str_split(",") %>% unlist() %>% as.numeric()

med <- median(x)
sum(abs(x-median(x)))

# part 2
# model fuel usage and come up with a way to ca;culate center
calculate_fuel <- function(x) {
  x * (x + 1)/2
}; calculate_fuel(10)

tibble(poss) %>% 
  mutate(fl = calculate_fuel(poss))

sum_fuel <- function(c) {
  sum(calculate_fuel(abs(x - c)))
}

tibble(poss = seq(min(x),max(x),1)) %>% 
  mutate(fuel = map_dbl(poss, sum_fuel)) %>% 
  ggplot(aes(poss, y = fuel)) +
  geom_line() +
  scale_y_log10()
