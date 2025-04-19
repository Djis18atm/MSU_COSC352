# Use an official Clojure image
FROM clojure:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the Clojure source code into the container
COPY hello_name_c.clj .

# Set the default command to run the script with arguments
ENTRYPOINT ["clojure", "-M", "hello_name_c.clj"]
