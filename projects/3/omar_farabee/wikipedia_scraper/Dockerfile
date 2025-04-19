# Use the latest Elixir 1.18 image
FROM elixir:1.18-alpine

# Set working directory
WORKDIR /app

# Install hex and rebar (Elixir build tools)
RUN mix local.hex --force && mix local.rebar --force

# Copy mix files and fetch dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy the rest of the application
COPY . .

# Compile the project
RUN mix compile

# Set the default command to run the scraper
CMD ["iex", "-S", "mix"]
