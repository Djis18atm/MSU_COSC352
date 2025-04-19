# Use the official Haskell image
FROM haskell:8

# Set the working directory inside the container
WORKDIR /app

# Copy the Haskell script into the container
COPY haskell-project2.hs .

# Set the default command to run the script
ENTRYPOINT ["runhaskell", "haskell-project2.hs"]