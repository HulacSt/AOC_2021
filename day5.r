library(tidyverse)

d <- "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2" %>% 
  str_split('\n') %>% 
  unlist()

d_real <- read_lines('day5.input')

test <- F

if(!test) {
  d <- d_real
}

# Part 1 ==============================

# parse the input
# i want a data frame
coords <- 
d %>% 
  tibble(txt = .) %>% 
  separate(col = txt,
           into = c("x1","y1","x2","y2"),sep = "\\,|\\s\\-\\>\\s" ) %>% 
  mutate_all(as.numeric)


# make a matrix of the space
xlim <- range(c(coords$x1, coords$x2))
ylim <- range(c(coords$y1, coords$y2))

xval <-  seq(from = xlim[1], to = xlim[2], by = 1)
yval <-  seq(from = ylim[1], to = ylim[2], by = 1)

blank_mat <- 
matrix(data = 0,
       nrow = length(yval),
       ncol = length(xval),
       dimnames = list(yval,xval))

# iteratively update the matrix with each line

## get diagonals given line ends that aren't in a line 
get_diags <- function(x1,x2,y1,y2) {
  xmin <- min(x1,x2)
  xmax <- max(x1,x2)
  ymin <- min(y1,y2)
  ymax <- max(y1,y2)
  # don't need to worry about hte case of a line with 
  # length 1 since that's captured in the x1==x2 below
  for_out <- tibble(x=NULL,y=NULL)
  if(xmin==x1 & ymin == y1 | xmax == x1 & ymax == y1) {
    return(tibble(x = seq(xmin,xmax,1),
                  y = seq(ymin,ymax,1)))
  } else if(xmin == x1) {
    return(tibble(x = seq(xmin,xmax,1),
                  y = seq(ymax,ymin,-1)))
  } else {
    return(tibble(x = seq(xmax,xmin,-1),
                  y = seq(ymin,ymax,1)))
  }
}; get_diags(1,5,1,5); get_diags(5,1,5,1); get_diags(1,5,5,1); get_diags(5,1,1,5)

## function to turn line ends into all points on the line
ends_to_points <- function(x1,y1,x2,y2) {
  x1o <- which(xval == x1)
  x2o <- which(xval == x2)
  y1o <- which(yval == y1)
  y2o <- which(yval == y2)
  xs <- seq(min(x1o,x2o), max(x1o,x2o),1)
  ys <- seq(min(y1o,y2o), max(y1o,y2o),1)
  
  poss <- expand_grid(x=xs,y=ys)
  if (x1o==x2o | y1o == y2o) {
    return(poss)
  } else {
    #magic diagonal stuff
    return(get_diags(x1o,x2o,y1o,y2o))
  }

}; #ends_to_points(coords[3,])


# now I have all of the points covered
all_points <- pmap_dfr(coords, ends_to_points)

increment_point <- function(x,y) {
  blank_mat[y,x] <- blank_mat[y,x] + 1
}

add_points <- function(bm = blank_mat, pts) {
  for(i in 1:nrow(pts)) {
    x <- pts$x[i]
    y <- pts$y[i]
    bm[y,x] <- bm[y,x] + 1
  }
  return(bm)
}

add_points(pts = all_points)

#print it like AOC
print_AOC <- function(matrix) {
  matrix[matrix==0] <- "."
  matrix %>% 
    as.data.frame.matrix() %>% 
    print()
}; all_points %>% add_points(pts=.) %>% print_AOC()

# count the number of values in the matrix that fit the criteria
all_points %>% 
  add_points(pts=.) %>%
  as.vector() %>%
  as_tibble() %>% 
  filter(value >= 2) %>% 
  nrow()

