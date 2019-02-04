module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import GitHub exposing (Issue, Repo)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page.Repo
import Page.Top
import Page.User
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
    | TopPage Page.Top.Model
    | UserPage Page.User.Model
    | RepoPage Page.Repo.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Model key (TopPage Page.Top.init)
        |> goTo (Route.parse url)



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | TopMsg Page.Top.Msg
    | RepoMsg Page.Repo.Msg
    | UserMsg Page.User.Msg


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

        TopMsg topMsg ->
            case model.page of
                TopPage topModel ->
                    let
                        ( newTopModel, topCmd ) =
                            Page.Top.update topMsg topModel
                    in
                    ( { model | page = TopPage newTopModel }
                    , Cmd.map TopMsg topCmd
                    )

                _ ->
                    ( model, Cmd.none )

        RepoMsg repoMsg ->
            case model.page of
                RepoPage repoModel ->
                    let
                        ( newRepoModel, topCmd ) =
                            Page.Repo.update repoMsg repoModel
                    in
                    ( { model | page = RepoPage newRepoModel }
                    , Cmd.map RepoMsg topCmd
                    )

                _ ->
                    ( model, Cmd.none )

        UserMsg userMsg ->
            case model.page of
                UserPage userModel ->
                    let
                        ( newUserModel, topCmd ) =
                            Page.User.update userMsg userModel
                    in
                    ( { model | page = UserPage newUserModel }
                    , Cmd.map UserMsg topCmd
                    )

                _ ->
                    ( model, Cmd.none )


goTo : Maybe Route -> Model -> ( Model, Cmd Msg )
goTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Top ->
            ( { model | page = TopPage Page.Top.init }
            , Cmd.none
            )

        Just (Route.User userName) ->
            let
                ( userModel, userCmd ) =
                    Page.User.init userName
            in
            ( { model | page = UserPage userModel }
            , Cmd.map UserMsg userCmd
            )

        Just (Route.Repo userName projectName) ->
            let
                ( repoModel, repoCmd ) =
                    Page.Repo.init userName projectName
            in
            ( { model | page = RepoPage repoModel }
            , Cmd.map RepoMsg repoCmd
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

            TopPage topPageModel ->
                Page.Top.view topPageModel
                    |> Html.map TopMsg

            UserPage userPageModel ->
                Page.User.view userPageModel
                    |> Html.map UserMsg

            RepoPage repoPageModel ->
                Page.Repo.view repoPageModel
                    |> Html.map RepoMsg
        ]
    }


viewNotFound : Html msg
viewNotFound =
    text "not found"
