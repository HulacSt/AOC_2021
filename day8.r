library(tidyverse)

inp <- "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce" %>% str_split("\\n") %>% unlist()

inp <- read_lines('day8.input')

# part 1
inp %>% 
  str_extract("(?<=\\|\\s).*") %>% 
  paste(collapse = " ") %>% 
  str_split(" ") %>% 
  unlist() %>% 
  nchar() -> b

b[b %in% c(2,3,4,7)] %>% length()

# checking some assumptions
{inp %>% 
  str_remove_all("\\| ") %>% 
  str_split(., " ") %>% 
  map(nchar) %>% 
  map(table) %>% 
  bind_rows() %>% 
  # mutate_all(sign) %>% 
  summarise_all(sum)

# so each of them has at least one word of each character length
# how many words per?
inp %>% 
  str_remove_all("\\| ") %>% 
  str_split(., " ") %>% 
  map_int(length) %>% 
  table()

# each sentence has 14 words
# do they all have four after the pipe?
inp %>% 
  str_extract("(?<=\\|\\s).*") %>% 
  str_remove_all("\\| ") %>% 
  str_split(., " ") %>% 
  map_int(length) %>% 
  table()
}
# yes. Good, so I don't have to make **Too** many assumptions. 14 words per line, each nchar represented at least once, 4 words in the output


# part 2 =====
arrange_letters <- function(word) {
  ls <- str_split(word, "") %>% unlist()
  ls2 <- ls[order(ls)]
  paste(ls2, collapse = "")
  # paste(ls[order(ls)], collapse = "")
}; #arrange_letters("fdgacbe")

inp %>% 
  str_remove_all("\\|\\s") %>% 
  str_split(" ") %>% 
  map_depth(2, arrange_letters) %>% 
  map_depth(1, unlist) -> data

inp %>% 
  str_remove_all("\\|\\s") %>% 
  str_split(" ") -> data

update_patterns <- function(words_counts) {
  wc <- words_counts %>% filter(!is.na(dec))
  patterns <- wc$words
  names(patterns) <- wc$dec
  return(patterns)
}

count_differences <- function(wordA, wordB) {
  a = str_split(wordA, "") %>% unlist()
  b = str_split(wordB, "") %>% unlist()
  AninB <- (sum(!(a %in% b)))
  BninA <- (sum(!(b %in% a)))
  return(max(AninB, BninA))
}; count_differences("cabg", 'ca')

txt_superset <- function(word, tomatch) {
  letters_to_match <- str_split(tomatch, '') %>% unlist()
  
  for(l in letters_to_match) {
    if(str_detect(word, l, negate = TRUE)) {
      return(FALSE)
    }
  }
  return(TRUE)
};

txt_superset_V <- Vectorize(txt_superset, "word")


correct <- tribble(~words, ~correct,
                   "acedgfb", 8,
                   "cdfbe", 5,
                   "gcdfa", 2,
                   "fbcad", 3,
                   "dab", 7,
                   "cefabd", 9,
                   "cdfgeb", 6,
                   "eafb", 4,
                   "cagedb", 0,
                   "ab", 1) %>% mutate(words = map_chr(words, arrange_letters))



count_differences <- function(wordA, wordB) {
  a = map_int(letters[1:7], str_detect, string = wordA)
  b = map_int(letters[1:7], str_detect, string = wordB)
  sum(!(b==a))
}; count_differences('cabg', 'ca')



decipher <- function(words) {
  dd_tab <- tibble(dec = 0:9,
                    nc  = c(6,2,5,5,4,5,6,3,7,6))
  easy <- dd_tab %>% 
    group_by(nc) %>% 
    mutate(n = n()) %>% 
    filter(n == 1) %>% 
    select(-n)
  
  unscramble <- tibble(words) %>%
    mutate(wordScramble = words) %>% 
    mutate(words = map_chr(words, arrange_letters))
  # print(unscramble)
  
  words_counts <- 
    tibble(words) %>%
    # mutate(wordScramble = words) %>% 
    mutate(words = map_chr(words, arrange_letters)) %>% 
    mutate(nc = nchar(words)) %>%
    left_join(easy, by = "nc") %>% 
    distinct_all(.keep_all = 1) %>% 
    mutate(dec = as.numeric(dec))
  patterns <- update_patterns(words_counts)
  
  words_counts %>% 
    mutate(dec = 
             case_when(
               !is.na(dec) ~ dec,
               txt_superset_V(words, patterns['4']) ~ 9,
               txt_superset_V(words, patterns['7']) & nc == 5 ~ 3,
               TRUE ~ NA_real_
             ))  -> words_counts
  patterns <- update_patterns(words_counts)
  
  words_counts <-
  words_counts %>%
    mutate(word7 = words[dec ==7 & !is.na(dec)])  %>%
    mutate(diffFrom7 = map2_int(.x = words,
                                .y = word7,
                                .f = count_differences))

  words_counts$dec[words_counts$diffFrom7 == 5] <- 6
  words_counts$dec[is.na(words_counts$dec) & words_counts$nc == 6] <- 0
  
  words_counts <-
    words_counts %>%
    mutate(word9 = words[dec ==9 & !is.na(dec)])  %>%
    mutate(diffFrom9 = map2_int(.x = words,
                                .y = word9,
                                .f = count_differences))
  
  words_counts$dec[words_counts$diffFrom9 == 3 & is.na(words_counts$dec)] <- 2
  words_counts$dec[is.na(words_counts$dec) & words_counts$nc == 5] <- 5
  
  words_counts %>% 
    select(words, dec) %>% 
    arrange(dec) %>% 
    left_join(unscramble, by = 'words')
  # # patterns
  # print(w9)

  
}; decipher(c("acedgfb",
              "cdfbe",
              "gcdfa",
              "fbcad",
              "dab",
              "cefabd",
              "cdfgeb",
              "eafb",
              "cagedb",
              "ab",
              "cdfeb",
              "fcadb",
              "cdfeb",
              "cdbaf")) %>% left_join(correct)

tr <- function(i) {
  key <- decipher(data[[i]]) %>% 
    select(wordScramble, dec) %>% 
    distinct_all(.keep_all = T)
  data[[i]][11:14] %>% 
    tibble(x = .) %>% 
    inner_join(key, by = c('x' = 'wordScramble')) %>% 
    pull(dec) %>%
    paste(collapse = "") %>% 
    as.numeric()
};

map_dbl(1:length(data),tr) %>% 
  sum()
