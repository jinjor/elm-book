module SortableTable exposing (Config, Msg, State, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias State =
    { sortedColumn : Maybe String
    , reversed : Bool
    }


init : State
init =
    State Nothing False


type Msg
    = Sort String


update : Msg -> State -> State
update msg state =
    case msg of
        Sort column ->
            if state.sortedColumn == Just column then
                { state | reversed = not state.reversed }

            else
                { state | sortedColumn = Just column, reversed = False }


type alias Config a =
    { columns : List String
    , toValue : String -> a -> String
    }


view : Config a -> State -> List a -> Html Msg
view config state items =
    table []
        [ thead [] [ headerRow config state ]
        , tbody [] (List.map (bodyRow config) (sort config state items))
        ]


sort : Config a -> State -> List a -> List a
sort config state items =
    case state.sortedColumn of
        Just column ->
            List.sortBy (config.toValue column) items
                |> (if state.reversed then
                        List.reverse

                    else
                        identity
                   )

        Nothing ->
            items


headerRow : Config a -> State -> Html Msg
headerRow config state =
    tr [] (List.map (headerCell config state) config.columns)


bodyRow : Config a -> a -> Html msg
bodyRow config item =
    tr [] (List.map (bodyCell config item) config.columns)


headerCell : Config a -> State -> String -> Html Msg
headerCell config state columnId =
    let
        label =
            columnId
                ++ (case ( state.sortedColumn == Just columnId, state.reversed ) of
                        ( True, False ) ->
                            "(↓)"

                        ( True, True ) ->
                            "(↑)"

                        _ ->
                            ""
                   )
    in
    th [ onClick (Sort columnId) ] [ text label ]


bodyCell : Config a -> a -> String -> Html msg
bodyCell config item columnId =
    td [] [ text (config.toValue columnId item) ]
