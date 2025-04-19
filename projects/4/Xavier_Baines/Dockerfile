FROM ocaml/opam:alpine

WORKDIR /app

USER root
RUN apk update && apk add m4 bash

USER opam

RUN opam switch create 4.14.0
RUN eval $(opam env) && opam install -y base-unix

COPY . .

# Build using native code and threading
RUN bash -c "eval \$(opam env) && ocamlopt -thread -o extract_tables str.cmxa unix.cmxa threads.cmxa extract_tables.ml"

CMD ["bash", "-c", "eval $(opam env) && ./extract_tables"]
