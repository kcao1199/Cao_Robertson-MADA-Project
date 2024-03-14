The folders raw data and processed data include the NIS Teen Vaccination Survey Data from 2022. The original DAT file is placed in the 'raw-data' folder while the processed data is contained in the 'processed-data' folder. 

The data files here are loaded/manipulated/changed/saved using the code from the 'code' folders.

The DAT fine in the 'raw-data' folder, has not been changed, but manipulated with code to produce the CSV files in the 'processed-data' folder.

Note: Sub-folders under 'processed-data' will be created if further processing steps are required. 

Dr. Handel's notes:

I suggest you save your processed and cleaned data as RDS or RDA/Rdata files. This preserves coding like factors, characters, numeric, etc. If you save as CSV, that information would get lost.
However, CSV is better for sharing with others since it's plain text. If you do CSV, you might want to write down somewhere what each variable is.

See here for some suggestions on how to store your processed data:

http://www.sthda.com/english/wiki/saving-data-into-r-data-format-rds-and-rdata
