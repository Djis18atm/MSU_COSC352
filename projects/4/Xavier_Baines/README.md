# Project 4: Multi-URL HTML Table Extractor with Sequential and Multithreaded Execution

**Author:** Xavier Baines  
**Course:** COSC352 – Morgan State University  
**Directory:** MSU_COSC352/projects/4/Xavier_Baines/

## Overview

This OCaml project extends a previous single-file HTML table extractor to support multiple HTML sources. It extracts all `<table>...</table>` elements from local HTML files and exports them as individual CSV files. The program supports both **sequential** and **multithreaded** execution and reports the time taken for each mode.

## Features

- Extracts `<table>` tags from multiple HTML files
- Saves each table to a separate CSV file
- Supports:
  - **Sequential execution**
  - **Multithreaded execution**
- Prints execution times for both modes
- Fully Dockerized using `ocaml/opam:alpine`
- Uses only native OCaml libraries

## Project Files

- `extract_tables.ml` — OCaml program
- `Dockerfile` — builds and runs the app
- `README.md` — project documentation
- `data/` — input HTML files:
  - `list_of_largest_companies_wiki.html`
  - `comparison_of_programming_languages.html`
- Output CSVs:
  - `list_of_largest_companies_wiki_table_1.csv`, etc.
  - `comparison_of_programming_languages_table_1.csv`, etc.

## Build & Run Instructions

### Build the Docker image:

```bash
docker build -t project4 .
