module Graphqelm.Parser.Scalar exposing (..)


type Scalar
    = Boolean
    | ID
    | String
    | Int
    | Float
    | Custom { name : String }


parse : String -> Scalar
parse scalarName =
    case scalarName of
        "String" ->
            String

        "Boolean" ->
            Boolean

        "ID" ->
            ID

        _ ->
            Custom { name = scalarName }



-- Debug.crash "Unhandled"
