module MyTool.MyModule exposing
    ( increment, decrement
    , MyList(..)
    )

{-| This module provides several ways to do awesome things.


# Calculation

@docs increment, decrement


# Types

@docs MyList

-}


{-| Increment integer numbers.

    increment 1 == 2

-}
increment : Int -> Int
increment a =
    a + 1


{-| ...
-}
decrement : Int -> Int
decrement a =
    a - 1


{-| A very common data structure.
-}
type MyList a
    = Cons a (MyList a)
    | Nil
