#Learning dplyr and Tidyr: select, filter, and pipes
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")


#select columns
month_day_year <- select(surveys, month, day, year)

#filtering by equals
filter(surveys, year == 1981)

#filtering by range
filter(surveys, year %in% c(1981:1983))
#why shouldn't you do filter(surveys, year == c(1981, 1982, 1983))

#filtering by multiple conditions
bigfoot_with_weight <- filter(surveys, hindfoot_length > 40 | !is.na(weight))

#multi-step process
small_animals <- filter(surveys, weight < 5)
#this is slightly dangerous because you have to remember to select from 
#small_animals, not surveys in the next step
small_animal_ids <- select(small_animals, record_id, plot_id, species_id)

#same process, using nested functions
small_animal_ids <- select(filter(surveys, weight < 5), record_id, plot_id, species_id)

#same process, using a pipe
#Cmd  Shift  M
#note our select function no longer explicitly calls the tibble as its first element
small_animal_ids <- filter(surveys, weight < 5) %>% select(record_id, plot_id, species_id)

#same as
small_animal_ids <- surveys %>% filter(weight < 5) %>% select(record_id, 
                                                              plot_id, species_id)

#how to do line breaks with pipes
surveys %>% filter(month==1)

#good:
surveys %>% 
  filter(month==1)

#not good:
surveys 
%>% filter(month==1)
#what happened here?