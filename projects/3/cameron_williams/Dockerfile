FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    curl \
    build-essential \
    && curl -fsSL https://ziglang.org/download/index.html | bash \
    && mv /zig-linux-x86_64-*.tar.xz /usr/local/bin/zig \
    && rm -rf /zig-linux-x86_64-*.tar.xz \
    && apt-get clean

WORKDIR /app

COPY . /app

RUN zig build-exe main.zig -lxml2

ENTRYPOINT ["./main"]
