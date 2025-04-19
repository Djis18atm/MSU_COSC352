<?hh

<<__EntryPoint>>
function main(): void {
    $url = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue";
    $html_file = "/tmp/company_list.html";

    // Step 1: Download HTML file using `wget`
    $download_cmd = "wget -q -O $html_file $url";
    exec($download_cmd, $output, $status);
    
    if ($status !== 0) {
        echo "Error downloading page.\n";
        return;
    }
    echo "HTML file downloaded successfully.\n";

    // Step 2: Read HTML content
    $html_content = file_get_contents($html_file);
    if ($html_content === false) {
        echo "Error reading the HTML file.\n";
        return;
    }

    // Step 3: Extract tables from the HTML
    $tables = extract_tables($html_content);

    // Step 4: Write each table to a separate CSV file
    $table_index = 1;
    foreach ($tables as $table) {
        $csv_file = __DIR__ . "/table_$table_index.csv";
        file_put_contents($csv_file, convert_to_csv($table));
        echo "Saved table $table_index to $csv_file\n";
        $table_index++;
    }

    echo "Extraction complete.\n";
}

/**
 * Extracts all tables from HTML content.
 */
function extract_tables(string $html): vec<string> {
    $tables = vec[];
    $start_pos = 0;

    while (($start_pos = strpos($html, "<table", $start_pos)) !== false) {
        $end_pos = strpos($html, "</table>", $start_pos);
        if ($end_pos === false) {
            break;
        }

        $table_html = substr($html, $start_pos, $end_pos - $start_pos + 8);
        $tables[] = $table_html;
        $start_pos = $end_pos + 8;
    }

    return $tables;
}

/**
 * Converts an HTML table to a simple CSV format.
 */
function convert_to_csv(string $table_html): string {
    $csv_data = "";
    
    // Extract rows
    $rows = explode("<tr", $table_html);
    foreach ($rows as $row) {
        $cols = explode("<td", $row);
        if (count($cols) > 1) {
            $row_values = vec[];
            foreach ($cols as $col) {
                $col_start = strpos($col, ">") + 1;
                $col_end = strpos($col, "</td>");
                if ($col_start !== false && $col_end !== false) {
                    $value = trim(strip_tags(substr($col, $col_start, $col_end - $col_start)));
                    $row_values[] = "\"$value\"";
                }
            }
            if (!empty($row_values)) {
                $csv_data .= implode(",", $row_values) . "\n";
            }
        }
    }

    return $csv_data;
}

/**
 * Strips HTML tags from a string.
 */
function strip_tags(string $html): string {
    return preg_replace('/<[^>]*>/', '', $html);
}
