
# Use an HHVM base image
FROM hhvm/hhvm:latest

# Set working directory
WORKDIR /app

# Copy Hack script to container
COPY hello.hack /app/hello.hack

# Set the default command to run the Hack script
ENTRYPOINT ["hhvm", "/app/hello.hack"]
