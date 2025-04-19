# Use the official Python image from Docker Hub (version 3.9 slim)
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the hello.py file into the container at the working directory
COPY hello.py /app/hello.py

# Define the default command to run the hello.py script
ENTRYPOINT ["python", "hello.py"]

# Set the default arguments for the hello.py script (name="Amos" and number="3")
CMD ["Amos", "3"]



