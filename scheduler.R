library(taskscheduleR)
library(here)

taskscheduler_create(taskname = "word_dict", rscript = "C:/R_projects/dict/_initial_draft.R", 
                     schedule = "MINUTE", starttime = "11:48", modifier = 100)


here("_initial_draft.R")
taskscheduler_stop("word_dict")
taskscheduler_delete("word_dict")

# taskscheduler_stop("test_run_2")
# taskscheduler_delete("test_run_2")

# tasks <- taskscheduler_ls()
# tasks