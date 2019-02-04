module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


main : Html msg
main =
    div [] [ headline, content ]


headline : Html msg
headline =
    h1 [] [ text "Useful Links" ]


content : Html msg
content =
    ul []
        [ linkItem "https://elm-lang.org" "Homepage"
        , linkItem "https://package.elm-lang.org" "Packages"
        , linkItem "https://ellie-app.com/" "Playground"
        ]


linkItem : String -> String -> Html msg
linkItem url str =
    li [] [ a [ href url ] [ text str ] ]
