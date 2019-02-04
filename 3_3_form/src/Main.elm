module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { input : String
    , memos : List String
    }


init : Model
init =
    { input = ""
    , memos = []
    }



-- UPDATE


type Msg
    = Input String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input input ->
            { model | input = input }

        Submit ->
            { model
                | input = ""
                , memos = model.input :: model.memos
            }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit Submit ]
            [ input [ onInput Input, value model.input ] []
            , button
                [ disabled (String.isEmpty (String.trim model.input)) ]
                [ text "Submit" ]
            ]
        , ul [] (List.map viewMemo model.memos)
        ]


viewMemo : String -> Html Msg
viewMemo memo =
    li [] [ text memo ]
