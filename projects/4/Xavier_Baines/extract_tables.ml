(* extract_tables.ml *)

open Printf
open Unix
open Thread

(* Extract <table>...</table> sections from HTML *)
let extract_tables html =
  let rec find_tables acc start =
    try
      let open_tag = Str.search_forward (Str.regexp "<table") html start in
      let close_tag = Str.search_forward (Str.regexp "</table>") html open_tag in
      let table_html = String.sub html open_tag (close_tag + 8 - open_tag) in
      find_tables (table_html :: acc) (close_tag + 8)
    with Not_found -> List.rev acc
  in
  find_tables [] 0

let write_csvs base_name tables =
  List.iteri (fun i table ->
    let filename = sprintf "%s_table_%d.csv" base_name (i+1) in
    let oc = open_out filename in
    output_string oc table;
    close_out oc
  ) tables

let read_file path =
  let ic = open_in path in
  let buf = Buffer.create 4096 in
  try
    while true do
      Buffer.add_channel buf ic 4096
    done;
    Buffer.contents buf
  with End_of_file ->
    close_in ic;
    Buffer.contents buf

let process_file path =
  let html = read_file path in
  let tables = extract_tables html in
  let base = Filename.remove_extension (Filename.basename path) in
  write_csvs base tables

let run_sequential paths =
  let start_time = Unix.gettimeofday () in
  List.iter process_file paths;
  let end_time = Unix.gettimeofday () in
  printf "Sequential Execution Time: %.3f seconds\n" (end_time -. start_time)

let thread_worker path () =
  process_file path

let run_multithreaded paths =
  let start_time = Unix.gettimeofday () in
  let threads = List.map (fun path -> Thread.create (thread_worker path) ()) paths in
  List.iter Thread.join threads;
  let end_time = Unix.gettimeofday () in
  printf "Multithreaded Execution Time: %.3f seconds\n" (end_time -. start_time)

let () =
  let files = [
    "data/list_of_largest_companies_wiki.html";
    "data/comparison_of_programming_languages.html"
  ] in

  print_endline "Running sequential mode...";
  run_sequential files;

  print_endline "\nRunning multithreaded mode...";
  run_multithreaded files
