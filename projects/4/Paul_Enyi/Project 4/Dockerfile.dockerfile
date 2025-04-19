
FROM haskell:8

WORKDIR /app

RUN apt-get update && apt-get install -y curl

COPY MultiUrlTableExtractor.hs ./

RUN ghc --make MultiUrlTableExtractor.hs -threaded -O2 -o extractor

RUN curl -L -o page.html \
     "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"

VOLUME ["/app"]

CMD ["./extractor", "+RTS", "-N"]
