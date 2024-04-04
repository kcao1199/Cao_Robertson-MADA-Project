## ---- packages --------
#load needed packages. make sure they are installed.
library(here) #for data loading/saving
library(dplyr)
library(skimr)
library(ggplot2)
library(knitr)
library(kableExtra)
library(webshot2)
library(tidyverse)
library(gtsummary)

## ---- loaddata --------
#Path to data. Note the use of the here() package and not absolute paths
data_location <- here::here("data","processed-data","cleandata1.rds")
#load data
mydata <- readRDS(data_location)

## ---- table1 --------
summary_df = skimr::skim(mydata)
print(summary_df)
# save to file
summarytable_file = here("results","tables", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)

# Select columns for a summary table
table_vars <- mydata %>%
  select(P_UTDHPV, AGE, SEX, INS_STAT2_I, INCPOV1, RACEETHK, EDUC1, LANGUAGE, RENT_OWN)
table_vars$SEX <- droplevels(table_vars$SEX, exclude = c("DON'T KNOW", "MISSING IN ERROR", "REFUSED"))
table_vars$INS_STAT2_I <- droplevels(table_vars$INS_STAT2_I, exclude = "MISSING Data")

# Create Table 1 (study sample characteristics) from the data
table1 <- table_vars %>% 
  tbl_summary(by = P_UTDHPV,  
              statistic = list(all_categorical() ~ "{n} ({p}%)"),
              label = c(AGE ~ "Age (years)", 
                        SEX ~ "Sex",   
                        INS_STAT2_I ~ "Insurance Status", 
                        INCPOV1 ~ "Poverty Status",      
                        RACEETHK ~ "Race and Ethnicity", 
                        EDUC1 ~ "Maternal Education-level",
                        LANGUAGE ~ "Survey Language",
                        RENT_OWN ~ "Housing Status"), 
              missing = "no"
  ) %>%
  modify_caption("Table 1. Socioeconomic characteristics of U.S. teenagers who have completed or are up-to-date with HPV vaccination series.")
table1

# Save the summary table
saveRDS(table1, file = here("results/tables/table1.rds"))



## ---- INCPORAR_I --------
p1 <- mydata %>% ggplot(aes(x=INCPORAR_I)) + geom_histogram() 
plot(p1)
figure_file = here("results", "figures", "income.png")
figure_image = here("products", "manuscript", "images", "income.png")
ggsave(filename = figure_file, plot=p1) 
ggsave(filename = figure_image, plot=p1) 


## ---- STATE --------
summary(mydata$STATE)
state_distribution <- table(mydata$STATE)
# Convert STATE to character
mydata$STATE <- as.character(mydata$STATE)

# Calculate distribution percentage
state_distribution_percentage <- prop.table(table(mydata$STATE))*100

print(state_distribution_percentage)


p2 <- barplot(state_distribution_percentage, 
        main = "State Distribution Percentage", 
        xlab = "State", 
        ylab = "Percentage",
        col = "skyblue",   # Set bar color
        las = 2) 
#Recreating the graph in ggplot

#adjusting the percent disitrbution data into a data frame
data_df <- as.data.frame(as.table(state_distribution_percentage))

#plot with ggplot
p3 <- ggplot(data_df, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "State Distribution Percentage",
       x = "State",
       y = "Percentage") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

#Viewing the plot to confirm it is done properly
print(p3)

figure_file = here("results", "figures", "state.distribution.png")
figure_image = here("products", "manuscript", "images", "state.distribution.png")
ggsave(filename = figure_file, plot=p3) 
ggsave(filename = figure_image, plot=p3)


## ---- INCQ298A --------
summary(mydata$INCQ298A)
Family_income_distribution <- table(mydata$INCQ298A)

# Calculate distribution percentage
Family_Income_distribution <- prop.table(table(mydata$INCQ298A))*100

print(Family_Income_distribution)


p4 <- barplot(Family_Income_distribution, 
              main = "Family Income Distribution Percentage", 
              xlab = "Income levels", 
              ylab = "Percentage",
              col = "skyblue",   # Set bar color
              las = 2) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

#Recreating the graph in ggplot

#adjusting the percent disitrbution data into a data frame
family_income_df <- as.data.frame(as.table(Family_Income_distribution))

#plot with ggplot
p5 <- ggplot(family_income_df, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Family Income Distribution Percentage",
       x = "Income",
       y = "Percentage")

#Viewing the plot to confirm it is done properly
print(p5)

figure_file = here("results", "figures", "family.income.distribution.png")
ggsave(filename = figure_file, plot=p5) 
figure_image = here("products", "manuscript", "images", "family.income.distribution.png")
ggsave(filename = figure_image, plot=p5) 

## ---- RACEETHK --------
summary(mydata$RACEETHK)
ethnicity_distribution <- table(mydata$RACEETHK)

# Calculate distribution percentage
Ethnicity_distribution <- prop.table(table(mydata$RACEETHK))*100

print(Ethnicity_distribution)


p6 <- barplot(Ethnicity_distribution, 
              main = "Ethnicity Distribution Percentage", 
              xlab = "Ethnicity", 
              ylab = "Percentage",
              col = "skyblue",   # Set bar color
              las = 2) +
theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
#Recreating the graph in ggplot

#adjusting the percent disitrbution data into a data frame
ethnicity_df <- as.data.frame(as.table(Ethnicity_distribution))

#plot with ggplot
p7 <- ggplot(ethnicity_df, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Ethnicity Distribution Percentage",
       x = "Ethnicity",
       y = "Percentage")

#Viewing the plot to confirm it is done properly
print(p7)

figure_file = here("results", "figures", "ethnicity.distribution.png")
ggsave(filename = figure_file, plot=p7) 
figure_image = here("products", "manuscript", "images", "ethnicity.distribution.png")
ggsave(filename = figure_image, plot=p7) 

## ---- RACE_K --------
summary(mydata$RACE_K)
race_distribution <- table(mydata$RACE_K)

# Calculate distribution percentage
Race_distribution <- prop.table(table(mydata$RACE_K))*100

print(Race_distribution)


p8 <- barplot(Race_distribution, 
              main = "Race Distribution Percentage", 
              xlab = "Race", 
              ylab = "Percentage",
              col = "skyblue",   # Set bar color
              las = 2) 
#Recreating the graph in ggplot

#adjusting the percent disitrbution data into a data frame
race_df <- as.data.frame(as.table(Race_distribution))

#plot with ggplot
p9 <- ggplot(race_df, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Race Distribution Percentage",
       x = "Race",
       y = "Percentage")

#Viewing the plot to confirm it is done properly
print(p9)

figure_file = here("results", "figures", "race.distribution.png")
ggsave(filename = figure_file, plot=p9) 
figure_image = here("products", "manuscript", "images", "race.distribution.png")
ggsave(filename = figure_image, plot=p9) 

## ---- INS_STAT2_I --------
summary(mydata$INS_STAT2_I)
insurance_status_distribution <- table(mydata$INS_STAT2_I)

# Calculate distribution percentage
Insurance_distribution <- prop.table(table(mydata$INS_STAT2_I))*100

print(Insurance_distribution)


p10 <- barplot(Insurance_distribution, 
              main = "Insurance Status Distribution Percentage", 
              xlab = "Insurance Status", 
              ylab = "Percentage",
              col = "skyblue",   # Set bar color
              las = 2) 
#Recreating the graph in ggplot

#adjusting the percent disitrbution data into a data frame
insurance_df <- as.data.frame(as.table(Insurance_distribution))

#plot with ggplot
p11 <- ggplot(insurance_df, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Insurance Status Distribution Percentage",
       x = "Insurance Status",
       y = "Percentage")

#Viewing the plot to confirm it is done properly
print(p11)

figure_file = here("results", "figures", "insurance.status.distribution.png")
ggsave(filename = figure_file, plot=p11) 
figure_image = here("products", "manuscript", "images", "insurance.status.distribution.png")
ggsave(filename = figure_image, plot=p11) 

## ---- FACILITY --------
summary(mydata$FACILITY)
Facility_distribution <- table(mydata$FACILITY)

# Calculate distribution percentage
Facility_distribution <- prop.table(table(mydata$FACILITY))*100

print(Facility_distribution)


p12 <- barplot(Facility_distribution, 
              main = "Facility Distribution Percentage", 
              xlab = "Facility", 
              ylab = "Percentage",
              col = "skyblue",   # Set bar color
              las = 2) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
#Recreating the graph in ggplot

#adjusting the percent disitrbution data into a data frame
facility_df <- as.data.frame(as.table(Facility_distribution))

#plot with ggplot
p13 <- ggplot(facility_df, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Facility Distribution Percentage",
       x = "Facility",
       y = "Percentage")

#Viewing the plot to confirm it is done properly
print(p13)

figure_file = here("results", "figures", "facility.distribution.png")
ggsave(filename = figure_file, plot=p13) 
figure_image = here("products", "manuscript", "images", "facility.distribution.png")
ggsave(filename = figure_image, plot=p13) 

## ---- Vaccination --------
summary(mydata$P_UTDHPV)
Vaccination_status_distribution <- table(mydata$P_UTDHPV)

# Calculate distribution percentage
Vaccination_status_distribution <- prop.table(table(mydata$P_UTDHPV))*100

print(Vaccination_status_distribution)


p14 <- barplot(Vaccination_status_distribution, 
              main = "Vaccination Status Distribution Percentage", 
              xlab = "Vaccination Status", 
              ylab = "Percentage",
              col = "skyblue",   # Set bar color
              las = 2) 
#Recreating the graph in ggplot

#adjusting the percent disitrbution data into a data frame
Vaccine_df <- as.data.frame(as.table(Vaccination_status_distribution))

#plot with ggplot
p15 <- ggplot(Vaccine_df, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Vaccination Status Distribution Percentage",
       x = "Vaccination Status",
       y = "Percentage")

#Viewing the plot to confirm it is done properly
print(p15)

figure_file = here("results", "figures", "vaccination.status.distribution.png")
ggsave(filename = figure_file, plot=p15) 
figure_image = here("products", "manuscript", "images", "vaccination.status.distribution.png")
ggsave(filename = figure_image, plot=p15) 

## ---- state-vaccine --------
#Aggregate vaccine status stratified by state
vaccine_state_percent <- mydata %>%
  group_by(STATE) %>%
  summarise(percentage_UTD = sum(P_UTDHPV == "UTD") / n() * 100)

#Create table to display only up-to-date status in percents for each state
table1 <- mydata %>%
  filter(P_UTDHPV == "UTD") %>%
  count(STATE) %>%
  rename(UTD_count = n) %>%
  left_join(vaccine_state_percent, by = "STATE") %>%
  select(STATE, percentage_UTD) %>%
  arrange(STATE)

#Print the table
table_html <- kable(table1, caption = "Vaccine Distribution Percentage per State (Only 'UTD' Status)") %>%
  kable_styling(latex_options = c("striped", "scale_down", "hold_position", "font_size"))

# Render the table as HTML
html_file <- "products/manuscript/images/table.html"
writeLines(as.character(table_html), html_file)

# Convert HTML to image using webshot
webshot(html_file, "products/manuscript/images/state-vaccine-completion.png")

#Write the table to save to the results
write.table(table1, file = here("results","tables", "state-vaccine-completion.txt"), sep = "\t", row.names = FALSE)


## ---- facility-vaccine --------
#Stratifying the HPV vaccine completion by facility
##Make a stacked bar plot to compare which facilities reported UTD patients
p18 <- ggplot(mydata, aes(x = P_UTDHPV, fill = FACILITY)) +
  geom_bar(stat = "count") +  # Use geom_bar() with the count of each facility
  labs(x = "Vaccination Status", y = "Count", title = "Facility Vaccination Completion") +
  theme_minimal()
  print(p18)

#Save the bar plot
figure_file <- here("results", "figures", "facility-vaccination.png")
ggsave(filename = figure_file, plot = p18, width = 8, height = 6, dpi = 300)
figure_image = here("products", "manuscript", "images", "facility-vaccination.png")
ggsave(filename = figure_image, plot=p18) 

## ---- race-ethnicity-vaccine --------
#Aggregate total count per each race-ethnicity factor level
total_count_by_race <- mydata %>%
  group_by(RACEETHK) %>%
  summarise(total_count = n())

#Aggregate count of those with UTD status for each race-enthnicity factor level
UTD_by_race <- mydata %>%
  filter(P_UTDHPV == "UTD") %>%
  group_by(RACEETHK) %>%
  summarise(UTD_count = n())

#Merge the total count and UTD count data frames
vaccine_percent_by_race <- total_count_by_race %>%
  left_join(UTD_by_race, by = "RACEETHK") %>%
  mutate(percentage_UTD = UTD_count / total_count * 100)

# Print the table
kable(vaccine_percent_by_race, caption = "Percentage of UTD Vaccination Status by RACEETHK")

# Save the table as a text file
write.table(vaccine_percent_by_race, file = here("results", "tables", "vaccine_percent_by_race.txt"), sep = "\t", row.names = FALSE)

## ---- fitfig1 --------
#Stratifying the Income-poverty levels to the vaccination status in a boxplot figure
p16 <- mydata %>% ggplot(aes(x=P_UTDHPV, y=INCPORAR_I)) + geom_boxplot()
plot(p16)
figure_file = here("results","figures", "income-vaccination.png")
ggsave(filename = figure_file, plot=p16) 
figure_image = here("products", "manuscript", "images", "income-vaccination.png")
ggsave(filename = figure_image, plot=p16) 

# Fitting Income-poverty levels and Vaccination status to a statistical model
model <- lm(INCPORAR_I ~ P_UTDHPV, data = mydata)
summary(model)

## ---- fitfig2 --------
#Stratifying the Income-poverty levels to the insurance status in a boxplot figure
original_labels <- levels(mydata$INS_STAT2_I)
print(original_labels)

p17 <- mydata %>% 
  ggplot(aes(x=INS_STAT2_I, y=INCPORAR_I, color = P_UTDHPV)) +  
  geom_boxplot() +
  labs(x = "Insurance status", y = "Income-poverty ratio", title = "Income-poverty ratio stratified by insurance and vaccination") +
  scale_x_discrete(labels = c("PRIVATE INSURANCE ONLY" = "Private", "ANY MEDICAID" = "Medicaid", "OTHER INSURANCE (CHIP, IHS, MILITARY, OR OTHER, ALONE OR IN COMB. WITH PRIVATE INSURANCE)" = "Other", "UNINSURED" = "Uninsured")) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))  # Rotate x-axis text by 90 degrees
plot(p17)
figure_file = here("results","figures", "insurance-income-stratified.png")
ggsave(filename = figure_file, plot=p17) 
figure_image = here("products", "manuscript", "images", "insurance-income-stratified.png")
ggsave(filename = figure_image, plot=p17) 

# Fitting Income-poverty levels and insurance status to a statistical model
model <- lm(INCPORAR_I ~ INS_STAT2_I, data = mydata)
summary(model)

## ---- fitfig3 --------
# Fitting Income-poverty levels and insurance status to a statistical model
model <- lm(INCPORAR_I ~ P_UTDHPV, INS_STAT2_I, data = mydata)
summary(model)

## ---- fitfig4 --------
#Stratifying the HPV vaccine completion by both Race-Ethnicity and (choose either insurance or income-poverty status)
p19 <- mydata %>% 
  ggplot(aes(x=INCPORAR_I, y=RACEETHK, color = P_UTDHPV)) +  geom_boxplot()
plot(p19)
figure_file = here("results","figures", "raceeth-income-stratified.png")
ggsave(filename = figure_file, plot=p19) 
figure_image = here("products", "manuscript", "images", "raceeth-income-stratified.png")
ggsave(filename = figure_image, plot=p19) 

# Fitting Income-poverty levels and insurance status to a statistical model
model <- lm(INCPORAR_I ~ P_UTDHPV, RACEETHK, data = mydata)
summary(model)
