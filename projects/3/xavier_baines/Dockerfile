FROM ocaml/opam:latest

# Set working directory
WORKDIR /app

# Copy OCaml script into container
COPY extract_tables.ml /app/

# Install OCaml compiler
RUN opam init --disable-sandboxing -y && \
    eval $(opam env) && \
    opam install dune -y

# Compile OCaml script
RUN eval $(opam env) && ocamlc -o extract_tables extract_tables.ml

# Command to run the program
CMD ["/app/extract_tables"]

