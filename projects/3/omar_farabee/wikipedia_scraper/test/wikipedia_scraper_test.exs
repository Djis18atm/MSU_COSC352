defmodule WikipediaScraperTest do
  use ExUnit.Case
  doctest WikipediaScraper

  test "greets the world" do
    assert WikipediaScraper.hello() == :world
  end
end
