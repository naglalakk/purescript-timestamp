module Timestamp where

import Prelude

import Data.Argonaut (JsonDecodeError(..), printJsonDecodeError)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Decode.Error (JsonDecodeError)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Either (Either(..), fromRight, note)
import Data.Formatter.DateTime (Formatter, FormatterCommand(..), format)
import Data.List (fromFoldable)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.PreciseDateTime (fromRFC3339String)
import Data.PreciseDateTime as PDT
import Data.RFC3339String (RFC3339String(..))
import Effect (Effect)
import Effect.Now (nowDateTime)
import Partial.Unsafe (unsafePartial)

newtype Timestamp = Timestamp PDT.PreciseDateTime

derive instance newtypeTimestamp :: Newtype Timestamp _
derive instance eqTimestamp :: Eq Timestamp
derive instance ordTimestamp :: Ord Timestamp

instance showTimestamp :: Show Timestamp where
  show (Timestamp pdt) = show pdt

instance decodeJsonTimestamp :: DecodeJson Timestamp where
  decodeJson = fromString <=< decodeJson

instance encodeJsonTimestamp :: EncodeJson Timestamp where
  encodeJson (Timestamp pdt) = encodeJson $ formatToDateTimeStr $ Timestamp pdt

-- | Try to parse a `PreciseDateTime` from a string.
fromString :: String -> Either JsonDecodeError Timestamp
fromString str = do
  let
    tm = fromRFC3339String $ RFC3339String str
  case tm of
    Just t -> Right $ Timestamp t
    Nothing -> Left $ TypeMismatch "Failed to parse PreciseDateTime, fromRFC3339String returned Nothing"

-- | Get a current nowDateTime
-- wrapped in Timestamp
nowTimestamp :: Effect Timestamp
nowTimestamp = do
  now <- nowDateTime
  pure $ Timestamp $ PDT.fromDateTime now

-- | format: d.m.YY
dateFormatter :: Formatter
dateFormatter 
  = fromFoldable 
    [ DayOfMonthTwoDigits
    , Placeholder "."
    , MonthTwoDigits
    , Placeholder "."
    , YearTwoDigits
    ]

-- | format: YYYY-m-d:HH:MM.SS.000Z
dateTimeFormatter :: Formatter
dateTimeFormatter
  = fromFoldable
    [ YearFull
    , Placeholder "-"
    , MonthTwoDigits
    , Placeholder "-"
    , DayOfMonthTwoDigits
    , Placeholder "T"
    , Hours24
    , Placeholder ":"
    , MinutesTwoDigits
    , Placeholder ":"
    , SecondsTwoDigits
    , Placeholder "."
    , Milliseconds
    , Placeholder "Z"
    ]

-- format: d.m.YYYY HH:MM:SS
dateTimeShortFormatter :: Formatter
dateTimeShortFormatter 
  = fromFoldable
    [ DayOfMonthTwoDigits
    , Placeholder "."
    , MonthTwoDigits
    , Placeholder "."
    , YearFull
    , Placeholder " "
    , Hours24
    , Placeholder ":"
    , MinutesTwoDigits
    , Placeholder ":"
    , SecondsTwoDigits 
    ]

formatToDateStr :: Timestamp -> String
formatToDateStr (Timestamp (PDT.PreciseDateTime dt nan))
  = format dateFormatter dt

formatToDateTimeShortStr :: Timestamp -> String
formatToDateTimeShortStr (Timestamp (PDT.PreciseDateTime dt nan))
  = format dateTimeShortFormatter dt

formatToDateTimeStr :: Timestamp -> String
formatToDateTimeStr (Timestamp (PDT.PreciseDateTime dt nan))
  = format dateTimeFormatter dt
