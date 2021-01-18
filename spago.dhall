{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "timestamp"
, dependencies =
    [ "argonaut"
    , "effect"
    , "console"
    , "halogen"
    , "halogen-formless"
    , "formatters"
    , "precise-datetime"
    , "psci-support"
    , "spec"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
