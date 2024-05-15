#installs required packages if you don't have them already.  If all of these packages are already installed, skip this step.

list.of.packages <- c("jsonlite", "httr", "rvest", "tidyverse", "dplyr", "purrr", "readxl")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

#loads necessary packages
library(jsonlite)
library(httr)
library(rvest)
library(tidyverse)
library(dplyr)
library(purrr)
library(readxl)

#sets the working directory to a folder of your choosing.  Make sure you change your "\", to "/"!
setwd("C:/Users/malon/OneDrive/Documents/GitHub/Dr. Swenson econ replication project")

#This function will automatically create a .csv file with the metadata for an entire volume's worth of articles.
#"start" refers to the first article in the sequence of articles, at the beginning of the volume.  
#"end" refers to the last article in the sequence of articles, at the end of the volume.
yoinkdata = function(start, end){
  #creates a nested function which queries the JSTOR API, and returns with the metadata after converting it from JSON 
  #encryption to data which can be read.
  yoinkmeta = function(x){
    urlbase = "https://labs.jstor.org/api/anno/metadata/"
    useurl = paste(urlbase, as.character(x), sep = "")
    rawdat = GET(url = useurl,
                 headers = "accept: application/json")
    dat = fromJSON(rawToChar(rawdat$content))
    dat2 = as.data.frame(dat)
    dat3 = dat2|>
      group_by(id)|>
      summarize_all(.funs = function(x) paste(unique(x) , collapse = ","))
    return(dat3)
  }
  #defines a sequence of numbers using the "start" and "end" parameters set when calling the function
  numberseq = as.vector(seq(from = start, to = end, by = 1))
  #applies all numbers in the sequence to the nested function, and creates a data frame from the results
  meta_data_frame = map_dfr(numberseq, yoinkmeta)
  #cleans the generated data frame for export
  meta_data_frame = meta_data_frame|>
    #selects only the variables that we want
    select(c(abstract,
             authors,
             issue,
             journal,
             page_count,
             pubdate,
             subtitle,
             title,
             volume,
             year))|>
    #creates new titles using the main title and the subtitle.  
    rename(foretitle = title)|>
    mutate(title = ifelse(is.na(subtitle) == FALSE,paste(foretitle, subtitle, sep = ": "), foretitle))|>
    #removes the old title and the subtitle variables
    select(!c(foretitle, subtitle))|>
    #creates new variables with empty cells (for us to fill in!)
    mutate(accepted_date = "",
           issue_date = "",
           `empirical_ind` = "",
           data_ind = "",
           code_ind = "",
           restricted_ind = "",
           jel = "",
           author_affil = "",
           author_sex = "",
           appendix_length = "",
           num_tables_displayed = "",
           num_figures_displayed = "",
           )
  #creates the file name of the exported .csv file out of the journal, volume, issue and year of the articles.  It is very
  #important that this function NOT be used with articles from multiple issues/volumes/journals/years, or it will make a 
  #character vector
  name = unique(paste(meta_data_frame$journal,
                      meta_data_frame$volume,
                      meta_data_frame$issue,
                      meta_data_frame$year,
                      sep = ", "))
  file_name = paste(name, ".csv", sep = "")
  #returns by writing the .csv file to the working directory.  It will not be saved to the working memory of R, just to the
  #working directory, no need to check in the R Studio client.
  return(write.csv(meta_data_frame, file = file_name))
}

#Now you are ready to run the function!
yoinkdata(27086712,27086719)

#THINGS TO BE AWARE OF:
  #1) The authors are imcomplete, as the metadata only records the primary author of the paper.  For papers with more than 
      #one author, be sure to finish recording the authors of the paper.
  #2) Apostrophies (') will not convert properly from R to a .csv file, be sure to fix them when they happen.
start = 27086712
end = 27086719
#encryption to data which can be read.
yoinkmeta = function(x){
  urlbase = "https://labs.jstor.org/api/anno/metadata/"
  useurl = paste(urlbase, as.character(x), sep = "")
  rawdat = GET(url = useurl,
               headers = "accept: application/json")
  dat = fromJSON(rawToChar(rawdat$content))
  dat2 = as.data.frame(dat)
  dat3 = dat2|>
    group_by(id)|>
    summarize_all(.funs = function(x) paste(unique(x) , collapse = ","))
  return(dat3)
}
#defines a sequence of numbers using the "start" and "end" parameters set when calling the function
numberseq = as.vector(seq(from = start, to = end, by = 1))
#applies all numbers in the sequence to the nested function, and creates a data frame from the results
meta_data_frame = map_dfr(numberseq, yoinkmeta)
#cleans the generated data frame for export
meta_data_frame = meta_data_frame|>
  #selects only the variables that we want
  select(c(abstract,
           authors,
           issue,
           journal,
           page_count,
           pubdate,
           subtitle,
           title,
           volume,
           year))|>
  #creates new titles using the main title and the subtitle.  
  rename(foretitle = title)|>
  mutate(title = ifelse(is.na(subtitle) == FALSE,paste(foretitle, subtitle, sep = ": "), foretitle))|>
  #removes the old title and the subtitle variables
  select(!c(foretitle, subtitle))|>
  #creates new variables with empty cells (for us to fill in!)
  mutate(accepted_date = NA,
         issue_date = NA,
         `empirical_ind` = NA,
         data_ind = NA,
         code_ind = NA,
         restricted_ind = NA,
         jel = NA,
         author_affil = NA,
         author_sex = NA,
         appendix_length = NA,
         num_tables_displayed = NA,
         num_figures_displayed = NA,
  )
#creates the file name of the exported .csv file out of the journal, volume, issue and year of the articles.  It is very
#important that this function NOT be used with articles from multiple issues/volumes/journals/years, or it will make a 
#character vector
name = unique(paste(meta_data_frame$journal,
                    meta_data_frame$volume,
                    meta_data_frame$issue,
                    meta_data_frame$year,
                    sep = ", "))
file_name = paste(name, ".csv", sep = "")
