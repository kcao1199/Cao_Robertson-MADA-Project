###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder
#
# Note the ## ---- name ---- notation
# This is done so one can pull in the chunks of code into the Quarto document
# see here: https://bookdown.org/yihui/rmarkdown-cookbook/read-chunk.html


## ---- packages --------
#load needed packages. make sure they are installed.
library(readxl) #for loading Excel files
library(dplyr) #for data processing/cleaning
library(tidyr) #for data processing/cleaning
library(skimr) #for nice visualization of data 
library(here) #to set paths
library(readr) #for reading various file types in R

## ---- loaddata --------
#The here package is used to create a relative path to the raw data before reading the csv
#The location is called data_locaiton
data_location <- here::here("data/raw-data/NIS-Teen_Data_2022.csv")

#load data. 
#The data is found using the read_csv function and the data location
#The new data frame is called NIS_Teen_Data_2022
NIS_Teen_Data_2022 <- read_csv(data_location)


## ---- exploredata --------
#glipmse at the structure of the data
dplyr::glimpse(NIS_Teen_Data_2022)

#produce summary statistics
summary(NIS_Teen_Data_2022)

#print the first few rows of data from the first several columns
head(NIS_Teen_Data_2022)

#examine the number of missing values and distribution of character data
skimr::skim(NIS_Teen_Data_2022)




## ---- cleandata1 --------
# After inspecting the data, we see that there are several mislabeled variables
#I will change each variable to the desired type using the mutate() function
#from dpylr.
#I will start by changing all of the character variables to factors

NIS_Teen_Data_2022_2 <- NIS_Teen_Data_2022 %>%
  mutate_if(is.character, as.factor)
  dplyr::glimpse(NIS_Teen_Data_2022_2)
  
#Now I will convert the numeric variables that should be factors, to be factors
#I will define their levels and labels using mutate()
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_2 %>%
  mutate(Sex = factor(SEX, levels = c(1, 2), labels = c("male", "female")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Education = factor(EDUC1, levels = c(1, 2, 3 ,4), labels = c("<12yr", "12yr", ">12yr_noncollege", ">12yr_college")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Poverty_status = factor(INCPOV1, levels = c(1, 2, 3, 4), labels = c(">75k_above_poverty", "<=75k_above_poverty", "below_poverty", "unknown")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Family_income = factor(INCQ298A, levels = c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14), labels = c("0-7500", "7501-10000", "10001-17500", "17501-20000", "20001-25000", "25001-30000", "30001-35000", "35001-40000", "40001-50000", "50001-60000", "60001-75000", "75001+")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Language = factor(LANGUAGE, levels = c(1, 2, 3), labels = c("english", "spanish", "other")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Geo_mobility = factor(MOBIL_1, levels = c(1, 2), labels = c("moved", "did_not_move")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Ethnicity = factor(RACEETHK, levels = c(1, 2, 3, 4), labels = c( "hispanic", "nonhispanic_white", "nonhispanic_black", "nonhispanic_other")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Race = factor(RACE_K, levels = c(1, 2, 3), labels = c("white", "black", "other_mixed")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Housing_status = factor(RENT_OWN, levels = c(1,2,3), labels = c("own", "rent", "other")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Wellchild = factor(WELLCHILD, levels = c(1,2,3), labels = c("yes", "no", "unknown")))
NIS_Teen_Data_2022_3 <- NIS_Teen_Data_2022_3 %>%
  mutate(Facility = factor(FACILITY, levels = c(1,2,3,4,5,6), labels = c("public", "hospital", "private", "clinics", "mixed", "unknown")))
  glimpse(NIS_Teen_Data_2022_3)

#Now I will add level labels to the factors that have not yet been defined
#I will leave the UTD factors as 0 and 1 for the ease of analysis. 
#0 means that they are not up to date while 1 means that they are up to date.
  NIS_Teen_Data_2022_4 <- NIS_Teen_Data_2022_3 %>%
    mutate(Insurance = factor(INS_STAT2_I, levels = c(1, 2, 3,4), labels = c("private", "medicaid", "other", "uninsured")))
  NIS_Teen_Data_2022_4 <- NIS_Teen_Data_2022_4 %>%
    mutate(Insurance_break = factor(INS_BREAK_I, levels = c(1, 2, 3,4), labels = c("insured", "Level2", "Level3")))
  glimpse

#I will change INCPORAR to a dbl as it is a numeric variable (a ratio)




#Delete the year column because every value is from the year 2022


# Inspecting the data, we find some problems that need addressing:
# First, there is an entry for height which says "sixty" instead of a number. 
# Does that mean it should be a numeric 60? It somehow doesn't make
# sense since the weight is 60kg, which can't happen for a 60cm person (a baby)
# Since we don't know how to fix this, we might decide to remove the person.
# This "sixty" entry also turned all Height entries into characters instead of numeric.
# That conversion to character also means that our summary function isn't very meaningful.
# So let's fix that first.

d1 <- rawdata %>% dplyr::filter( Height != "sixty" ) %>% 
                  dplyr::mutate(Height = as.numeric(Height))


# look at partially fixed data again
skimr::skim(d1)
hist(d1$Height)


## ---- cleandata2 --------
# Now we see that there is one person with a height of 6. 
# that could be a typo, or someone mistakenly entered their height in feet.
# If we don't know, we might need to remove this person.
# But let's assume that we somehow know that this is meant to be 6 feet, so we can convert to centimeters.
d2 <- d1 %>% dplyr::mutate( Height = replace(Height, Height=="6",round(6*30.48,0)) )


#height values seem ok now
skimr::skim(d2)


## ---- cleandata3 --------
# now let's look at weight
# there is a person with weight of 7000, which is impossible,
# and one person with missing weight.
# Note that the original data had an empty cell. 
# The codebook says that's not allowed, it should have been NA.
# R automatically converts empty values to NA.
# If you don't want that, you can adjust it when you load the data.
# to be able to analyze the data, we'll remove those individuals as well.
# Note: Some analysis methods can deal with missing values, so it's not always necessary to remove them. 
# This should be adjusted based on your planned analysis approach. 
d3 <- d2 %>%  dplyr::filter(Weight != 7000) %>% tidyr::drop_na()
skimr::skim(d3)


## ---- cleandata4 --------
# We also want to have Gender coded as a categorical/factor variable
# we can do that with simple base R code to mix things up
d3$Gender <- as.factor(d3$Gender)  
skimr::skim(d3)


## ---- cleandata5 --------
#now we see that there is another NA, but it's not "NA" from R 
#instead it was loaded as character and is now considered as a category.
#There is also an individual coded as "N" which is not allowed.
#This could be mistyped M or a mistyped NA. If we have a good guess, we could adjust.
#If we don't we might need to remove that individual.
#well proceed here by removing both the NA and N individuals
#since this keeps an empty category, I'm also using droplevels() to get rid of it
d4 <- d3 %>% dplyr::filter( !(Gender %in% c("NA","N")) ) %>% droplevels()
skimr::skim(d4)



## ---- savedata --------
# all done, data is clean now. 
# Let's assign at the end to some final variable
# makes it easier to add steps above
processeddata <- d4
# location to save file
save_data_location <- here::here("data","processed_data","processeddata.rds")
saveRDS(processeddata, file = save_data_location)



## ---- notes --------
# anything you don't want loaded into the Quarto file but 
# keep in the R file, just give it its own label and then don't include that label
# in the Quarto file

# Dealing with NA or "bad" data:
# removing anyone who had "faulty" or missing data is one approach.
# it's often not the best. based on your question and your analysis approach,
# you might want to do cleaning differently (e.g. keep individuals with some missing information)

# Saving data as RDS:
# I suggest you save your processed and cleaned data as RDS or RDA/Rdata files. 
# This preserves coding like factors, characters, numeric, etc. 
# If you save as CSV, that information would get lost.
# However, CSV is better for sharing with others since it's plain text. 
# If you do CSV, you might want to write down somewhere what each variable is.
# See here for some suggestions on how to store your processed data:
# http://www.sthda.com/english/wiki/saving-data-into-r-data-format-rds-and-rdata



