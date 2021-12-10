d <- c("2199943210",
       "3987894921",
       "9856789892",
       "8767896789",
       "9899965678")

d <- read_lines('day9.input')

w = nchar(d[1])
h = length(d)

m <- 
d %>% 
  paste(collapse = "") %>% 
  str_split("") %>% 
  unlist() %>% 
  as.numeric() %>% 
  matrix(nrow = h, ncol = w, byrow = 1)

offsets <- expand_grid(x = -1:1, y = -1:1) %>% filter(abs(x) != abs(y))

pts <- vector('numeric')
for(i in 1:ncol(m)) {
  for(j in 1:nrow(m)) {
    point <- m[j,i]
    # js <- j + c(-1,0,1)
    # is <- i + c(-1,0,1)
    # js <- js[js>0 & js <= h]
    # is <- is[is>0 & is <= w]
    # neighbors <- as.vector(m[js, is]) %>% paste(collapse = ",")
    # print(c(i,j))
    offsets %>% 
      mutate(x = x + i,
             y = y + j) %>% 
      filter(x > 0,
             y > 0,
             x <= w,
             y <= h) -> neighbor_locs
    # print(neighbor_locs)
    neighbors <- vector('numeric')
    for(l in 1:nrow(neighbor_locs)){
      neighbors <- c(neighbors, m[neighbor_locs$y[l], neighbor_locs$x[l]])
    }
    # neighbors <- m[neighbor_locs$y, neighbor_locs$x]
    # print(c("point", point, "neighbors", paste(neighbors, collapse = ",")))
    if(point < min(neighbors)) {
      pts <- c(pts, point)
    }
  }
}

sum(pts) + length(pts)