# Analysis Code Folder
This 'analysis-code' folder will contain the quarto documents, including both code and analysis commentary. Please run the .qmd files in numerical, starting with `analysis1.qmd` onwards. 

analysis1.qmd: The initial 

Summary
- analysis1: GLM and Stepwise Logistic Regression Model
The study utilized a stepwise logistic regression modeling approach to predict teen vaccination status, employing socioeconomic and demographic predictors. Data preprocessing involved loading the dataset, model fitting, diagnostic checks for nonlinearity and multicollinearity, and exploration of predictors influencing HPV vaccination among teenagers.

- analysis2: PCA and LASSO Regression Model (H20)
The study employed dimension reduction via PCA and LASSO regression to mitigate collinearity issues in a teen vaccination survey dataset. LASSO regression effectively selected important predictors while simplifying the model, leading to consistent performance in subsequent cross-validation.

- analysis2.5: Random Forest Model
This script develops a random forest model to predict teen HPV vaccination status, undergoing data preprocessing, model tuning, and evaluation, culminating in the identification of influential predictors and insights into model performance.

- analysis3: LASSO Regression Model (Tidymodel)
This document details the implementation of LASSO regression for predicting teen HPV vaccination status, covering data preprocessing, model tuning, and evaluation.

- analysis4: Elastic Net Regression Model
This document explores the implementation of an Elastic Net regression model for predicting teen HPV vaccination status. It covers data loading, preprocessing, initial model fitting, tuning, and evaluation. 
