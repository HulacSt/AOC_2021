library(tidyverse)
# load data ==============================
test <- F
d <- c('7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1',
        '22 13 17 11  0',' 8  2 23  4 24','21  9 14 16  7',' 6 10  3 18  5',
        ' 1 12 20 15 19',' 3 15  0  2 22',' 9 18 13 17  5',
        '19  8  7 25 23','20 11 10 24  4','14 21 16 12  6',
        '14 21 17 24  4','10 16 15  9 19','18  8 23 26 20',
        '22 11 13  6  5',' 2  0 12  3  7')

d_real <- read_lines('day4.input', skip_empty_rows = T)

if(test == F) {
  d <- d_real
}
# head(d_real)

# parse data ==============================
calls <- d[1] %>% str_split(',') %>% unlist() %>% as.numeric()

# make the boards =========================
raw_boards <- d[-1]
all_lines <- 
  raw_boards %>% 
  str_squish() %>% 
  str_split('\\s+') %>% 
  map(as.numeric)


## list starting rows
get_starting_rows <- function(raw_boards) {
  all <- 1:length(raw_boards)
  j5 <- all[all %% 5 == 0]
  return(j5-4)
}; #get_starting_rows(raw_boards)

## select from raw
select_board <- function(starting_row, raw_boards = raw_boards) {
  all_lines[starting_row:(starting_row+4)] %>%
    unlist() %>% 
    as.numeric() %>% 
    matrix(nrow = 5, ncol = 5, byrow = T) %>% 
    return()
}

## make em
boards <- 
raw_boards %>% 
  get_starting_rows() %>% 
  map(select_board)

# board functions ==============================
update_board <- function(board, call) {
  board[board==call] <- NA
  return(board)
}

all.na <- function(x) {
  all(is.na(x))
}; #all.na()

# check board
# if true the board is a winner
check_board <- function(board) {
  columns <- as.list(data.frame(board))
  rows <- as.list(data.frame(t(board)))
  randc <- c(columns,rows)
  randc %>% 
    map(all.na) %>% 
    unlist() %>% 
    any()
}

boardSum <- function(board) {
  sum(board, na.rm = T)
}

# run the game ==============================
# for each c in call, update every board in boards
run_game <- function(bds = boards, cls = calls) {
  for(i in 1:length(cls)) {
    c <- cls[i]
    # print(bds)
    winners <- map_lgl(bds, check_board)
    if(all(winners)) {
      windex <- which(winners)
      board_sum <- boardSum(bds[[windex]])
      last_number <- cls[i-1]
      score  <-  board_sum * last_number
      return(list(board_sum = board_sum,
                  last_number = last_number,
                  score = score))
    } else {
      bds <- map(bds, update_board, call = c)
    }
  }
}; run_game()

# part 2 ==============================
run_game <- function(bds = boards, cls = calls) {
  last_winners <- c()
  for(i in 1:length(cls)) {
    c <- cls[i]
    # print(bds)
    winners <- map_lgl(bds, check_board)
    print(winners)
    if(all(winners == 1)) {
      # which winner is not in last winners?
      windex <- 
        tibble(winners, last_winners) %>% 
        mutate(i = row_number()) %>% 
        filter(winners == T,
               last_winners== F) %>% 
        pull(i)
      print(windex)
      print(str_glue("newest winner: {windex}"))
      # print(windex)
      board_sum <- boardSum(bds[[windex]])
      last_number <- cls[i-1]
      score  <-  board_sum * last_number
      return(list(board_sum = board_sum,
                  last_number = last_number,
                  score = score))
    } else {
      bds <- map(bds, update_board, call = c)
      last_winners <- winners
    }
  }
}; run_game()

