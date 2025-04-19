install.packages("languageserver")

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  cat("Usage: Rscript hw.R <name> [number]\n")
  quit(status = 1)
}

name <- args[1]

num <- ifelse(length(args) > 1 && grepl("^[0-9]+$", args[2]), as.numeric(args[2]), 1)

for (i in 1:num) {
  cat("Hello", name, "\n")
}
