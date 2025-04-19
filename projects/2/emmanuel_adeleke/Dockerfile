# Use Alpine as the base image for building (lightweight and ARM64-compatible)
FROM alpine:latest AS builder

# Set working directory
WORKDIR /app

# Install Crystal and necessary dependencies
RUN apk add --no-cache crystal shards build-base llvm-dev libffi-dev yaml-dev zlib-dev openssl-dev git

# Copy source code
COPY hello.cr /app/hello.cr

# Compile the Crystal program (statically linked)
RUN crystal build hello.cr --release --static

# Use a minimal runtime image
FROM alpine:latest

# Set working directory
WORKDIR /app

COPY --from=builder /app/hello /app/hello

RUN chmod +x /app/hello


ENTRYPOINT ["/app/hello"]
