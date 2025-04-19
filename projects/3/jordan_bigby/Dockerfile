# Use the official .NET SDK 8.0 as the base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY extract_tables.csproj ./
RUN dotnet restore

# Copy everything else and build the application
COPY . ./
RUN dotnet build -c Release

# Define entrypoint for the container
ENTRYPOINT ["dotnet", "run", "--project", "extract_tables.csproj"]
