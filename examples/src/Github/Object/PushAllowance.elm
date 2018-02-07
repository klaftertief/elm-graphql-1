-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module Github.Object.PushAllowance exposing (..)

import Github.InputObject
import Github.Interface
import Github.Object
import Github.Scalar
import Github.Union
import Graphqelm.Field as Field exposing (Field)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) Github.Object.PushAllowance
selection constructor =
    Object.selection constructor


{-| The actor that can push.
-}
actor : SelectionSet decodesTo Github.Union.PushAllowanceActor -> Field (Maybe decodesTo) Github.Object.PushAllowance
actor object =
    Object.selectionField "actor" [] object (identity >> Decode.nullable)


id : Field Github.Scalar.Id Github.Object.PushAllowance
id =
    Object.fieldDecoder "id" [] (Decode.string |> Decode.map Github.Scalar.Id)


{-| Identifies the protected branch associated with the allowed user or team.
-}
protectedBranch : SelectionSet decodesTo Github.Object.ProtectedBranch -> Field decodesTo Github.Object.PushAllowance
protectedBranch object =
    Object.selectionField "protectedBranch" [] object identity
