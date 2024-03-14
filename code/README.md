This folder contains the R and Quarto files containing all of the original code.

The 'analysis-code' folder contains all of the code used for the data analysis, model fitting, and model testing. 

The 'eda-code' folder contains code used for exploratory data analysis.

The 'processing-code' folder contains code for pulling the data and cleaning the data.

The code in the R documents are pulled into Quarto documents for each step in the workflow. To view the code with commentary, the Quarto documents should be run in the order of 'processing-code' > 'Processing-Quarto-Output.qmd', then 'eda-code' > 'EDA-code.qmd', and lastly 'analysis-code' > 'analysis-code.qmd'.