import System.Environment (getArgs)
import Text.Read (readMaybe)

main :: IO ()
main = do
    args <- getArgs
    case args of
        [name, countStr] -> processInput name countStr
        _ -> putStrLn "Usage: runhaskell Hask-project2.hs <name> <number>"

processInput :: String -> String -> IO ()
processInput name countStr
    | null (words name) = putStrLn "Error: <name> cannot be empty."
    | otherwise =
        case readMaybe countStr :: Maybe Int of
            Just count
                | count < 0  -> putStrLn "Error: <number> must be a non-negative integer."
                | count == 0 -> putStrLn "No greetings to display."
                | otherwise  -> putStrLn $ unlines (replicate count ("Hello " ++ name))
            Nothing -> putStrLn "Error: <number> must be an integer."
