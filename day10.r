# day 10
offsets <- expand_grid(x = -1:1, y = -1:1) %>% filter(abs(x) != abs(y))

get_neighbors <- function(r,c) {
  w <- ncol(m)
  h <- nrow(m)
  offsets %>% 
    mutate(x = x + c,
           y = y + r) %>% 
    filter(x > 0,
           y > 0,
           x <= w,
           y <= h) %>% 
    rename(r = y, c = x) -> neighbor_locs
  return(neighbor_locs)
}; get_neighbors(3,5)