FROM rust:latest

WORKDIR /app

COPY src/main.rs .

RUN rustc main.rs -o hello

ENTRYPOINT ["./hello"]