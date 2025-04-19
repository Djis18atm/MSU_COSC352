args <- commandArgs(trailingOnly = TRUE)
file_path <- args[1]
prefix <- args[2]

source("extract_tables.R")  # Reuse main logic

process_file(file_path, prefix)
