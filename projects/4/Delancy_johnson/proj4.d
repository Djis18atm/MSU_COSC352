import std.stdio;
import std.file;
import std.regex;
import std.array;
import std.path;
import std.datetime;
import std.parallelism;
import std.conv;
import std.string;

string[] getHtmlFiles(string folder = "data") {
    return dirEntries(folder, SpanMode.shallow)
        .filter!(e => e.name.endsWith(".html"))
        .map!(e => e.name)
        .array;
}

string stripTags(string html) {
    return html.replaceAll(regex("<[^>]+>"), "").strip;
}

void extractTablesFromFile(string filepath) {
    string filename = baseName(filepath);
    string content = cast(string) read(filepath);

    auto tableMatches = matchAll(content, regex(`<table.*?>.*?</table>`, "s"));
    int tableIndex = 1;

    foreach (tableMatch; tableMatches) {
        string tableHtml = tableMatch.hit;
        auto rowMatches = matchAll(tableHtml, regex(`<tr.*?>.*?</tr>`, "s"));

        string[][] tableRows;
        foreach (rowMatch; rowMatches) {
            string rowHtml = rowMatch.hit;
            auto cellMatches = matchAll(rowHtml, regex(`<t[hd].*?>.*?</t[hd]>`, "s"));

            string[] row;
            foreach (cell; cellMatches) {
                row ~= stripTags(cell.hit).replace(",", " "); 
            }
            tableRows ~= row;
        }

        string outFile = format("%s_table_%d.csv", filename[0 .. $-5], tableIndex);
        auto writer = File(outFile, "w");
        foreach (row; tableRows) {
            writer.writeln(row.join(","));
        }

        tableIndex++;
    }
}

void runSequential(string[] files) {
    writeln("Running in sequential mode...");
    auto sw = StopWatch(AutoStart.yes);

    foreach (file; files) {
        extractTablesFromFile(file);
    }

    sw.stop();
    writeln("Sequential Execution Time: ", sw.peek.total!"seconds", " seconds");
}

void runMultithreaded(string[] files) {
    writeln("Running in multithreaded mode...");
    auto sw = StopWatch(AutoStart.yes);

    auto tasks = taskPool.map!(extractTablesFromFile)(files);
    foreach (_; tasks) { } 

    sw.stop();
    writeln("Multithreaded Execution Time: ", sw.peek.total!"seconds", " seconds");
}

void main() {
    auto htmlFiles = getHtmlFiles("data");

    if (htmlFiles.length == 0) {
        writeln("No HTML files found in 'data' folder.");
        return;
    }

    runSequential(htmlFiles);
    runMultithreaded(htmlFiles);
}
