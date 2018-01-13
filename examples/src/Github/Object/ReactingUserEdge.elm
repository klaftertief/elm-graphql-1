-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module Github.Object.ReactingUserEdge exposing (..)

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
selection : (a -> constructor) -> SelectionSet (a -> constructor) Github.Object.ReactingUserEdge
selection constructor =
    Object.selection constructor


cursor : FieldDecoder String Github.Object.ReactingUserEdge
cursor =
    Object.fieldDecoder "cursor" [] Decode.string


node : SelectionSet selection Github.Object.User -> FieldDecoder selection Github.Object.ReactingUserEdge
node object =
    Object.selectionFieldDecoder "node" [] object identity


{-| The moment when the user made the reaction.
-}
reactedAt : FieldDecoder Github.Scalar.DateTime Github.Object.ReactingUserEdge
reactedAt =
    Object.fieldDecoder "reactedAt" [] (Decode.string |> Decode.map Github.Scalar.DateTime)
