This folder contains the code used for processing our data. The original code is in R documents contained within sub-folders. <s>while the 'Processing-Quarto-Output.qmd' file pulls R code from both R documents in chunks to provide a cumulative commentary on data processing. </s> The `Processing-Quarto-Output.qmd` includes both the code (found in the .R scripts) and the commentary for context. (This was performed for clarity and ease of reproducibility)


The 'cleaningdata' folder contains the R document with the original code to clean the data. The 'creating-df' folder contains the R document <s> with code to pull the data from the original datafile and create a new data frame with our desired variables. </s> with which we performed the preliminary data processing. The code is then copied on to the `Processing-Quarto-Output.qmd` for clarity. The 'Processing-Quarto-Output_files' folder and 'figure-html' sub-folder contains all of the figures produced from the data cleaning code.

Our notes [ignore if reviewing repository]:
This folder contains code for processing data.

It's the same code done 3 times:

* First, there is an R script that you can run which does all the cleaning.
* Second, there is a Quarto file which contains exactly the same code as the R script.
* Third, my current favorite, is a Quarto file with an approach where the code is pulled in from the R script and run.

The last version has the advantage of having code in one place for easy writing/debugging, and then being able to pull the code into the Quarto file for a nice combination of text/commentary and code.

Each way of doing this is a reasonable approach, pick whichever one you prefer or makes the most sense for your setup. Whichever approach you choose, add ample documentation/commentary so you and others can easily understand what's going on and what is done.

