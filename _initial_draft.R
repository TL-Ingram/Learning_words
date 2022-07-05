# Pkg load ---------------------------------------------------------------------
suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
  library(here)
  library(lintr)
  library(styler)
})
# lint("_initial_draft.R")
# style_file("_initial_draft.R")

# Data load --------------------------------------------------------------------
data <- read_csv("words_from_apple_notes.csv", show_col_types = F)

# Initial processing -----------------------------------------------------------
process_one <- data %>%
  lapply(function(x) gsub("-.*", "", x)) %>%
  lapply(function(y) gsub("[[:punct:]]", "", y)) %>%
  lapply(function(z) tolower(z)) %>%
  as_tibble(.) %>%
  slice(., -(c(137, 138, 152))) %>%
  distinct(.) %>%
  rename(., "original" = 1)

# Adjust spelling of words that error using adj_word.csv -----------------------
adj_word  <- read_csv(here("misspelling", "adj_word.csv"), 
                      show_col_types = F) %>%
  right_join(., process_one, by = "original") %>%
  mutate(., original = coalesce(correct, original)) %>%
  select(., -correct)

# Word selection ---------------------------------------------------------------
random_word <- sample_n(adj_word, 1) %>%
  as.character(.)

# 'random word' processing to search appropriate dictionary --------------------
dict_to_search <- substr(random_word, 1, 1) %>%
  toupper(.)

# First letter uppercase to search dictionary appropriately --------------------
random_word_upper <- str_to_title(random_word)

# Dictionary search ------------------------------------------------------------
dict <- read_csv(here("dictionary-in-csv", paste(dict_to_search, ".csv",
  sep = ""
)),
show_col_types = F
) %>%
  rename(., "head" = 1) %>%
  filter(., grepl(random_word_upper, head)) %>%
  rename(., {{ random_word_upper }} := 1)

# How many times the words have appeared. 05July2022 ---------------------------
word_count <- read_csv(here("freq", "concatonated.csv"), show_col_types = F) %>%
  rbind(., random_word) %>%
  group_by(., word) %>%
  summarise(., count = n()) %>%
  write_csv(here("freq", "concatonated.csv"))

# Write and open .txt file -----------------------------------------------------
filename <- "output.txt"
write.table(dict,
  file = filename, sep = ",",
  row.names = FALSE, col.names = TRUE
)
system(paste(shQuote("notepad"), filename, sep = " "),
  wait = FALSE, invisible = FALSE
)
