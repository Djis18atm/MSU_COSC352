# Use the official Julia image
FROM julia:1.9

# Set the working directory
WORKDIR /app

# Copy the script into the container
COPY extract_tables.jl /app/extract_tables.jl

# Set the default command to run the script
CMD ["julia", "/app/extract_tables.jl"]