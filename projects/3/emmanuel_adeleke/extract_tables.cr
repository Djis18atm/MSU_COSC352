# require "http/client"
# require "csv"
# require "io"
# require "colorize"

# # Create the directory if it doesn't exist
# Dir.mkdir("extract_tables") unless Dir.exists?("extract_tables")

# url : String = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"
# response : HTTP::Client::Response = HTTP::Client.get(url)
# html_content : String = response.body.to_s # to_s means convert to string

# puts "Downloaded HTML content from #{url}.".colorize.green
# puts "HTML content size: #{html_content.size} bytes.".colorize.blue

# # make the html content into tables
# tables = html_content.split("<table")[1..-1].map { |table|  # skip the first element, took forever to figure out lol
#   table.split("</table>").first  
# }

# puts "Found #{tables.size} tables.".colorize.yellow

# # go through each table and extract the rows 
# tables.each_with_index do |table, index|
#   rows = table.split("<tr>")[1..-1].map { |row|  # skip the first row (header)
#     row.split("<td>")[1..-1].map { |cell|  # skip the first column (header)
#       cell.split("</td>").first.strip.gsub(/<[^>]+>/, "") # remove HTML tags
#     }
#   }
#   puts "Table #{index + 1} has #{rows.size} rows.".colorize.magenta

#   # build and save the rows to CSV  to the extract_tables folder
#   file_name = "extract_tables/table_#{index + 1}.csv"
#   File.open(file_name, "w") do |file|
#     CSV.build(file) do |csv|
#       rows.each do |row|
#         csv.row(row)  # correct way to write a row to CSV in Crystal, i was using csv << row and it wasn't working for some reason
#       end
#     end
#   end
# end

# puts "Done!".colorize.green # Old Method

require "csv"
require "io"
require "colorize"
require "time"

# Start timer
start_time = Time.monotonic

# Read HTML from the renamed file
html_file = "List_revenue.html"  # Updated filename
unless File.exists?(html_file)
  puts "Error: HTML file '#{html_file}' not found.".colorize.red
  exit(1)
end

html_content = File.read(html_file)

puts "Loaded HTML content from '#{html_file}'.".colorize.green
puts "HTML content size: #{html_content.size} bytes.".colorize.blue

# Extract tables from the HTML content
tables = html_content.split("<table")[1..-1].map { |table|  
  table.split("</table>").first  
}

puts "Found #{tables.size} tables.".colorize.yellow

# Process each table and extract rows
tables.each_with_index do |table, index|
  rows = table.split("<tr>")[1..-1].map { |row|  
    row.split("<td>")[1..-1].map { |cell|  
      cell.split("</td>").first.strip.gsub(/<[^>]+>/, "") # Remove HTML tags
    }
  }
  
  puts "\nTable #{index + 1} has #{rows.size} rows.".colorize.magenta

  # Save directly in the same directory as the script
  file_name = "table_#{index + 1}.csv"
  File.open(file_name, "w") do |file|
    CSV.build(file) do |csv|
      rows.each { |row| csv.row(row) }
    end
  end

  puts "Saved #{file_name}".colorize.cyan
end

# End timer and display execution time
end_time = Time.monotonic

puts "\nDone!".colorize.green
puts "Execution time: #{(end_time - start_time).total_seconds.round(2)} seconds.".colorize.blue

