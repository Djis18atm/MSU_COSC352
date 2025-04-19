# Project 4: Multi‑URL HTML Table Extractor

## Overview
This Haskell tool extracts tables from multiple HTML sources (local or remote) and outputs each table as a CSV file. It runs in two modes—sequential and multithreaded—reporting execution time for both.

## Files
- **MultiUrlTableExtractor.hs**: main program
- **Dockerfile**: builds and runs the extractor in a container
- **page.html**: downloaded Wikipedia page used as a sample

## Build & Run

### Locally (GHC installed)
```bash
ghc -threaded MultiUrlTableExtractor.hs -o extractor
./extractor +RTS -N
```

### Via Docker
```bash
docker build -t project4 .
docker run --rm project4
```

## Design Notes
- **Modular** parsing functions (`getBetween`, `extractTables`, etc.) shared by both modes
- **Exception handling** per-source ensures robustness
- **Timing** via `getCurrentTime` / `diffUTCTime`
- **Sanitization** of filenames to prevent invalid characters
