{-# LANGUAGE BangPatterns, OverloadedStrings #-}
-- | Simple automatic text summarization as described
-- <http://stackoverflow.com/questions/2829303/given-a-document-select-a-relevant-snippet
-- here>
module Summarizer where
import Data.Char (isAlpha)
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as HM
import Data.HashSet (HashSet)
import qualified Data.HashSet as S
import qualified Data.IntSet as IS
import Data.List (foldl', sortOn)
import qualified Data.Map.Strict as M
import Data.Ord (Down(..))
import Data.Text (Text)
import qualified Data.Text as T
import Data.Vector (Vector, (!))
import qualified Data.Vector as V

-- | Break a 'Text' into sentences.
sentences :: Text -> Vector Text
sentences = V.fromList
          . filter (not . T.null)
          . map simpleSpaces
          . foldMap (T.splitOn "\n\n")
          . T.split (`elem` ['.','?','!'])
          . T.filter (/= '\r')
  where simpleSpaces = T.intercalate " " . T.words

wordRoot :: Text -> Text
wordRoot = T.toLower . T.takeWhile isAlpha

-- | Compute the frequency of every word in the input 'Text' not in
-- the "stop words" set.
wordFreq :: HashSet Text -> Text -> HashMap Text Int
wordFreq stopWords = foldl' go mempty
                   . filter (not . flip S.member stopWords)
                   . filter (not . T.null)
                   . map wordRoot
                   . T.words
  where go m w = HM.insertWith (+) w 1 m

-- | Build a set of the @n@ most common words.
popularWords :: Int -> HashMap Text Int -> [Text]
popularWords n = take n . map fst . sortOn (Down . snd) . HM.toList

-- | @pickSentences maxSentences popularWords allSentences@ picks the
-- first sentence containing each popular word up to a total of
-- @maxSentences@.
pickSentences :: Int -> [Text] -> Vector Text -> [Text]
pickSentences n popWords ss = map snd. M.toAscList $ go 0 mempty mempty popWords
  where go _ _ !output [] = output
        go !m !outputSet !output (w:ws)
          | m == n = output
          | otherwise =
            let f !i
                  | i == V.length ss = go m outputSet output ws
                  | S.member w (ss' ! i) && not (IS.member i outputSet) =
                    go (m+1)
                       (IS.insert i outputSet)
                       (M.insert i (ss ! i) output)
                       ws
                  | otherwise = f (i+1)
            in f 0
        ss' = V.map (S.fromList . map wordRoot . T.words) ss
