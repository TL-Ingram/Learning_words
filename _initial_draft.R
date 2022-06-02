# Pkg load ---------------------------------------------------------------------
suppressPackageStartupMessages({
     library(tidyverse)
     library(lubridate)
     library(here)
     library(lintr)
     library(styler)
}
)
# Data load --------------------------------------------------------------------
data <- read_csv("words_from_apple_notes.csv")

# Initial processing -----------------------------------------------------------
process_one <- data %>%
     lapply(function(x) gsub("-.*","", x)) %>%
     lapply(function(y) gsub("[[:punct:]]", "", y)) %>%
     lapply(function(z) tolower(z)) %>%
     as_tibble() %>%
     slice(-(c(137, 138, 152)))

# Word selection ---------------------------------------------------------------
random_word <- sample_n(process_one, 1) %>%
     as.character()

# 'random word' processing to search appropriate dictionary --------------------
dict_to_search <- substr(random_word, 1,1) %>%
     toupper()

# Dictionary search ------------------------------------------------------------
dict <- here("dictionary-in-csv", paste(dict_to_search, ".csv", sep = "")) %>%
     read_csv() %>%
     rename("head" = 1) %>%
     filter(grepl(random_word, head))


df <- df %>% filter(str_detect(Name, "^"))

dplyr::filter(substr(Name,1,1) == "J")









