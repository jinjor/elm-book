module Route exposing (Route(..), parse)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = Top
    | User String
    | Repo String String


parse : Url -> Maybe Route
parse url =
    Url.Parser.parse parser url


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Top top
        , map User string
        , map Repo (string </> string)
        ]
