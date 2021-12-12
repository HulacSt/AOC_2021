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

# part 2 ==============================
# i just need to find the three largest basins and their size.
# I can renumber everything to a 1 or a 0, 0 if it's a 9, and 1 if it's not.
# Then I need to group every adjacent 1
# then find the three largest groups
# I know this is going to require a search of some kind. Not sure if BFS or DFS


# but I can vizualize it first! 
m %>% 
  as_tibble() %>% 
  mutate(r = row_number()) %>% 
  pivot_longer(cols = 1:(ncol(.)-1)) %>% 
  mutate(c = str_extract(name, "\\d+") %>% as.numeric()) %>% 
  select(r,c,value) -> long

long %>% 
  mutate(value = if_else(value == "9" , NA_real_,1)) %>% 
  ggplot(aes(c,r,fill = value)) +
  geom_tile() +
  theme_minimal() +
  scale_y_reverse() +
  scale_fill_continuous(na.value = 'white') -> basins

basins
# dichotomize the values
n <- 
if_else(m==9,0,1) %>% 
  matrix(nrow = nrow(m))

# ok, now for what I think should be a DFS
# need a function to return the neighboring vailid indices, given indices. 
get_neighbors <- function(r,c) {
  w <- ncol(n)
  h <- nrow(n)
  offsets <- expand_grid(x = -1:1, y = -1:1) %>% filter(abs(x) != abs(y))
  offsets %>% 
    mutate(x = x + c,
           y = y + r) %>% 
    filter(x > 0,
           y > 0,
           x <= w,
           y <= h) -> neighbor_locs
  return(neighbor_locs)
}; #get_neighbors(10,5)

# forget the DFS, i can do it iteratively
# iterate through each location
# if it's a peak(0), assign it group NA
#   else 
#     check the neighboring locations for a group already assigned
#     if a neighbor already has a group, assign this location that group.
#     otherwise assign it a new group

group_basins <- function(mat) {
  basinIDs <- matrix(NA,
                   ncol = ncol(mat),
                   nrow = nrow(mat))
  
  bnum <- 1
  for(r in 1:nrow(mat)) {
    for(c in 1:ncol(mat)) {
      val <- mat[r,c]
      if(val==1) {
        neighbor_inds <- get_neighbors(r,c)
        # get the neighbor basin IDs
        neighbor_bIDs <- vector("numeric")
        for(i in 1:nrow(neighbor_inds)) {
            neighbor_bIDs <- c(neighbor_bIDs, basinIDs[neighbor_inds$y[i],
                                                       neighbor_inds$x[i]])
        }
        neighborID <- unique(neighbor_bIDs[!is.na(neighbor_bIDs) & neighbor_bIDs != 0])
        # print(neighborID)
        # neighborID <- max(neighborID)
        if(length(neighborID > 1)) {
          neighborID <- max(neighborID)
        }
        if(length(neighborID) < 1) {
          basinIDs[r,c] <- bnum
          for(i in 1:nrow(neighbor_inds)) {
            r <- neighbor_inds$y[i]
            c <- neighbor_inds$x[i]
            if(mat[r,c]==1) {
              basinIDs[r,c] <- bnum
            }
          }
          bnum <- bnum + 1
        } else {
          basinIDs[r,c] <- neighborID
          for(i in 1:nrow(neighbor_inds)) {
            r <- neighbor_inds$y[i]
            c <- neighbor_inds$x[i]
            if(mat[r,c]==1) {
              basinIDs[r,c] <- neighborID
            }
          }
          # print(str_glue("r: {r}, c: {c}"))
          # print(neighbor_bIDs)
          # print(neighborID)
          # print(mat)
          # print(basinIDs)
        }
      } else {
        basinIDs[r,c] <- 0
      }
    }
  }
  return(basinIDs)
}; 

bids <- group_basins(n)

bids[1:10,1:10]
bids[90:100,90:100]

bids %>% 
  as.vector() %>% 
  tibble(basin = .) %>% 
  count(basin) %>% 
  filter(basin > 0) %>% 
  slice_max(n, n=3) %>% 
  summarise(sum(n)) %>% 
  pull()

# plot out the basins
bids %>% 
  as_tibble() %>% 
  mutate(r = row_number()) %>% 
  pivot_longer(cols = 1:(ncol(.)-1)) %>% 
  mutate(c = str_extract(name, "\\d+") %>% as.numeric()) %>% 
  select(r,c,bid = value) -> bids_long

long %>% 
  left_join(bids_long) %>% 
  mutate(fl = as.character(bid %% 8)) %>% 
  # mutate(value = if_else(value == "9" , NA_real_,value)) %>% 
  filter(value != 9) %>% 
  ggplot(aes(c,r,fill = fl, alpha = (8-value)/8)) +
  geom_tile() +
  theme_minimal() +
  scale_y_reverse() +
  scale_fill_brewer(palette = "Dark2") -> basins; basins

#something's wrong with assigning basin IDs when I already have one