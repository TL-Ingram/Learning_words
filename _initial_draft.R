# Pkg load ---------------------------------------------------------------------
suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
  library(here)
  library(lintr)
  library(styler)
})
# lint("_initial_draft.R")
# style_file("token_generation.R")

# Data load --------------------------------------------------------------------
data <- read_csv("words_from_apple_notes.csv")

# Initial processing -----------------------------------------------------------
process_one <- data %>%
  lapply(function(x) gsub("-.*", "", x)) %>%
  lapply(function(y) gsub("[[:punct:]]", "", y)) %>%
  lapply(function(z) tolower(z)) %>%
  as_tibble() %>%
  slice(-(c(137, 138, 152))) %>%
  distinct()

# Altering tense of words that have had output errors --------------------------
process_two <- process_one %>%
  rename("head" = 1) %>%
  mutate(head = replace(head, head == "sallies", "sally")) %>%
  mutate(head = replace(head, head == "vignettes", "vignette")) %>%
  mutate(head = replace(head, head == "inured", "inure")) %>%
  mutate(head = replace(head, head == "irrevocably", "irrevocable")) %>%
  mutate(head = replace(head, head == "deign", "deigned")) %>%
  mutate(head = replace(head, head == "yokels", "yokel")) %>%
  mutate(head = replace(head, head == "endued", "endue")) %>%
  mutate(head = replace(head, head == "appertaining", "appertain"))

# Word selection ---------------------------------------------------------------
random_word <- sample_n(process_two, 1) %>%
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
