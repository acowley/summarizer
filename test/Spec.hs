{-# LANGUAGE OverloadedLists, OverloadedStrings #-}
import Test.Hspec
import Summarizer

main :: IO ()
main = hspec $
       do describe "sentences" $ do
            it "Handles punctuation" $
              sentences "Hey. You. Guys!" `shouldBe` ["Hey", "You", "Guys"]
            it "Handles carriage returns" $
              sentences "You\r\nrock!" `shouldBe` ["You rock"]
            it "Treats line skips as sentence breaks" $
              sentences "Guten morgen\n\nSprechen Sie Deutsch?" `shouldBe`
              ["Guten morgen", "Sprechen Sie Deutsch"]
          describe "wordFreq" $ do
            it "Minimally works" $
              wordFreq mempty "uno dos tres uno!" `shouldBe`
              [("uno",2), ("dos",1), ("tres",1) ]
          describe "popularWords" $ do
            it "Can pick a winner" $
              popularWords 1 [("uno",2), ("dos",1), ("tres",1) ] `shouldBe`
              ["uno"]
          describe "pickSentences" $ do
            it "Looks for all words" $
              pickSentences 3 ["uno", "dos"] ["tres", "uno", "dos"] `shouldBe`
              ["uno", "dos"]
            it "Doesn't duplicate sentences" $ do
              pickSentences 2 ["hey", "guys"]
                              ["uno dos tres", "hey you guys"]
                `shouldBe` ["hey you guys"]
