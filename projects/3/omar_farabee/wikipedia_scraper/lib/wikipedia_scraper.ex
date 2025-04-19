defmodule WikipediaScraper do
  def fetch_companies do
    url = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"

    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        companies = extract_companies(body)
        write_to_csv(companies)

      {:ok, %HTTPoison.Response{status_code: status}} ->
        IO.puts("Failed to fetch page, status code: #{status}")
        []

      {:error, reason} ->
        IO.puts("HTTP request failed: #{inspect(reason)}")
        []
    end
  end

  defp extract_companies(html) do
    try do
      html
      |> Floki.parse_document!()
      |> Floki.find("table.wikitable tbody tr")
      |> Enum.map(&extract_row/1)
      |> Enum.reject(&(&1 == nil))  # Remove nil entries
    rescue
      e -> 
        IO.puts("Error parsing HTML: #{inspect(e)}")
        []
    end
  end

  defp extract_row(row) do
    row
    |> Floki.find("td")
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
    |> case do
      [rank, name, revenue, country, sector | _rest] when rank != "" and name != "" and revenue != "" ->
        %{
          rank: rank,
          name: name,
          revenue: revenue,
          country: country,
          sector: sector
        }

      _ ->
        nil
    end
  end

  defp write_to_csv(companies) do
    headers = ["Rank", "Name", "Revenue", "Country", "Sector"]

    # Open the file in write mode, creating it if it doesn't exist
    File.open("companies.csv", [:write, :utf8], fn file ->
      CSV.encode([headers] ++ Enum.map(companies, &Map.values/1))
      |> Enum.each(&IO.write(file, &1))
    end)

    IO.puts("Data written to companies.csv")
  end
end
