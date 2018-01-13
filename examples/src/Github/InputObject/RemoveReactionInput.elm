-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module Github.InputObject.RemoveReactionInput exposing (..)

import Github.Enum.ReactionContent
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


{-| Encode a RemoveReactionInput into a value that can be used as an argument.
-}
encode : RemoveReactionInput -> Value
encode input =
    Encode.maybeObject
        [ ( "clientMutationId", Encode.string |> Encode.optional input.clientMutationId ), ( "subjectId", (\(Github.Scalar.Id raw) -> Encode.string raw) input.subjectId |> Just ), ( "content", Encode.enum Github.Enum.ReactionContent.toString input.content |> Just ) ]


{-| Type for the RemoveReactionInput input object.
-}
type alias RemoveReactionInput =
    { clientMutationId : OptionalArgument String, subjectId : Github.Scalar.Id, content : Github.Enum.ReactionContent.ReactionContent }
