
# Use HHVM official image
FROM hhvm/hhvm:latest

# Set working directory inside the container
WORKDIR /app

# Install wget (required to download the webpage)
RUN apt-get update && apt-get install -y wget

# Copy the Hack script to the container
COPY scrape_tables.hack /app/scrape_tables.hack

# Give execution permission (if needed)
RUN chmod +x /app/scrape_tables.hack

# Set HHVM as the default command to execute the script
ENTRYPOINT ["hhvm", "/app/scrape_tables.hack"]
