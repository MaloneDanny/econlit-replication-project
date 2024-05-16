library(tidyverse)
library(pdftools)
library(tm)
library(SnowballC)
library(tidytext)
library(dplyr)
library(ggplot2)


setwd("C:/Users/malon/OneDrive/Documents/GitHub/Dr. Swenson econ replication project")

files = list.files(pattern = "pdf$")
files

opinions <- lapply(files, pdf_text)

#creates a list of all authors of the article

pdf_test = pdf_text("Czernich-BROADBANDINFRASTRUCTUREECONOMIC-2011.pdf")

pdf_test2 = tibble(text = unlist(pdf_test))
pdf_test3 = pdf_test2[1,]
pdf_test4 = data_frame(unlist(str_split(string = pdf_test3$text, "Source")))
pdf_test5 = data_frame(unlist(str_split(string = pdf_test4[1,1], pattern = "Author")))

author_list = data_frame(gsub("\\(s\\): ", "", pdf_test5[2,1]))
title = data_frame(pdf_test5[1,1])
title = str_to_title(title)

#create a list of all intelligible words in the raw text

tidy_pdf = pdf_test2|>
  unnest_tokens(word, text)|>
  mutate(table_dummy = ifelse(word == "table", TRUE, FALSE),
         figure_dummy = ifelse(word == "figure", TRUE, FALSE))|>
  mutate(table_suffix = ifelse(table_dummy == TRUE, lead(word), NA),
         figure_suffix = ifelse(figure_dummy == TRUE, lead(word), NA))

#count the number of unique tables (WHICH ARE NOT FORMATTED HORIZONTALLY)

table_pdf = tidy_pdf|>
  filter(is.na(table_suffix) == FALSE)
table_pdf = unique(table_pdf)
num_tables_value = as.numeric(count(table_pdf))
table_pdf = table_pdf|>
  mutate(num_tables = num_tables_value,
         tables_counted = paste(table_pdf$table_suffix, collapse = ", "))|>
  select(c(num_tables, tables_counted))
table_pdf = unique(table_pdf)

#count the number of unique figures (WHICH ARE NOT FORMATTED HORIZONTALLY)

figure_pdf = tidy_pdf|>
  filter(is.na(figure_suffix) == FALSE)
figure_pdf = unique(figure_pdf)
num_figures_value = as.numeric(count(table_pdf))
figure_pdf = figure_pdf|>
  mutate(num_figures = num_figures_value,
         figures_counted = paste(figure_pdf$figure_suffix, collapse = ", "))|>
  select(c(num_figures, figures_counted))
figure_pdf = unique(figure_pdf)

  
#combine the results into a single data set

results = cbind(title, author_list, table_pdf, figure_pdf)
result_col_names = c("title", "authors", "num_tables", "tables_counted", "num_figures", "figures_counted")
colnames(results) = result_col_names


#attempt to find the academic affiliations of the authors
#problem arises from the presence of multiple instances of the authors names in the first page, lack of reliable clean results

first_page = pdf_test2[2,]
author_string = gsub("and",",",author_list[1,1])
author_data_frame = data_frame(unlist(str_split(pattern = ",",author_string)))
author_data_frame = data_frame(trimws(author_data_frame$`unlist(str_split(pattern = ",", author_string))`))
colnames(author_data_frame) = "authors"
author_vector = author_data_frame$authors

test = data_frame(unlist(str_split(pattern = author_data_frame$authors),string = first_page[1]))

