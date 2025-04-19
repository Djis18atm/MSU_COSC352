open Printf

(* Function to read the HTML file *)
let read_html_file filename =
  let ic = open_in filename in
  let try_read () =
    try Some (input_line ic) with End_of_file -> None
  in
  let rec read_all acc =
    match try_read () with
    | Some line -> read_all (acc ^ line ^ "\n")
    | None -> close_in ic; acc
  in
  read_all ""

(* Function to extract tables manually without regex *)
let extract_tables html =
  let rec find_tables acc start =
    try
      let table_start = String.index_from html start '<' in
      if String.sub html table_start 6 = "<table" then
        let table_end = String.index_from html table_start '/' in
        let table_content = String.sub html table_start (table_end - table_start + 8) in
        find_tables (table_content :: acc) (table_end + 8)
      else
        find_tables acc (table_start + 1)
    with Not_found -> List.rev acc
  in
  find_tables [] 0

(* Function to clean HTML tags and format CSV rows *)
let clean_html_row row =
  let tag_regex = Str.regexp "<[^>]+>" in
  let cleaned = Str.global_replace tag_regex "" row in
  String.trim cleaned

(* Function to parse table rows manually *)
let parse_table table_content =
  let rec extract_rows acc start =
    try
      let row_start = String.index_from table_content start '<' in
      if String.sub table_content row_start 3 = "<tr" then
        let row_end = String.index_from table_content row_start '/' in
        let row_content = String.sub table_content row_start (row_end - row_start + 5) in
        let rec extract_cells acc cell_start =
          try
            let cell_start = String.index_from row_content cell_start '<' in
            if String.sub row_content cell_start 3 = "<td" then
              let cell_end = String.index_from row_content cell_start '/' in
              let cell_content = clean_html_row (String.sub row_content cell_start (cell_end - cell_start + 5)) in
              extract_cells (cell_content :: acc) (cell_end + 5)
            else
              extract_cells acc (cell_start + 1)
          with Not_found -> List.rev acc
        in
        extract_rows ((extract_cells [] 0) :: acc) (row_end + 5)
      else
        extract_rows acc (row_start + 1)
    with Not_found -> List.rev acc
  in
  extract_rows [] 0

(* Function to write a table to a CSV file *)
let write_table_to_csv table filename =
  let oc = open_out filename in
  Printf.printf "Writing %d rows to %s\n" (List.length table) filename;
  List.iter (fun row ->
    fprintf oc "%s\n" (String.concat "," row)
  ) table;
  close_out oc

(* Main function *)
let () =
  let html_content = read_html_file "../data/list_of_largest_companies_wiki.html" in
  print_endline "HTML file loaded successfully.";
  print_endline (String.sub html_content 0 (min 500 (String.length html_content)));
  let tables = extract_tables html_content in
  Printf.printf "Extracted %d tables.\n" (List.length tables);
  let () =
    List.iteri (fun i table ->
      let parsed_table = parse_table table in
      let filename = sprintf "table_%d.csv" (i + 1) in
      write_table_to_csv parsed_table filename
    ) tables
  in
  print_endline "Extraction completed. CSV files generated."


