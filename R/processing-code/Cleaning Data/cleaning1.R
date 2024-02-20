#I will start cleaning by examining if there are any missing values within the data set.
##First, I load the libraries that I need for exploratory analysis.
## 
## ---- packages2 --------

library(here)
library(dplyr)
library(skimr)
library(ggplot2)
library(tidyr)
library(naniar)


#First, I load the data into a usable data frame.
## ---- loaddata2 --------

data_location <- here::here("data","processed-data","processeddata.rds")
NISTeenVax <- readRDS(data_location)


#Next, I will check the structure of the data and I will check for any NA or missing values in the data frame.
## ---- exploredata2 --------
str(NISTeenVax)
dplyr::glimpse(NISTeenVax)
NA_columns <- colSums(is.na(NISTeenVax))
print(NA_columns)


#There are no missing values, but there may be missing data that is filled with a character value within the data frame. I will first find the character value assigned to missing variables by exploring the levels of each variable using the sapply() and then lapply() function.

factor_cols <- sapply(NISTeenVax, is.factor) #Find the columns that are factor variables
factor_levels <- lapply(NISTeenVax[, factor_cols, drop = FALSE], levels) #Find the levels of each factor variable
print(factor_levels)#Pritn factor levels for only the factor columns

#Several columns contain factor levels that are labelled, "Data missing", "Missing data", "Unknown", "Refused", Missing in error", and "Don't know". I will replace these values for each variable with an NA in R so that they will be counted as missing values for analysis.
## ---- cleandata2 --------
missing_values <- c("Data Missing", "MISSING Data", "Missing Data", "DON'T KNOW", "UNKNOWN", "MISSING IN ERROR", "REFUSED") #Group all of the factor levels that indicate a missing value

#After back and forth with ChatGPT3.5, it suggested to use the dplyr mutate function and replace function to specify that factor variables with the levels in the group above will have those level values replaced with NA
NISTeenVax2 <- NISTeenVax %>% #Create new dataframe
  mutate(across(where(is.factor), ~ replace(., . %in% missing_values, NA))) #mutate only at factor variables in the dataframe and replace the levels specified above with NA for those factors

#Now I will be able to check for NA values using the skim() function. I can also display the NA values graphically using gg_miss_var()

skimr::skim(NISTeenVax2)
gg_miss_var(NISTeenVax2)

#The most important factors for this analysis is the response variables called variations of "P_UTDHPV".
#We have 27,024 missing values for each of these columns. These missing values may have come from the same survey type, however analysis cannot be performed when this crucial data is missing. For this reason, I will find the rows where these missing values take place, ensure that they are all the same rows for the multiple variables, and delete these rows specifically.
#I used chatGPT3,5 to find the function to select for certain rows using dplyr and then filter these for NA values
##I prompted it by using the variable names a,b,c and asked for it to select these columns and filter for the rows with missing variables
rows_with_missing_in_all <- NISTeenVax2 %>%
  select("P_U13HPV", "P_U13HPV3", "P_UTDHPV", "P_UTDHPV_15", "P_UTDHPV_15INT", "P_UTDHPV2", "P_UTDHPV3") %>% #select for columns in question
  filter_all(any_vars(is.na(.))) #Find rows with NA values

##I then prompted ChatGPT3.5 to provide me with code to display the location of these rows so that I may check if they all matched.
if (nrow(rows_with_missing_in_all) > 0) {
  print("Rows with missing values in aforementioned variables")
  print(rows_with_missing_in_all)
} else {
  print("No rows with missing values in aforementioned variables")
}


#It seems that all of the missing rows match for all of these variables. This means that we may delete the rows that contain missing values for all of the specified variables.
#Because the variables listed all contain missing values in the same rows, I will select only one variable to filter.

NISTeenVax3 <- NISTeenVax2 %>%
  filter(!is.na(P_UTDHPV)) #drop the rows with NA values in P_UTDHPV
skimr::skim(NISTeenVax3) #check again for missing values in these variables
gg_miss_var(NISTeenVax3)

#The majority of data is missing from the WELLCHILD column, which indicates whether the teen had receieved a Well Child visit in recent years. Because this is not crucial to out analysis, I will delete this column. 
#The year column in unnecessary, since all values are from the year 2022. So, I will also delete the YEAR column.

NISTeenVax4 <- NISTeenVax3 %>% #create a new data frame for the filtered data
 select(-WELLCHILD, -YEAR) #Use the select() filter to delete multiple columns from the data frame
str(NISTeenVax4) #Check the remaining variables

#Save cleaned data as an RDS file.
## ---- savedata2 --------
output_file2<- here("data", "processed-data", "NIS_Teen_Data_2022_clean1.csv")
write.csv(NISTeenVax4, file = output_file2, row.names = FALSE)
saveRDS(NISTeenVax4, file = "./data/processed-data/cleandata1.rds")



