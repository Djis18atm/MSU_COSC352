import Data.Time.Clock       (getCurrentTime, diffUTCTime)
import Control.Concurrent     (forkIO, newEmptyMVar, putMVar, takeMVar)
import Control.Exception      (catch, SomeException)
import Control.Monad          (forM_)
import Data.List              (isPrefixOf, tails, findIndex, intercalate)
import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Simple    (httpLBS, getResponseBody, parseRequest_)

sources :: [String]
sources =
  [ "page.html"  
  , "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"
  ]

main :: IO ()
main = do
  putStrLn "[1] Sequential execution"
  runSequential sources
  putStrLn "\n[2] Multithreaded execution"
  runConcurrent sources

runSequential :: [String] -> IO ()
runSequential srcs = do
  start <- getCurrentTime
  mapM_ processSafe srcs
  end   <- getCurrentTime
  putStrLn $ "Sequential time: " ++ show (diffUTCTime end start)

runConcurrent :: [String] -> IO ()
runConcurrent srcs = do
  start <- getCurrentTime
  mvars  <- mapM (\src -> do
                    mv <- newEmptyMVar
                    _  <- forkIO $ processSafe src >> putMVar mv ()
                    return mv) srcs
  mapM_ takeMVar mvars
  end <- getCurrentTime
  putStrLn $ "Multithreaded time: " ++ show (diffUTCTime end start)

processSafe :: String -> IO ()
processSafe src = catch (processSource src)
                        (\e -> putStrLn $ "Error on " ++ src ++ ": " ++ show (e :: SomeException))

processSource :: String -> IO ()
processSource src
  | "http://"  `isPrefixOf` src
 || "https://" `isPrefixOf` src = fetchHtml src >>= saveTables src
  | otherwise                    = readFile src >>= saveTables src

fetchHtml :: String -> IO String
fetchHtml url = do
  resp <- httpLBS (parseRequest_ url)
  return $ L8.unpack (getResponseBody resp)

saveTables :: String -> String -> IO ()
saveTables src html =
  forM_ (zip [1..] $ extractTables html) $ \(i, tableRows) -> do
    let csv     = unlines $ map (intercalate ",") tableRows
        outFile = sanitize src ++ "_table" ++ show i ++ ".csv"
    writeFile outFile csv
    putStrLn $ "Wrote: " ++ outFile

sanitize :: String -> String
sanitize = map (\c -> if c `elem` "/:?&=% .\"" then '_' else c)

extractTables :: String -> [[[String]]]
extractTables s = map extractRows $ getBetween "table" s

extractRows :: String -> [[String]]
extractRows s = map extractCells $ getBetween "tr" s

extractCells :: String -> [String]
extractCells s = map stripTags $ getBetween "th" s ++ getBetween "td" s

getBetween :: String -> String -> [String]
getBetween tag str = case findOpen str of
    Nothing     -> []
    Just rest   -> let (inner, after) = splitClose rest
                   in inner : getBetween tag after
  where
    openT   = '<':tag
    closeT  = "</" ++ tag ++ ">"

    findOpen xs = do
      idx <- findIndex (isPrefixOf openT) (tails xs)
      let dropped = drop (idx + length openT) xs
      case findIndex (=='>') dropped of
        Just k  -> Just (drop (k+1) dropped)
        Nothing -> Just dropped

    splitClose ys = case findIndex (isPrefixOf closeT) (tails ys) of
      Just k  -> (take k ys, drop (k + length closeT) ys)
      Nothing -> (ys, "")

stripTags :: String -> String
stripTags []       = []
stripTags ('<':xs) = stripTags $ drop 1 $ dropWhile (/='>') xs
stripTags (c:cs)   = c : stripTags cs
