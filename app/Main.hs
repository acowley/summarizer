{-# LANGUAGE OverloadedStrings, ViewPatterns #-}
module Main where
import Data.Text (Text)
import Data.Text.Read (decimal)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Summarizer (wordFreq, sentences, pickSentences, popularWords)
import Summarizer.StopWords (englishStopWords)
import System.Environment (getArgs)
import Text.Read (readMaybe)

parseInput :: Text -> (Int, Text)
parseInput t = either (const (10, t)) id (decimal t)

main :: IO ()
main = do args <- getArgs
          case args of
            [] -> T.interact $ \t -> let (n,t') = parseInput t in go n t'
            [readMaybe -> Just n] -> T.interact (go n)
            _ -> putStrLn "Usage: summarize [maxSentences]\nInput is read from stdin."
  where go n t = let popWords = popularWords 100 (wordFreq englishStopWords t)
                 in T.intercalate ".\n\n" $
                    pickSentences n popWords (sentences t)
