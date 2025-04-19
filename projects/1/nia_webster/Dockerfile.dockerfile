# Use an official Python runtime as a base image
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app

# Copy the Python script into the container
COPY hello.py .

# Set the default command to run the script
ENTRYPOINT ["python", "hello.py"]
