library(tidyverse)
#q1
surveys <- read_csv("data/portal_data_joined.csv")

#q2


head(surveys %>% filter(
  weight > 30 & weight < 60), 6)


#OR

surveys %>% 
  filter(weight > 30 & weight < 60) %>% head(6)


#q3

biggest_critters <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(species_id, sex) %>% 
  summarize(max_weight = max(weight))

biggest_critters



#The following attempt ends up with entire categories that are NA,
#which R warns you about
biggest_critters_group_first <- surveys %>% 
  group_by(species_id, sex) %>% 
  summarise(max_weight = max(weight,na.rm=T))





#smallest first
biggest_critters %>% arrange(max_weight)
#biggest first
biggest_critters %>% arrange(desc(max_weight))




#q4

#one way to see number of observations in each group
surveys_na_hindfoot <- surveys %>% 
  filter(is.na(hindfoot_length))
as.data.frame(table(surveys_na_hindfoot$sex, 
                    surveys_na_hindfoot$plot_type))

#another way to see number of observations in each group

#how many na_weight observations are there in each species?
surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(species) %>% 
  tally() %>% 
  arrange(desc(n))

#how many na_weight observations are there in each plot?
surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(plot_id) %>% 
  tally() %>% 
  arrange(desc(n))

#how many na_weight observations are there in each year?
surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(year) %>% 
  tally() %>% 
  arrange(desc(n))

#q5





#making a new column called avg_weight. Note that since we use
#mutate, this makes a new column on the big surveys tibble, where
#each row is a different observation
surveys_avg_weight <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(species_id, sex) %>% 
  mutate(avg_weight = mean(weight)) %>% 
  select(species_id, sex, weight, avg_weight)

surveys_avg_weight
surveys_avg_weight$avg_weight

#q6





#now let's make a new column called above_average
surveys_avg_weight <- surveys_avg_weight %>% 
  mutate(above_average = weight > avg_weight)

surveys_avg_weight
View(surveys_avg_weight)