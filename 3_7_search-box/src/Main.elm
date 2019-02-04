module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D exposing (Decoder)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { input : String
    , userState : UserState
    }


type UserState
    = Init
    | Waiting
    | Loaded User
    | Failed Http.Error


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" Init
    , Cmd.none
    )



-- UPDATE


type Msg
    = Input String
    | Send
    | Receive (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input newInput ->
            ( { model | input = newInput }, Cmd.none )

        Send ->
            ( { model
                | input = ""
                , userState = Waiting
              }
            , Http.get
                { url = "https://api.github.com/users/" ++ model.input
                , expect = Http.expectJson Receive userDecoder
                }
            )

        Receive (Ok user) ->
            ( { model | userState = Loaded user }, Cmd.none )

        Receive (Err e) ->
            ( { model | userState = Failed e }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit Send ]
            [ input
                [ onInput Input
                , autofocus True
                , placeholder "GitHub name"
                , value model.input
                ]
                []
            , button
                [ disabled
                    ((model.userState == Waiting)
                        || String.isEmpty (String.trim model.input)
                    )
                ]
                [ text "Submit" ]
            ]
        , case model.userState of
            Init ->
                text ""

            Waiting ->
                text "Waiting..."

            Loaded user ->
                a
                    [ href user.htmlUrl
                    , target "_blank"
                    ]
                    [ img [ src user.avatarUrl, width 200 ] []
                    , div [] [ text user.name ]
                    , div []
                        [ case user.bio of
                            Just bio ->
                                text bio

                            Nothing ->
                                text ""
                        ]
                    ]

            Failed e ->
                div [] [ text (Debug.toString e) ]
        ]



-- DATA


type alias User =
    { login : String
    , avatarUrl : String
    , name : String
    , htmlUrl : String
    , bio : Maybe String
    }


userDecoder : Decoder User
userDecoder =
    D.map5 User
        (D.field "login" D.string)
        (D.field "avatar_url" D.string)
        (D.field "name" D.string)
        (D.field "html_url" D.string)
        (D.maybe (D.field "bio" D.string))
