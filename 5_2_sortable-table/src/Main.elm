module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SortableTable


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Person =
    { name : String
    , mail : String
    }


type alias Model =
    { items : List Person
    , tableState : SortableTable.State
    }


init : Model
init =
    Model
        [ { name = "Taro", mail = "taro@example.com" }
        , { name = "Hanako", mail = "hanako@example.com" }
        ]
        SortableTable.init



-- UPDATE


type Msg
    = SortableTableMsg SortableTable.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        SortableTableMsg msg_ ->
            { model | tableState = SortableTable.update msg_ model.tableState }



-- VIEW
{- 各種設定 -}


config : SortableTable.Config Person
config =
    { columns = [ "Name", "Mail" ]
    , toValue =
        \id person ->
            case id of
                "Name" ->
                    person.name

                "Mail" ->
                    person.mail

                _ ->
                    Debug.todo ("unknown column: " ++ id)
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "People" ]

        -- テーブルの表示
        , SortableTable.view config model.tableState model.items
            |> Html.map SortableTableMsg
        ]
