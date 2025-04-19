FROM michalhodur/gleam



# Set the working directory

WORKDIR /app



# Initialize a new Gleam project named "hello"

RUN gleam new hello



# Set working directory inside the project

WORKDIR /app/hello



# Copy source files (optional, if you have existing code to include)

COPY . /main.gleam



# Build the Gleam project

RUN gleam build



# Set the entry point to run the Gleam app

CMD ["gleam", "run"]