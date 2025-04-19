import gleam/io
import gleam/string

pub fn main() {
  let url = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"

  // Download HTML using Erlang httpc
  let html = fetch_html(url)

  case html {
    Ok(body) ->
      let tables = extract_tables(body)
      write_tables_to_csv(tables)
      io.println("Done extracting tables.")
    Error(e) ->
      io.println("Error fetching HTML: " <> e)
  }
}

// Fetch HTML using Erlang httpc
fn fetch_html(url: String) -> Result(String, String) {
  let _ = erlang:application_start("inets")
  let result = erlang:apply(erlang:module("httpc"), erlang:function("request"), ["GET", tuple(url), []])
  case result {
    tuple("ok", tuple(_, tuple(_, body))) -> Ok(body)
    _ -> Error("Failed to fetch")
  }
}

// Very basic table extraction
fn extract_tables(html: String) -> List(List(String)) {
  let parts = string.split(html, "<table")
  let _ = list.drop(parts, 1) // Drop content before first <table
  list.map(parts, fn(part) {
    let content = string.split(part, "</table>")
    let raw = list.at(content, 0)
    case raw {
      Some(inner) -> extract_rows(inner)
      None -> []
    }
  })
}

// Extract <tr><td>...</td></tr> rows as CSV
fn extract_rows(table_html: String) -> List(String) {
  let rows = string.split(table_html, "<tr")
  list.map(rows, fn(row) {
    let cols = string.split(row, "<td")
    let data = list.map(list.drop(cols, 1), fn(cell) {
      let cell_end = string.split(cell, "</td>")
      list.at(cell_end, 0) |> case(_) {
        Some(txt) -> string.trim(txt)
        None -> ""
      }
    })
    string.join(data, ",")
  })
}

// Write tables to CSV files
fn write_tables_to_csv(tables: List(List(String))) {
  list.index_map(tables, fn(table, i) {
    let file_name = "table_" <> int.to_string(i + 1) <> ".csv"
    let csv = string.join(table, "\n")
    let _ = io.write_file(file_name, csv)
  })
}
