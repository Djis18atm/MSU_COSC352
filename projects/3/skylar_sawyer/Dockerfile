FROM r-base:latest

# Set working directory
WORKDIR /app

# Copy the R script into the container
COPY extract_tables.R /app/extract_tables.R

# Set the entrypoint to run the R script
CMD ["Rscript", "/app/extract_tables.R"]
