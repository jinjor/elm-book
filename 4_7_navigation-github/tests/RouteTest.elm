module RouteTest exposing (suite)

import Expect exposing (..)
import Fuzz exposing (..)
import Route exposing (Route)
import Test exposing (..)
import Url


testParse : String -> String -> Maybe Route -> Test
testParse name path expectedRoute =
    test name <|
        \_ ->
            Url.fromString ("http://example.com" ++ path)
                |> Maybe.andThen Route.parse
                |> Expect.equal expectedRoute


suite : Test
suite =
    describe "Route"
        [ testParse "should parse Top" "/" (Just Route.Top)
        , testParse "should parse Top with queries" "/?dummy=value" (Just Route.Top)
        , testParse "should parse Top with hash" "/#dummy" (Just Route.Top)
        , testParse "should parse User" "/foo" (Just (Route.User "foo"))
        , testParse "should parse Repo" "/foo/bar" (Just (Route.Repo "foo" "bar"))
        , testParse "should parse invalid path" "/foo/bar/baz" Nothing
        ]
