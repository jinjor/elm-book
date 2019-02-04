module GitHub exposing (Issue, Repo, getIssues, getRepos)

import Http
import Json.Decode as D exposing (Decoder)
import Url
import Url.Builder


type alias Repo =
    { name : String
    , description : Maybe String
    , language : Maybe String
    , owner : String
    , fork : Int
    , star : Int
    , watch : Int
    }


type alias Issue =
    { number : Int
    , title : String
    , state : String
    }


reposDecoder : Decoder (List Repo)
reposDecoder =
    D.list repoDecoder


repoDecoder : Decoder Repo
repoDecoder =
    D.map7 Repo
        (D.field "name" D.string)
        (D.maybe (D.field "description" D.string))
        (D.maybe (D.field "language" D.string))
        (D.at [ "owner", "login" ] D.string)
        (D.field "forks_count" D.int)
        (D.field "stargazers_count" D.int)
        (D.field "watchers_count" D.int)


issuesDecoder : Decoder (List Issue)
issuesDecoder =
    D.list issueDecoder


issueDecoder : Decoder Issue
issueDecoder =
    D.map3 Issue
        (D.field "number" D.int)
        (D.field "title" D.string)
        (D.field "state" D.string)


getRepos : (Result Http.Error (List Repo) -> msg) -> String -> Cmd msg
getRepos toMsg userName =
    Http.get
        { url =
            Url.Builder.crossOrigin "https://api.github.com"
                [ "users", userName, "repos" ]
                []
        , expect =
            Http.expectJson toMsg reposDecoder
        }


getIssues : (Result Http.Error (List Issue) -> msg) -> String -> String -> Cmd msg
getIssues toMsg userName projectName =
    Http.get
        { url =
            Url.Builder.crossOrigin "https://api.github.com"
                [ "repos", userName, projectName, "issues" ]
                []
        , expect =
            Http.expectJson toMsg issuesDecoder
        }
