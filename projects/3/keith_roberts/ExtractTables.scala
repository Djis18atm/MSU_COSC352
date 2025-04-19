import java.net.http.{HttpClient, HttpRequest, HttpResponse}
import java.net.URI
import java.io.FileWriter
import scala.util.matching.Regex

object ExtractTables {
  def main(args: Array[String]): Unit = {
    // URL of the webpage to extract the tables from
    val url = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue" // Replace with the actual URL containing tables

    try {
      // Use Java's HttpClient to fetch the HTML content
      val client = HttpClient.newHttpClient()
      val request = HttpRequest.newBuilder().uri(URI.create(url)).build()

      val response = client.send(request, HttpResponse.BodyHandlers.ofString())
      val htmlContent = response.body()

      // Extract all table HTML elements using regex
      val tableRegex: Regex = "(?s)<table.*?>(.*?)</table>".r
      val tableMatches = tableRegex.findAllMatchIn(htmlContent).toList

      if (tableMatches.nonEmpty) {
        var tableIndex = 1 // Index to name separate CSV files

        // Process each table found in the HTML
        for (tableMatch <- tableMatches) {
          val tableContent = tableMatch.group(1) // Content inside the <table> tag

          // Extract rows (<tr>) and cells (<td> or <th>) using regex
          val rowRegex: Regex = "(?s)<tr.*?>(.*?)</tr>".r
          val cellRegex: Regex = "(?s)<t[dh].*?>(.*?)</t[dh]>".r

          // Generate a unique filename for the current table
          val csvFileName = f"table_$tableIndex.csv"

          // Open a FileWriter to save the current table's CSV
          val csvWriter = new FileWriter(csvFileName)

          for (rowMatch <- rowRegex.findAllMatchIn(tableContent)) {
            val row = rowMatch.group(1) // Content inside the <tr> tag

            // Collect and escape all cells
            val cells = cellRegex
              .findAllMatchIn(row)
              .map(_.group(1).replaceAll("<.*?>", "").trim) // Clean HTML tags
              .map(cell => escapeForCSV(cell)) // Escape cell values for CSV
              .toList

            // Write the row data to the CSV file
            val rowData = cells.mkString(",")
            csvWriter.write(rowData + "\n")
          }

          // Close the writer for the current table
          csvWriter.close()
          println(s"Table $tableIndex successfully extracted and saved as $csvFileName.")
          tableIndex += 1 // Increment the table index for the next table
        }
      } else {
        println("No tables found in the specified webpage.")
      }
    } catch {
      case e: Exception =>
        e.printStackTrace()
        println("An error occurred while extracting the tables.")
    }
  }

  // Escapes CSV values by wrapping them in double quotes and escaping any inner quotes
  def escapeForCSV(value: String): String = {
    val escapedValue = value.replace("\"", "\"\"") // Double any quotes in the value
    s""""$escapedValue"""" // Wrap the value with double quotes
  }
}
