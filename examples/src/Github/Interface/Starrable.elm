-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module Github.Interface.Starrable exposing (..)

import Github.InputObject.StarOrder
import Github.Interface
import Github.Object
import Github.Scalar
import Github.Union
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (FragmentSelectionSet(FragmentSelectionSet), SelectionSet(SelectionSet))
import Json.Decode as Decode


{-| Select only common fields from the interface.
-}
commonSelection : (a -> constructor) -> SelectionSet (a -> constructor) Github.Interface.Starrable
commonSelection constructor =
    Object.selection constructor


{-| Select both common and type-specific fields from the interface.
-}
selection : (Maybe typeSpecific -> a -> constructor) -> List (FragmentSelectionSet typeSpecific Github.Interface.Starrable) -> SelectionSet (a -> constructor) Github.Interface.Starrable
selection constructor typeSpecificDecoders =
    Object.interfaceSelection typeSpecificDecoders constructor


onGist : SelectionSet selection Github.Object.Gist -> FragmentSelectionSet selection Github.Interface.Starrable
onGist (SelectionSet fields decoder) =
    FragmentSelectionSet "Gist" fields decoder


onRepository : SelectionSet selection Github.Object.Repository -> FragmentSelectionSet selection Github.Interface.Starrable
onRepository (SelectionSet fields decoder) =
    FragmentSelectionSet "Repository" fields decoder


id : FieldDecoder Github.Scalar.Id Github.Interface.Starrable
id =
    Object.fieldDecoder "id" [] (Decode.string |> Decode.map Github.Scalar.Id)


{-| A list of users who have starred this starrable.

  - first - Returns the first _n_ elements from the list.
  - after - Returns the elements in the list that come after the specified global ID.
  - last - Returns the last _n_ elements from the list.
  - before - Returns the elements in the list that come before the specified global ID.
  - orderBy - Order for connection

-}
stargazers : ({ first : OptionalArgument Int, after : OptionalArgument String, last : OptionalArgument Int, before : OptionalArgument String, orderBy : OptionalArgument Github.InputObject.StarOrder.StarOrder } -> { first : OptionalArgument Int, after : OptionalArgument String, last : OptionalArgument Int, before : OptionalArgument String, orderBy : OptionalArgument Github.InputObject.StarOrder.StarOrder }) -> SelectionSet selection Github.Object.StargazerConnection -> FieldDecoder selection Github.Interface.Starrable
stargazers fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { first = Absent, after = Absent, last = Absent, before = Absent, orderBy = Absent }

        optionalArgs =
            [ Argument.optional "first" filledInOptionals.first Encode.int, Argument.optional "after" filledInOptionals.after Encode.string, Argument.optional "last" filledInOptionals.last Encode.int, Argument.optional "before" filledInOptionals.before Encode.string, Argument.optional "orderBy" filledInOptionals.orderBy Github.InputObject.StarOrder.encode ]
                |> List.filterMap identity
    in
    Object.selectionFieldDecoder "stargazers" optionalArgs object identity


{-| Returns a boolean indicating whether the viewing user has starred this starrable.
-}
viewerHasStarred : FieldDecoder Bool Github.Interface.Starrable
viewerHasStarred =
    Object.fieldDecoder "viewerHasStarred" [] Decode.bool
