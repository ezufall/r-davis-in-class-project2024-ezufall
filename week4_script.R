#why dplyr? it makes it easier
#to manipulate tables

#tidyr helps you convert
#between different data formats,
#which can help with plotting
#and analysis

#they are more transparent
#than base R functions (stuff
#that automatically comes with
#R)

#set-up: install the tidyverse
#package that has dplyr and tidyr
install.packages("tidyverse")

#Learning dplyr and Tidyr: select, filter, and pipes
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")


#select columns
month_day_year <- select(surveys, month, day, year)
genus_species_taxa <- select(???)

#filtering by equals (number)
surveys_1981 <- filter(surveys, year == 1981)

#filtering by equals (string)
surveys_neotoma <- filter(surveys, genus == "Neotoma")

surveys_rodent_bird <- filter(surveys, taxa ????)
#can we think of another way?
surveys_rodent_bird_2 <- filter(surveys, taxa ????)

identical(surveys_rodent_bird, surveys_rodent_bird_2)

#filtering by range
filter(surveys, year %in% c(1981:1983))
#why shouldn't you do filter(surveys, year == c(1981, 1982, 1983))

#filtering by multiple conditions
bigfoot_with_weight <- filter(surveys, hindfoot_length > 40 | !is.na(weight))

#ord's kangaroo rats who were in the control plot
control_ordii <- filter(surveys, species == "ordii" ??? plot_type == "Control")



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