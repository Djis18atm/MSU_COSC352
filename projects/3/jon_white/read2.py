import urllib.request
import os
import csv
from html.parser import HTMLParser

class TableParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.in_table = False
        self.in_row = False
        self.in_cell = False
        self.tables = []
        self.current_table = []
        self.current_row = []
        self.current_cell = ""

    def handle_starttag(self, tag, attrs):
        if tag == "table":
            self.in_table = True
            self.current_table = []
        elif tag == "tr" and self.in_table:
            self.in_row = True
            self.current_row = []
        elif tag in ("td", "th") and self.in_row:
            self.in_cell = True
            self.current_cell = ""

    def handle_endtag(self, tag):
        if tag == "table" and self.in_table:
            self.in_table = False
            self.tables.append(self.current_table)
        elif tag == "tr" and self.in_row:
            self.in_row = False
            self.current_table.append(self.current_row)
        elif tag in ("td", "th") and self.in_cell:
            self.in_cell = False
            self.current_row.append(self.current_cell.strip())

    def handle_data(self, data):
        if self.in_cell:
            self.current_cell += data.strip() + " "

# # Step 1: Download the HTML page
url = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"
html_file = "page.html"

urllib.request.urlretrieve(url, html_file)

#html_file = "list_of_largest_companies_wiki.html"
# Step 2: Parse the HTML page
with open(html_file, "r", encoding="utf-8") as file:
    html_content = file.read()

parser = TableParser()
parser.feed(html_content)

# Step 3: Write tables to CSV files
if not os.path.exists("tables"):  # Store tables in a separate directory
    os.makedirs("tables")

for i, table in enumerate(parser.tables, start=1):
    csv_filename = os.path.join("tables", f"table_{i}.csv")
    with open(csv_filename, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(table)

print(f"Extracted {len(parser.tables)} tables into CSV files.")
