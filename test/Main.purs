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
main = pure unit
