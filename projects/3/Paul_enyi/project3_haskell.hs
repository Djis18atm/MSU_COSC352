import System.IO
import System.Directory (createDirectoryIfMissing)
import System.FilePath ((</>))
import Data.List (isPrefixOf, isSuffixOf)

extractTables :: String -> [String]
extractTables content = extractTableSections (lines content)
  where
    extractTableSections [] = []
    extractTableSections (x:xs)
      | "<table" `isPrefixOf` x = let (table, rest) = break (isSuffixOf "</table>") xs
                                  in unlines (x : table ++ ["</table>"]) : extractTableSections rest
      | otherwise = extractTableSections xs

writeTablesToCSV :: [String] -> IO ()
writeTablesToCSV tables = do
    createDirectoryIfMissing True "tables"
    mapM_ (\(i, table) -> writeFile ("tables" </> "table_" ++ show i ++ ".csv") table) (zip [1..] tables)

main :: IO ()
main = do
    html <- readFile "page.html"
    let tables = extractTables html
    writeTablesToCSV tables
    putStrLn $ "Extracted " ++ show (length tables) ++ " tables into CSV files."
