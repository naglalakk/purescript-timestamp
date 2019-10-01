{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies =
    [ "argonaut"
    , "effect"
    , "console"
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
