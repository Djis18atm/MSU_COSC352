
FROM elixir:latest


WORKDIR /usr/src/omar_farabee


COPY project2.exs .


ENTRYPOINT ["elixir", "project2.exs"]
