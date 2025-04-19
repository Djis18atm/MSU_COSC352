url <- "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"

# Download the HTML file
html_file <- "page.html"
download.file(url, html_file)

# Read the HTML file
html_content <- readLines(html_file, warn = FALSE)

extract_tables_from_html <- function(html) {
  tables <- list()
  table_matches <- gregexpr("<table.*?</table>", html, ignore.case = TRUE, perl = TRUE)[[1]]
  if (table_matches[1] == -1) return(tables)

  for (i in seq_along(table_matches)) {
    start <- table_matches[i]
    end <- start + attr(table_matches, "match.length")[i] - 1
    table_html <- substr(html, start, end)
    rows <- regmatches(table_html, gregexpr("<tr.*?>.*?</tr>", table_html, ignore.case = TRUE, perl = TRUE))[[1]]
    table_data <- list()

    for (row in rows) {
      cells <- regmatches(row, gregexpr("<t[dh].*?>.*?</t[dh]>", row, ignore.case = TRUE, perl = TRUE))[[1]]
      clean_cells <- gsub("<.*?>", "", cells)
      clean_cells <- gsub("&nbsp;", " ", clean_cells)
      clean_cells <- trimws(clean_cells)
      table_data <- append(table_data, list(clean_cells))
    }

    tables <- append(tables, list(table_data))
  }

  return(tables)
}

write_tables_to_csv <- function(tables, prefix) {
  for (i in seq_along(tables)) {
    filename <- paste0(prefix, "_table_", i, ".csv")
    table_matrix <- do.call(rbind, lapply(tables[[i]], function(row) {
      length_diff <- max(sapply(tables[[i]], length)) - length(row)
      if (length_diff > 0) row <- c(row, rep("", length_diff))
      row
    }))
    write.table(table_matrix, file = filename, sep = ",", row.names = FALSE,
                col.names = FALSE, na = "", quote = TRUE, fileEncoding = "UTF-8")
    cat("Wrote", filename, "\n")
  }
}

process_file <- function(filepath, prefix) {
  if (!file.exists(filepath)) {
    cat("File not found:", filepath, "\n")
    return()
  }
  html <- paste(readLines(filepath, warn = FALSE), collapse = "\n")
  tables <- extract_tables_from_html(html)
  if (length(tables) == 0) {
    cat("No tables found in", filepath, "\n")
  } else {
    write_tables_to_csv(tables, prefix)
  }
}

run_sequential <- function(files) {
  start_time <- proc.time()
  for (i in seq_along(files)) {
    process_file(files[i], paste0("revenue_url", i))
  }
  end_time <- proc.time()
  elapsed <- end_time - start_time
  cat("Sequential Execution Time:", round(elapsed["elapsed"], 2), "seconds\n")
}

run_multithreaded <- function(files) {
  start_time <- proc.time()
  pids <- c()
  for (i in seq_along(files)) {
    pid <- system2("Rscript", args = c("extract_tables_worker.R", files[i], paste0("revenue_url", i)), wait = FALSE)
    pids <- c(pids, pid)
  }
  # Wait for all child processes
  while (length(system("pgrep -f extract_tables_worker.R", intern = TRUE)) > 0) {
    Sys.sleep(0.5)
  }
  end_time <- proc.time()
  elapsed <- end_time - start_time
  cat("Multithreaded Execution Time:", round(elapsed["elapsed"], 2), "seconds\n")
}

setwd("/app")

main <- function() {
  files <- c("page.html")  # Hardcoded HTML file paths

  cat("=== Running Sequential Mode ===\n")
  run_sequential(files)

  cat("\n=== Running Multithreaded Mode ===\n")
  run_multithreaded(files)
}

main()
