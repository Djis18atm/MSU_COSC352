using System;
using System.IO;
using System.Linq;
using System.Text;
using HtmlAgilityPack;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        string filePath = "downloaded_page.html";
        if (!File.Exists(filePath))
        {
            Console.WriteLine("Error: HTML file not found.");
            return;
        }

        string htmlContent = File.ReadAllText(filePath);
        ExtractTablesToCsv(htmlContent);
    }

    static void ExtractTablesToCsv(string htmlContent)
    {
        var htmlDoc = new HtmlDocument();
        htmlDoc.LoadHtml(htmlContent);

        var tables = htmlDoc.DocumentNode.SelectNodes("//table");
        if (tables == null || tables.Count == 0)
        {
            Console.WriteLine("No tables found in the HTML file.");
            return;
        }

        int tableIndex = 1;
        foreach (var table in tables)
        {
            string csvContent = ConvertTableToCsv(table);
            string fileName = $"table_{tableIndex}.csv";
            File.WriteAllText(fileName, csvContent, Encoding.UTF8);
            Console.WriteLine($"Table {tableIndex} saved as {fileName}");
            tableIndex++;
        }
    }

    static string ConvertTableToCsv(HtmlNode table)
    {
        var sb = new StringBuilder();
        foreach (var row in table.SelectNodes(".//tr"))
        {
            var cells = row.SelectNodes(".//th|.//td");
            if (cells != null)
            {
                var values = cells.Select(cell => '"' + cell.InnerText.Trim().Replace("\"", "\"\"") + '"');
                sb.AppendLine(string.Join(",", values));
            }
        }
        return sb.ToString();
    }
}
