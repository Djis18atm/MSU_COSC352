# Use the official D language image
FROM dlang/dmd

# Set the working directory inside the container
WORKDIR /app

# Copy the project files into the container
COPY extract_tables.d .

# Compile the D program
RUN dmd extract_tables.d -ofextract_tables

# Default command to run the compiled binary
CMD ["./extract_tables"]
