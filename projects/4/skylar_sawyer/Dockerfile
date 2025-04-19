FROM r-base:4.3

WORKDIR /app

COPY extract_tables.R .
COPY extract_tables_worker.R .

CMD ["Rscript", "extract_tables.R"]
