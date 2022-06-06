# Pkg load ---------------------------------------------------------------------
suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
  library(here)
  library(lintr)
  library(styler)
})
lint("_initial_draft.R")
style_file("token_generation.R")

# Data load --------------------------------------------------------------------
data <- read_csv("words_from_apple_notes.csv")

# Initial processing -----------------------------------------------------------
process_one <- data %>%
  lapply(function(x) gsub("-.*", "", x)) %>%
  lapply(function(y) gsub("[[:punct:]]", "", y)) %>%
  lapply(function(z) tolower(z)) %>%
  as_tibble() %>%
  slice(-(c(137, 138, 152)))

# Word selection ---------------------------------------------------------------
random_word <- sample_n(process_one, 1) %>%
  as.character()

# 'random word' processing to search appropriate dictionary --------------------
dict_to_search <- substr(random_word, 1, 1) %>%
  toupper()

# First letter uppercase to search dictionary appropriately --------------------
random_word_upper <- str_to_title(random_word)

# Dictionary search ------------------------------------------------------------
dict <- here("dictionary-in-csv", paste(dict_to_search, ".csv", sep = "")) %>%
  read_csv() %>%
  rename("head" = 1) %>%
  filter(grepl(random_word_upper, head)) %>%
  rename({{ random_word_upper }} := 1)

# Write and open .txt file -----------------------------------------------------
filename <- "output.txt"
write.table(dict,
  file = filename, sep = ",",
  row.names = FALSE, col.names = TRUE
)
system(paste(shQuote("notepad"), filename, sep = " "),
  wait = FALSE, invisible = FALSE
)
