# Use an official R base image
FROM r-base:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the R script into the container
COPY hw.R .

# Set the default command to run the script
ENTRYPOINT ["Rscript", "hw.R"]
