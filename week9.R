library(tidyverse)
#remember to do your course evaluation
library(magrittr)
library(dplyr)
surveys <- readr::read_csv("data/portal_data_joined.csv")
mloa <- readr::read_csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")

#part 1
#Using a for loop, print to the console the longest species name of each taxon. 
#Hint: the function nchar() gets you the number of characters in a string.

#task: find the species name with the longest number of characters in surveys$speices
#aka the species name where the length of its species name is == to the max length of any species name
#   surveys %>% filter(nchar(surveys$species) == max(nchar(surveys$species))) %>% select(species)
#but that's the overall longest. we want the longest within each taxon, so first we have to subset surveys
#by each taxa

#how to make a forloop? First make one case:
i <- unique(surveys$taxa)[1]
i
mytaxon <- surveys[surveys$taxa == i,]
#see what it looks like:
#head(mytaxon)

#find out what the max name length is
#max(nchar(mytaxon$species))

#look at the boolean vector used to subset the dataframe
nchar(mytaxon$species) == max(nchar(mytaxon$species))

longestnames <- mytaxon %>% filter(nchar(mytaxon$species) == max(nchar(mytaxon$species))) %>% select(species)
#or
#mytaxon[nchar(mytaxon$species) == max(nchar(mytaxon$species)),] %>% select(species)
#or
#mytaxon$species[nchar(mytaxon$species) == max(nchar(mytaxon$species))] 

print(paste0("The longest species name(s) among ", i, "s is/are: "))
print(unique(longestnames$species))
rm(i)
for(i in unique(surveys$taxa)){
  mytaxon <- surveys[surveys$taxa == i,]
  longestnames <- mytaxon[nchar(mytaxon$species) == max(nchar(mytaxon$species)),] %>% select(species)
  print(paste0("The longest species name(s) among ", i, "s is/are: "))
  print(unique(longestnames$species))
}

#spoiler alert: this is how you do it without a for loop in the tidyverse
surveys %>% group_by(taxa) %>% mutate(longestintaxa = max(nchar(species))) %>% 
  filter(nchar(species) == longestintaxa) %>% select(species) %>% unique()


#part 2
mycols <- mloa %>% select("windDir","windSpeed_m_s","baro_hPa","temp_C_2m","temp_C_10m","temp_C_towertop","rel_humid", "precip_intens_mm_hr")
mycols %>% purrr::map(max, na.rm = T)

#part 3
C_to_F <- function(x){
  x * 1.8 + 32
}

mloa$temp_F_2m <- C_to_F(mloa$temp_C_2m)
mloa$temp_F_10m <- C_to_F(mloa$temp_C_10m)
mloa$temp_F_towertop <- C_to_F(mloa$temp_C_towertop)

#Bonus:
mloa %>% select(c("temp_C_2m", "temp_C_10m", "temp_C_towertop")) %>% 
  purrr::map_df(C_to_F) %>% 
  rename("temp_F_2m"="temp_C_2m", "temp_F_10m"="temp_C_10m", "temp_F_towertop"="temp_C_towertop") %>%
  cbind(mloa) %>% head()

#challenge
i <- 1
paste0(surveys$genus[i], " ", surveys$species[i])
rm(i)
surveys$genusspecies <- lapply(1:length(surveys$species), function(i){
  paste0(surveys$genus[i], " ", surveys$species[i])
})
head(surveys$genusspecies)

#but! We don't actually have to do an lapply to paste0 multiple vectors element-wise! 
paste0(1:8, LETTERS[1:8])
paste0(1:8, c(5,NA,9))

mini <- surveys[c(1,300,4000,4098),]
paste0(mini$genus, " ", mini$species)



