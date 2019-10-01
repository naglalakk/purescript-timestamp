module Test.Main where

import Prelude

import Effect                       (Effect)
import Effect.Aff                   (launchAff_)
import Test.Spec                    (describe, it)
import Test.Spec.Assertions         (shouldEqual)
import Test.Spec.Reporter.Console   (consoleReporter)
import Test.Spec.Runner             (runSpec)

import Timestamp                    as T


main :: Effect Unit
main = do
  launchAff_ $ runSpec [consoleReporter] do
    describe "Timestamp" do
      it "formatToDateStr: should return a String in date format" do
        let format = T.formatToDateStr T.defaultTimestamp
        format `shouldEqual` "01.07.19"
      it "formatToDateTimeShortStr: should return a String in dateTimeShort format" do
        let format = T.formatToDateTimeShortStr T.defaultTimestamp
        format `shouldEqual` "01.07.2019 00:00:00"
      it "formatToDateTimeStr: should return a String in dateTimeStr format" do
        let format = T.formatToDateTimeStr T.defaultTimestamp
        format `shouldEqual` "2019-07-01T00:00:00.000Z"

