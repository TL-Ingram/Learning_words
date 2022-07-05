# Pkg load ---------------------------------------------------------------------
suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
  library(here)
  library(lintr)
  library(styler)
})
# lint("_initial_draft.R")
style_file("_initial_draft.R")

# Data load --------------------------------------------------------------------
data <- read_csv("words_from_apple_notes.csv")

# Initial processing -----------------------------------------------------------
process_one <- data %>%
  lapply(function(x) gsub("-.*", "", x)) %>%
  lapply(function(y) gsub("[[:punct:]]", "", y)) %>%
  lapply(function(z) tolower(z)) %>%
  as_tibble(.) %>%
  slice(., -(c(137, 138, 152))) %>%
  distinct(.)

# Altering tense of words that have had output errors --------------------------
process_two <- process_one %>%
  rename("head" = 1) %>%
  mutate(.,
    head = replace(head, head == "sallies", "sally"),
    head = replace(head, head == "vignettes", "vignette"),
    head = replace(head, head == "inured", "inure"),
    head = replace(head, head == "irrevocably", "irrevocable"),
    head = replace(head, head == "deign", "deigned"),
    head = replace(head, head == "yokels", "yokel"),
    head = replace(head, head == "endued", "endue"),
    head = replace(head, head == "appertaining", "appertain")
  )

# Word selection ---------------------------------------------------------------
random_word <- sample_n(process_two, 1) %>%
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
