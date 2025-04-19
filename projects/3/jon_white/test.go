package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func classifyLine(line string) string {
	trimmed := strings.TrimSpace(line)
	switch {
	case strings.HasPrefix(trimmed, "<table") || strings.HasPrefix(trimmed, "</table"):
		return "table"
	case strings.HasPrefix(trimmed, "<tr") || strings.HasPrefix(trimmed, "</tr"):
		return "row"
	default:
		return "other"
	}
}

func main() {
	// Open the HTML file
	file, err := os.Open("test.html")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	lineNum := 1
	for scanner.Scan() {
		line := scanner.Text()
		class := classifyLine(line)
		fmt.Printf("Line %d: [%s] => %s\n", lineNum, class, line)
		lineNum++
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading file:", err)
	}
}
