# Use the official Dlang image from Docker Hub
FROM dlang2/dmd-ubuntu:latest

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Build the Dlang application
RUN dmd hello.d -ofhello

# Command to run the application with arguments
CMD ["./hello"]
