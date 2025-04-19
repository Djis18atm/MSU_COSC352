## **Project 4: Multi-URL HTML Table Extractor with Sequential and Multithreaded Execution**

### **Objective**

Extend the functionality of your Project 3 implementation to process **multiple HTML sources** by extracting tables from each and exporting them to CSV files. The project should support two modes of operation:

1. **Sequential execution** – one file at a time.
2. **Multithreaded execution** – process multiple files concurrently.

In both cases, record and report the execution time for performance comparison.

---

### **Functional Requirements**

- **Input**: A hardcoded list of URLs or file paths to HTML documents containing tables.
- **Output**: CSV files for each extracted table.
- **Execution Modes**:
  - **Sequential Mode**: Process each file or URL one at a time.
  - **Multithreaded Mode**: Spawn threads to process multiple files or URLs concurrently.
- **Timing**: 
  - Accurately measure and display the execution time for both modes.

---

### **Implementation Notes**

- If your language does **not support downloading a URL using native libraries**, you may **manually download the HTML pages**:
  - Save the page source of each target URL.
  - Place the HTML files in your project directory.
  - Update your code to read from these local files instead of fetching via HTTP.
  - **Include the saved HTML files in your submission**.

- Use **good programming practices**:
  - **Modular design** – break logic into **clearly named, composable, and reusable functions/methods**.
  - Use **consistent and meaningful naming** for variables, functions, and classes.
  - Keep the code **extensible** – for example, both sequential and multithreaded execution paths should share core parsing and table extraction logic to avoid duplication.
  - Handle error conditions gracefully (e.g., file not found, malformed HTML, no tables present).

---

### **Example Output**

When the program runs, it should produce output like:

```sh
Sequential Execution Time: 13.24 seconds
Multithreaded Execution Time: 6.11 seconds
```

CSV files should be named to reflect the source and the table index. For example:

```
revenue_url1_table_1.csv
revenue_url1_table_2.csv
revenue_url2_table_1.csv
...
```

---

### **Directory Structure**

```
Projects/4/<firstname>_<lastname>/
├── Dockerfile
├── extract_tables.<ext>
├── README.md
├── data/
│   ├── page1.html
│   ├── page2.html
│   └── ... (if applicable)
```

---

### **Docker and Git Requirements**

- Dockerize the entire solution as in Project 3:
  - `docker build . -t project4`
  - `docker run -v $(pwd):/app project4`
- Use Git for version control:
  - Commit regularly and push your code to the assigned repository.
  - Ensure the full project structure (including downloaded HTML files, if needed) is present in the repo.

---

### **Grading Focus**

- Correct extraction of all tables into individual CSV files.
- Functional and accurate timing of both sequential and multithreaded modes.
- Clean, reusable, and well-structured code.
- Proper use of Git and Docker.
- Adherence to native-library-only restriction.