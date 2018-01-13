-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module Github.Object.StargazerEdge exposing (..)

import Github.Interface
import Github.Object
import Github.Scalar
import Github.Union
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) Github.Object.StargazerEdge
selection constructor =
    Object.selection constructor


cursor : FieldDecoder String Github.Object.StargazerEdge
cursor =
    Object.fieldDecoder "cursor" [] Decode.string


node : SelectionSet selection Github.Object.User -> FieldDecoder selection Github.Object.StargazerEdge
node object =
    Object.selectionFieldDecoder "node" [] object identity


{-| Identifies when the item was starred.
-}
starredAt : FieldDecoder Github.Scalar.DateTime Github.Object.StargazerEdge
starredAt =
    Object.fieldDecoder "starredAt" [] (Decode.string |> Decode.map Github.Scalar.DateTime)
