# test distinct function works appropriately

process_one <- data %>%
     lapply(function(x) gsub("-.*", "", x)) %>%
     lapply(function(y) gsub("[[:punct:]]", "", y)) %>%
     lapply(function(z) tolower(z)) %>%
     as_tibble() %>%
     slice(-(c(137, 138, 152))) %>%
     group_by_at(c(1)) %>%
     filter(n() > 1)

# Test if can use external .csv to rename misspelled words
adj_word  <- read_csv(here("misspelling", "adj_word.csv"), 
                      show_col_types = F) %>%
        right_join(process_one, by = "original") %>%
        mutate(., original = coalesce(correct, original)) %>%
        select(-correct)