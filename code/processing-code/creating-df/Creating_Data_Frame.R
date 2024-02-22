## ---- packages --------
library(readr) #Loading the package to read the fwf
library(here) #Loading the package to produce relative pathway
library(knitr) #Loading in the package for dynamic report generation
library(tidyverse)
library(readxl)
library(dplyr)

## ---- loaddata --------
column_position<- fwf_positions(
  start = c(1, 89, 287, 295, 314, 330, 331, 334, 336, 343, 344, 345,
            347, 353, 359, 362, 472, 473, 495, 496, 497, 502, 504, 1296, 1297
  ),
  end = c(5, 92, 288, 295, 329, 330, 332, 334, 336, 343, 344, 346,
          347, 354, 359, 362, 472, 473, 495, 496, 497, 502, 504, 1296, 1297
  ),
  col_names = c("SEQNUMT", "YEAR", "AGE", "EDUC1", "INCPORAR_I", 
                "INCPOV1", "INCQ298A", "LANGUAGE", "MOBIL_1", "RACEETHK", 
                "RACE_K", "RENT_OWN", "SEX", "STATE", "FACILITY", "WELLCHILD", 
                "P_U13HPV", "P_U13HPV3", "P_UTDHPV", "P_UTDHPV_15", 
                "P_UTDHPV_15INT", "P_UTDHPV2", "P_UTDHPV3", "INS_STAT2_I", 
                "INS_BREAK_I")
)
file_path <- here("data", "raw-data", "NISTEENPUF22.DAT")

data_frame <- read_fwf(file_path, 
                       col_positions = column_position,
                       col_types = cols(.default = "c")
                       )
                     
  
## ---- cleandata --------
EDUC1levels=c(1,2,3,4)
EDUC1labels=c("LESS THAN 12 YEARS", "12 YEARS", "MORE THAN 12 YEARS, NON-COLLEGE GRAD", "COLLEGE GRADUATE")

INCPOVlevels=c(1,2,3,4)
INCPOVlabels=c("ABOVE POVERTY > $75K", "ABOVE POVERTY <= $75K", "BELOW POVERTY", "UNKNOWN")

INCQ298Alevels=c(10,11,12,13,14,3,4,5,6,7,77,8,9,99)
INCQ298Alabels=c("$35001 - $40000", "$40001 - $50000", "$50001 - $60000", "$60001 - $75000", "$75001+", "$0 - $7500", "$7501 - $10000", "$10001 - $17500", "$17501 - $20000", "$20001 - $25000", "DON'T KNOW", "$25001 - $30000", "$30001 - $35000", "REFUSED")

LANGUAGElevels=c(1,2,3)
LANGUAGElabels=c("ENGLISH", "SPANISH", "OTHER")

MOBILlevels=c(1,2,77,98,99)
MOBILlabels=c("MOVED FROM DIFFERENT STATE", "DID NOT MOVE FROM DIFFERENT STATE", "DON'T KNOW", "MISSING IN ERROR", "REFUSED")

RACEETHKlevels=c(1,2,3,4)
RACEETHKlabels=c("HISPANIC", "NON-HISPANIC WHITE ONLY", "NON-HISPANIC BLACK ONLY", "NON-HISPANIC OTHER + MULTIPLE RACE")

RACE_Klevels=c(1,2,3)
RACE_Klabels=c("WHITE ONLY", "BLACK ONLY", "OTHER + MULTIPLE RACE")

RENTOWNlevels=c(1,2,3,77,99)
RENTOWNlabels=c("OWNED OR BEING BOUGHT", "RENTED", "OTHER ARRANGMENT", "DON'T KNOW", "REFUSED")

SEXlevels=c(1,2,77,98,99)
SEXlabels=c("MALE", "FEMALE", "DON'T KNOW", "MISSING IN ERROR", "REFUSED")

STATElevels=c(1,10,11,12,13,15,16,17,18,19,2,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,4,40,41,42,44,45,46,47,48,49,5,50,51,53,54,55,56,6,66,72,78,8,9)
STATElabels=c("ALABAMA", "DELAWARE", "DISTRICT OF COLUMBIA", "FLORIDA", "GEORGIA", "HAWAII", "IDAHO", "ILLINOIS", "INDIANA", "IOWA", "ALASKA", "KANSAS", "KENTUCKY", "LOUISIANA", "MAINE", "MARYLAND", "MASSACHUSETTS", "MICHIGAN", "MINNESOTA", "MISSISSIPPI", "MISSOURI", "MONTANA", "NEBRASKA", "NEVADA",
              "NEW HAMPSHIRE", "NEW JERSEY", "NEW MEXICO", "NEW YORK", "NORTH CAROLINA", "NORTH DAKOTA", "OHIO", "ARIZONA", "OKLAHOMA", "OREGON", "PENNSYLVANIA", "RHODE ISLAND", "SOUTH CAROLINA", "SOUTH DAKOTA", "TENNESSEE", "TEXAS", "UTAH", "ARKANSAS", "VERMONT", "VIRGINIA", "WASHINGTON", "WEST VIRGINIA",
              "WISCONSIN", "WYOMING", "CALIFORNIA", "GUAM", "PUERTO RICO", "U.S. VIRGIN ISLANDS", "COLORADO", "CONNECTICUT")

FACILITYlevels=c(1,2,3,4,5,6, ".")
FACILITYlabels=c("ALL PUBLIC FACILITIES", "ALL HOSPITAL FACILITIES", "ALL PRIVATE FACILITIES", "ALL STD/SCHOOL/TEEN CLINICS OR OTHER FACILITIES", "MIXED", "UNKNOWN", "Missing Data")

WELLCHILDlevels=c(1,2,3)
WELLCHILDlabels=c("YES", "NO", "DON'T KNOW")

UTDlevels=c(0,1, ".")
UTDlabels=c("NOT UTD", "UTD", "Missing Data")

INS_STAT2_Ilevels=c(1,2,3,4, ".")
INS_STAT2_Ilabels=c("PRIVATE INSURANCE ONLY", "ANY MEDICAID", "OTHER INSURANCE (CHIP, IHS, MILITARY, OR OTHER, ALONE OR IN COMB. WITH PRIVATE INSURANCE)", "UNINSURED", "MISSING Data")

INS_BREAK_Ilevels=c(1,2,3,4,".")
INS_BREAK_Ilabels=c("CURRENTLY INSURED BUT UNINSURED AT SOME POINT SINCE AGE 11", "CURRENTLY INSURED AND NEVER UNINSURED SINCE AGE 11", "CURRENTLY UNINSURED BUT INSURED AT SOME POINT SINCE AGE 11", "CURRENTLY UNINSURED AND NEVER INSURED SINCE AGE 11", "Data Missing")

data<-mutate(data_frame,
             SEQNUMT = as.numeric(SEQNUMT), 
             YEAR = as.numeric(YEAR),
             AGE = as.numeric(AGE),
             EDUC1 = factor(EDUC1,levels = EDUC1levels, labels = EDUC1labels),
             INCPORAR_I = as.numeric(INCPORAR_I), 
             INCPOV1 = factor(INCPOV1, levels = INCPOVlevels, labels = INCPOVlabels),
             INCQ298A = factor(INCQ298A, levels = INCQ298Alevels, labels = INCQ298Alabels),             
             LANGUAGE = factor(LANGUAGE, levels = LANGUAGElevels, labels = LANGUAGElabels),
             MOBIL_1 = factor(MOBIL_1, levels = MOBILlevels, labels = MOBILlabels),
             RACEETHK = factor(RACEETHK, levels = RACEETHKlevels, labels = RACEETHKlabels),
             RACE_K = factor(RACE_K, levels = RACE_Klevels, labels = RACE_Klabels),
             RENT_OWN = factor(RENT_OWN, levels = RENTOWNlevels, labels = RENTOWNlabels), 
             SEX = factor(SEX, levels = SEXlevels, labels = SEXlabels),
             STATE = factor(STATE, levels = STATElevels, labels = STATElabels), 
             FACILITY = factor(FACILITY, levels = FACILITYlevels, labels = FACILITYlabels),
             WELLCHILD = factor(WELLCHILD, levels = WELLCHILDlevels, labels = WELLCHILDlabels),
             P_U13HPV = factor(P_U13HPV, levels = UTDlevels, labels = UTDlabels),
             P_U13HPV3 = factor(P_U13HPV3, levels = UTDlevels, labels = UTDlabels),
             P_UTDHPV = factor(P_UTDHPV, levels = UTDlevels, labels = UTDlabels),
             P_UTDHPV_15 = factor(P_UTDHPV_15, levels = UTDlevels, labels = UTDlabels),
             P_UTDHPV_15INT = factor(P_UTDHPV_15INT, levels = UTDlevels, labels = UTDlabels),
             P_UTDHPV2 = factor(P_UTDHPV2, levels = UTDlevels, labels = UTDlabels),
             P_UTDHPV3 = factor(P_UTDHPV3, levels = UTDlevels, labels = UTDlabels),
             INS_STAT2_I = factor(INS_STAT2_I, levels = INS_STAT2_Ilevels, labels = INS_STAT2_Ilabels),
             INS_BREAK_I = factor(INS_BREAK_I, levels = INS_BREAK_Ilevels, labels = INS_BREAK_Ilabels)
)

summary(data)
str(data)

## ---- savedata --------
output_file<- here("data", "processed-data", "NIS_Teen_Data_2022.csv")
write.csv(data, file = output_file, row.names = FALSE)
save_path <- here("./data/processed-data/processeddata.rds")
saveRDS(data, file = save_path )
        
