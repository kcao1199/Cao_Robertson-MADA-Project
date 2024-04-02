The 'eda-code' folder contains the code used to do exploratory data analysis in the 'edacode.R' file, which is which is considered supplementary to the 'EDA-code.qmd' file, which has both the EDA code and commentary. The 'EDA-code_files' folder contains the 'figure-html' folder with the figures that were produced through the exploratory analysis. 


Our notes [ignore if reviewing this project]: 

Reference files can be found in the template repo. 

This folder contains code to do some simple exploratory data analysis (EDA) on the processed/cleaned data.
The code produces a few tables and figures, which are saved in the appropriate `results` sub-folder.

It's the same code done 3 times:

* First, there is an R script that you can run which does all the computations.
* Second, there is a Quarto file which contains exactly the same code as the R script.
* Third, my current favorite, is a Quarto file with an approach where the code is pulled in from the R script and run.

The last version has the advantage of having code in one place for easy writing/debugging, and then being able to pull the code into the Quarto file for a nice combination of text/commentary and code.

Each way of doing this is a reasonable approach, pick whichever one you prefer or makes the most sense for your setup. Whichever approach you choose, add ample documentation/commentary so you and others can easily understand what's going on and what is done.