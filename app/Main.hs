{-# LANGUAGE OverloadedStrings #-}
module Main where
import Data.Text (Text)
import Data.Text.Read (decimal)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Summarizer (wordFreq, sentences, pickSentences, popularWords)
import Summarizer.StopWords (englishStopWords)

parseInput :: Text -> (Int, Text)
parseInput t = either (const (10, t)) id (decimal t)

main :: IO ()
main = T.interact $ \t ->
       let (n,t') = parseInput t
           popWords = popularWords 100 (wordFreq englishStopWords t')
       in T.intercalate ".\n\n" $ pickSentences n popWords (sentences t')
