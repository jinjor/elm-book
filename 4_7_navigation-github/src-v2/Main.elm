module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import GitHub exposing (Issue, Repo)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Route exposing (Route)
import Url
import Url.Builder



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Page
    = NotFound
    | ErrorPage Http.Error
    | TopPage
    | UserPage (List Repo)
    | RepoPage (List Issue)


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Model key TopPage
        |> goTo (Route.parse url)



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Loaded (Result Http.Error Page)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            goTo (Route.parse url) model

        Loaded result ->
            ( { model
                | page =
                    case result of
                        Ok page ->
                            page

                        Err e ->
                            ErrorPage e
              }
            , Cmd.none
            )


goTo : Maybe Route -> Model -> ( Model, Cmd Msg )
goTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Top ->
            ( { model | page = TopPage }, Cmd.none )

        Just (Route.User userName) ->
            ( model
            , GitHub.getRepos
                (Result.map UserPage >> Loaded)
                userName
            )

        Just (Route.Repo userName projectName) ->
            ( model
            , GitHub.getIssues
                (Result.map RepoPage >> Loaded)
                userName
                projectName
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "My GitHub Viewer"
    , body =
        [ a [ href "/" ] [ h1 [] [ text "My GitHub Viewer" ] ]
        , case model.page of
            NotFound ->
                viewNotFound

            ErrorPage error ->
                viewError error

            TopPage ->
                viewTopPage

            UserPage repos ->
                viewUserPage repos

            RepoPage issues ->
                viewRepoPage issues
        ]
    }


viewNotFound : Html msg
viewNotFound =
    text "not found"


viewError : Http.Error -> Html msg
viewError error =
    case error of
        Http.BadBody message ->
            pre [] [ text message ]

        _ ->
            text (Debug.toString error)


viewTopPage : Html msg
viewTopPage =
    ul []
        [ viewLink (Url.Builder.absolute [ "elm" ] [])
        , viewLink (Url.Builder.absolute [ "evancz" ] [])
        ]


viewUserPage : List Repo -> Html msg
viewUserPage repos =
    ul []
        (repos
            |> List.map
                (\repo ->
                    viewLink (Url.Builder.absolute [ repo.owner, repo.name ] [])
                )
        )


viewRepoPage : List Issue -> Html msg
viewRepoPage issues =
    ul [] (List.map viewIssue issues)


viewIssue : Issue -> Html msg
viewIssue issue =
    li []
        [ span [] [ text ("[" ++ issue.state ++ "]") ]
        , span [] [ text ("#" ++ String.fromInt issue.number) ]
        , span [] [ text issue.title ]
        ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
