# Step 1: Download the HTML file using system command
url = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"
html_file = "page.html"
run(`curl -s -o $html_file $url`)
println("Downloaded HTML file.")

# Step 2: Read HTML content
html_content = read(html_file, String)

# Step 3: Extract table data
tables = []
table_start = "<table"
table_end = "</table>"

global start_pos = 1
while true
    global start_idx = findnext(table_start, html_content, start_pos)
    if start_idx === nothing
        break
    end
    
    start_int = first(start_idx)
    
    end_idx = findnext(table_end, html_content, start_int + length(table_start))
    if end_idx === nothing
        break
    end
    
    end_int = last(end_idx) + length(table_end) - 1
    
    push!(tables, html_content[start_int:end_int])
    
    global start_pos = end_int + 1
end

# Step 4: Save extracted tables into CSV files
for (i, table) in enumerate(tables)
    csv_file = "table_$(i).csv"
    open(csv_file, "w") do f
        table_clean = replace(table, r"<[^>]*>" => ",")
        table_clean = replace(table_clean, r",+" => ",")  # Remove extra commas
        write(f, table_clean)
    end
    println("Saved table to: ", csv_file)
end

println("Extraction complete! CSV files created.")
