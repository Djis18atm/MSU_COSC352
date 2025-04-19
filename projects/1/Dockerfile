# Use an official Python runtime as a base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the local Python program into the container
COPY hello.py /app/hello.py

# Set the entrypoint for the container
ENTRYPOINT ["python", "/app/hello.py"]
