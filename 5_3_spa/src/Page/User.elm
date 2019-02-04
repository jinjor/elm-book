module Page.User exposing (Model, Msg, init, update, view)

import GitHub exposing (Issue, Repo)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Url.Builder



-- MODEL


type alias Model =
    { state : State }


type State
    = Init
    | Loaded (List Repo)
    | Error Http.Error


init : String -> ( Model, Cmd Msg )
init userName =
    ( Model Init
    , GitHub.getRepos
        GotRepos
        userName
    )



-- UPDATE


type Msg
    = GotRepos (Result Http.Error (List Repo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotRepos (Ok repos) ->
            ( { model | state = Loaded repos }, Cmd.none )

        GotRepos (Err err) ->
            ( { model | state = Error err }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    case model.state of
        Init ->
            text "Loading..."

        Loaded repos ->
            ul []
                (repos
                    |> List.map
                        (\repo ->
                            viewLink (Url.Builder.absolute [ repo.owner, repo.name ] [])
                        )
                )

        Error e ->
            text (Debug.toString e)


viewLink : String -> Html Msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
