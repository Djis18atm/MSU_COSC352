FROM openjdk:8-jre-slim
LABEL authors="keith"

# Set the working directory to /app
WORKDIR /app
# Copy the current directory contents into the container at /app
COPY . /app
# Install Scala
RUN apt-get update && \
    apt-get install -y scala
# Compile the Scala code
RUN scalac Hello.scala
# Run the Scala program
ENTRYPOINT ["scala", "Hello"]
