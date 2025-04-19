# Use the official Julia image
FROM julia:1.9

# Set the working directory
WORKDIR /app

# Copy the Julia script into the container
COPY hello.jl /app/hello.jl

# Set the default command to run the script
ENTRYPOINT ["julia", "/app/hello.jl"]
CMD []
