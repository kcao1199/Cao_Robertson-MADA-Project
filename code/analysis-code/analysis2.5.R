## ---- packages --------
library(tidymodels) # use tidymodels framework.
library(ggplot2) # producing visual displays of data
library(dplyr) # manipulating and cleaning data
library(here) # making relative pathways
library(randomForest) # making random forest model
library(doParallel) # for parallel processing
library(rsample) # for cross validation
library(yardstick)

## ---- load-data --------
# Load and preprocess data
data_location <- here::here("data","processed-data","cleandata1.rds")
mydata <- readRDS(data_location)

# Remove rows with missing values
mydata$SEX <- droplevels(mydata$SEX, exclude = c("DON'T KNOW", "MISSING IN ERROR", "REFUSED"))
mydata$INS_STAT2_I <- droplevels(mydata$INS_STAT2_I, exclude = "MISSING Data")
mydata$STATE <- droplevels(mydata$STATE, exclude = "Missing Data")
mydata$MOBIL_1 <- droplevels(mydata$MOBIL_1, exclude = c("DON'T KNOW", "MISSING IN ERROR", "REFUSED"))
mydata$FACILTY <- droplevels(mydata$FACILITY, exclude = "Missing Data")
mydata$P_UTDHPV <- droplevels(mydata$P_UTDHPV, exclude = "Missing Data")

## ---- split-data --------
# Split data into training and testing datasets
set.seed(123) # seed for reproducibility
split_data <- initial_split(mydata, prop = 0.8) # 80% split for training/testing data
train_data <- training(split_data)
test_data <- testing(split_data)

## ---- first-fit --------
rf_rec <- recipe(P_UTDHPV ~ AGE + SEX + STATE + INS_STAT2_I + INCQ298A + INS_BREAK_I + INCPOV1 + RACEETHK + EDUC1 + LANGUAGE + MOBIL_1 + RENT_OWN + FACILITY, data = train_data) # use full model as recipe for the random forest model

rf_model <- rand_forest()%>% # use rand_forest() to make a random forest model
  set_engine("randomForest", seed = 123)%>%
  set_mode("classification")

rf_workflow <- workflow() %>% # create workflow for rf model
  add_recipe(rf_rec)%>% # apply recipe
  add_model(rf_model) # apply model

rf_fit <- rf_workflow%>%
  fit(data = train_data)%>% # use the workflow to fit the rf model to the data
  print(rf_fit)

## ---- first-metrics --------
# Performance metrics of the first fit
rf_aug <- augment(rf_fit, train_data) # augment to make predictions for rf_fit

metrics <- metric_set(accuracy, f_meas) # create a set of metrics to test for classification
first_fit_metrics <- metrics(truth = P_UTDHPV, estimate = .pred_class, data = rf_aug) # calculate metrics for first fit
print(first_fit_metrics)

## ---- tune --------
tune_spec <- 
  rand_forest(
    mtry = tune(), # parameters of random forest model to tune are the mtry, trees, and min_n
    trees = 100,
    min_n = tune()) %>% 
  set_engine("randomForest", seed = 123) %>% # make sure to set seed again for the tree
  set_mode("classification")

## I used ChatGPT to help me define the tree grid for the parameters mtry and min_n
tree_grid <- grid_regular(mtry(range = c(1, 13)), 
                          min_n(range = c(1, 200)),
                          levels = 6)

rf_tune_wf <- workflow() %>% # create workflow
  add_recipe(rf_rec) %>% # add recipe from earlier
  add_model(tune_spec) # add spec that is defined above

folds_data <- vfold_cv(train_data, v=5 )
# Set the number of cores to use
num_cores <- detectCores() - 1

# Initialize parallel backend
doParallel::registerDoParallel(cores = num_cores)

set.seed(123) # set seed for reproducibility

rf_res <- rf_tune_wf %>%
  tune_grid(
    resamples = folds_data, # use data from the CV folds
    grid = tree_grid)
rf_res %>%
  autoplot()

# Stop parallel processing
stopImplicitCluster()

## ---- tune-metrics --------
rf_res %>%
  collect_metrics() %>% # get metrics from the rf model created
  filter(.metric == "roc_auc") %>% # filter for the roc auc metric
  select(mean, min_n, mtry) %>% # select the columsn for mean, min_n and mtry
  pivot_longer(min_n:mtry,
               values_to = "value",
               names_to = "parameter"
  ) %>%
  # Plot the ROC_AUC to find the ideal min_n and mtry
  ggplot(aes(value, mean, color = parameter)) +
  geom_point(show.legend = FALSE) +
  facet_wrap(~parameter, scales = "free_x") +
  labs(x = NULL, y = "AUC")

## ---- grid-search --------
# grid search tuning
rf_tune_grid <- grid_regular( #define a grid with a range for mtry and min_n
  mtry(range = c(100, 150)),
  min_n(range = c(1, 5)),
  levels = 6
)

rf_tune_grid # display the grid

# Tune using the defined tuning grid
doParallel::registerDoParallel(cores = num_cores)

set.seed(123) # set seed for reproducibility

rf_res2 <- rf_tune_wf %>%
  tune_grid(
    resamples = folds_data, # use data from the CV folds
    grid = rf_tune_grid) # use new tune grid
rf_res2 %>%
  autoplot()

# Stop parallel processing
stopImplicitCluster()

## ---- tune-fit --------
# Specify the metric and optimization criteria
best_auc <- select_best(rf_res2, metric = "roc_auc")

final_rf <- finalize_model( # select the best model based on roc_auc
  tune_spec,
  best_auc
)

# fit the tuned model
rf_rec <- recipe(P_UTDHPV ~ AGE + SEX + STATE + INS_STAT2_I + INCQ298A + INS_BREAK_I + INCPOV1 + RACEETHK + EDUC1 + LANGUAGE + MOBIL_1 + RENT_OWN + FACILITY, data = train_data) # use full model as recipe for the random forest model


rf_workflow <- workflow() %>% # create workflow for rf model
  add_recipe(rf_rec)%>% # apply recipe
  add_model(final_rf) # apply model

rf_fit <- rf_workflow%>%
  fit(data = train_data)%>% # use the workflow to fit the rf model to the data
  print(rf_fit)

## ---- tune_metrics --------
# make predictions
rf_tuned_aug <- augment(rf_tune_fit, train_data)

# find metrics for tuned fit
tuned_fit_metrics <- metrics(truth = P_UTDHPV, estimate = .pred_class, data = rf_tuned_aug) # calculate metrics for first fit
print(tuned_fit_metrics)

## ---- null-model --------
# RF model compared to single predictor model
## Create a single model
rf_rec_null <- recipe(P_UTDHPV ~ SEX, data = train_data) # specify the model with a recipe; I could not get a null model to work so I used one predictor as a minimal model for comparison

rf_spec_null <- rand_forest() %>%
  set_engine("randomForest", importance = TRUE, seed = 123) %>% # set the seed and specify that importance is true
  set_mode("classification")

rf_workflow_null <- workflow() %>% # create workflow with the recipe and spec
  add_recipe(rf_rec_null) %>% 
  add_model(rf_spec_null)

rf_fit_null <- rf_workflow_null %>% # fit the null model
  fit(data = train_data)

# Get predictions from single predictor model
rf_null_aug <- augment(rf_fit_null, train_data)