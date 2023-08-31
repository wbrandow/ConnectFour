# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the .csproj and .sln files to the container
COPY *.csproj *.sln ./

# Restore the dependencies
RUN dotnet restore

# Copy the rest of the application code to the container
COPY . .

# Build the application
RUN dotnet build

# Publish the application
RUN dotnet publish -c Release -o out --no-restore

# Use a runtime image for the final image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the published output from the build image
COPY --from=build /app/out ./

# Set the entry point for the application
ENTRYPOINT ["dotnet", "Index.razor"]
