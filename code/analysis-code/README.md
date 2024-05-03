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


Notes to ourselves [ignore if reviewing this project]: 

The reference files will be deleted for clarity. Review template for the references.


This folder contains code to do some simple exploratory analysis on the processed/cleaned data.
The code produces a few tables and figures, which are saved in the `results` folder.

It's the same code done 3 times:

* First, there is an R script that you can run which does all the computations.
* Second, there is a Quarto file which contains exactly the same code as the R script.
* Third, my current favorite, is a Quarto file with an approach where the code is pulled in from the R script and run.

The last version has the advantage of having code in one place for easy writing/debugging, and then being able to pull the code into the Quarto file for a nice combination of text/commentary and code.

Each way of doing this is a reasonable approach, pick whichever one you prefer or makes the most sense for your setup. Whichever approach you choose, add ample documentation/commentary so you and others can easily understand what's going on and what is done.