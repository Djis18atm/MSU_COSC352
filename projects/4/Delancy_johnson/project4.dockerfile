FROM dlang/dmd

WORKDIR /app
COPY . .

RUN dub init --type=minimal extract_tables || true
RUN cp extract_tables.d source/app.d
RUN dub build --compiler=dmd

CMD ["./extract_tables"]
