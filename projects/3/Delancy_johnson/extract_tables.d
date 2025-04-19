module Dcode.extract_tables;

import std.stdio;
import std.net.curl;
import std.string;
import std.file;
import std.regex;
import std.array;
import std.algorithm; 


string stripHtml(string input) {
    auto tagPattern = regex("<[^>]+>");
    return replaceAll(input, tagPattern, ""); 
}


string downloadHtml(string url) {
    string html;
    try {   
        auto data = get(url);
        html = cast(string) data;
    } catch (Exception e) {
        writeln("Error downloading HTML: ", e.msg);
        return "";
    }
    return html;
}

string[] extractTables(string html) {
    auto tablePattern = regex(`<table[^>]*class="[^"]*wikitable[^"]*"[^>]*>.*?</table>`, "s");
    auto matches = matchAll(html, tablePattern);
    return matches.map!(m => m.hit).array; 
}

string parseTable(string tableHtml) {
    string result;
    auto rowPattern = regex(`<tr[^>]*>.*?</tr>`, "s");
    foreach (row; matchAll(tableHtml, rowPattern)) {
        string[] cells;

        foreach (th; matchAll(row.hit, regex(`<th[^>]*>(.*?)</th>`, "s")))
            cells ~= stripHtml(th.captures[1]).replace(",", " "); // Clean header

        foreach (td; matchAll(row.hit, regex(`<td[^>]*>(.*?)</td>`, "s")))
            cells ~= stripHtml(td.captures[1]).replace(",", " "); // Clean cell

        if (!cells.empty)
            result ~= cells.join(",") ~ "\n";
    }
    return result;
}

void main() {
    string url = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue";
    string html = downloadHtml(url);
    if (html.length == 0) return;

    auto tables = extractTables(html);

    if (tables.length == 0) {
        writeln("No tables found.");
        return;
    }

    int count = 0;
    foreach (table; tables) {
        count++;
        string csvData = parseTable(table);
        string fileName = format("table_%d.csv", count);
        std.file.write(fileName, csvData);
        writeln("Saved: ", fileName);
    }

    writeln("Extracted ", count, " table(s).");
}
