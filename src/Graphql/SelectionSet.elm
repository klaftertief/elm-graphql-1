module Graphql.SelectionSet exposing
    ( with, hardcoded, empty, map, succeed, withDefault
    , map2, map3, map4, map5, map6, map7, map8
    , SelectionSet(..), FragmentSelectionSet(..)
    , mapOrFail, nonNullOrFail, nonNullElementsOrFail
    )

{-| The auto-generated code from the `@dillonkearns/elm-graphql` CLI will provide `selection`
functions for Objects, Interfaces, and Unions in your GraphQL schema.
These functions build up a `Graphql.SelectionSet` which describes a set
of fields to retrieve. The `SelectionSet` is built up in a pipeline similar to how
[`Json.Decode.Pipeline`](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest)
builds up decoders.

For example, if you had a top-level query `human(id: ID!)` which returns an object
of type `Human`, you could build the following GraphQL query document:

    query {
      human(id: 1001) {
        name
        id
      }
    }

In this example, the `SelectionSet` on `human` is:

    {
      name
      id
    }

You could build up the above `SelectionSet` with the following `dillonkearns/elm-graphql` code:

    import Api.Object
    import Api.Object.Human as Human
    import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)

    type alias Human =
        { name : String
        , id : String
        }

    hero : SelectionSet Hero Api.Interface.Human
    hero =
        SelectionSet.succeed Human
            |> with Human.name
            |> with Human.id

Note that all of the modules under `Api.` in this case are generated by running
the `@dillonkearns/elm-graphql` command line tool.

The query itself is also a `SelectionSet` so it is built up similarly.
See [this live code demo](https://rebrand.ly/graphqelm) for an example.

@docs with, hardcoded, empty, map, succeed, withDefault


## Combining

If you run out of `mapN` functions for building up `SelectionSet`s,
you can use the pipeline
which makes it easier to handle large objects, but produces
lower quality type errors.

@docs map2, map3, map4, map5, map6, map7, map8


## Types

These types are built for you by the code generated by the `@dillonkearns/elm-graphql` command line tool.

@docs SelectionSet, FragmentSelectionSet


## Result (`...OrFail`) Transformations

**Warning** When you use these functions, you lose the guarantee that the
server response will decode successfully.

These helpers, though convenient, will cause your entire decoder to fail if
it ever maps to an `Err` instead of an `Ok` `Result`.

@docs mapOrFail, nonNullOrFail, nonNullElementsOrFail

-}

import Graphql.Document.Field
import Graphql.RawField as RawField exposing (RawField)
import Json.Decode as Decode exposing (Decoder)
import List.Extra


{-| SelectionSet type
-}
type SelectionSet decodesTo typeLock
    = SelectionSet (List RawField) (Decoder decodesTo)


{-| Maps the data coming back from the GraphQL endpoint. In this example,
`User.name` is a function that the `@dillonkearns/elm-graphql` CLI tool created which tells us
that the `name` field on a `User` object is a String according to your GraphQL
schema.

    import Api.Object
    import Api.Object.User as User
    import Graphql.SelectionSet exposing (SelectionSet, with)

    human : SelectionSet String Api.Object.User
    human =
        User.name |> SelectionSet.map String.toUpper

You can also map to values of a different type (`String -> Int`, for example), see
[`examples/StarWars.elm`](https://github.com/dillonkearns/elm-graphql/blob/master/examples/src/Starwars.elm) for more advanced example.

-}
map : (a -> b) -> SelectionSet a typeLock -> SelectionSet b typeLock
map mapFunction (SelectionSet selectionFields selectionDecoder) =
    SelectionSet selectionFields (Decode.map mapFunction selectionDecoder)


{-| A helper for mapping a SelectionSet to provide a default value.
-}
withDefault : a -> SelectionSet (Maybe a) typeLock -> SelectionSet a typeLock
withDefault default =
    map (Maybe.withDefault default)


{-| Combine two `SelectionSet`s into one, using the given combine function to
merge the two data sets together.
-}
map2 :
    (decodesTo1 -> decodesTo2 -> decodesToCombined)
    -> SelectionSet decodesTo1 typeLock
    -> SelectionSet decodesTo2 typeLock
    -> SelectionSet decodesToCombined typeLock
map2 combine (SelectionSet selectionFields1 selectionDecoder1) (SelectionSet selectionFields2 selectionDecoder2) =
    SelectionSet
        (selectionFields1 ++ selectionFields2)
        (Decode.map2 combine selectionDecoder1 selectionDecoder2)


{-| Combine three `SelectionSet`s into one, using the given combine function to
merge the two data sets together. This gives more clear error messages than the
pipeline syntax (using `SelectionSet.succeed` to start the pipeline
and `SelectionSet.with` to continue it).

    import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
    import Swapi.Interface
    import Swapi.Interface.Character as Character

    type alias Character =
        { name : String
        , id : Swapi.Scalar.Id
        , friends : List String
        }

    thing : SelectionSet Character Swapi.Interface.Character
    thing =
        SelectionSet.map3 MyCharacter
            Character.name
            Character.id
            (Character.friends Character.name)

-}
map3 :
    (decodesTo1 -> decodesTo2 -> decodesTo3 -> decodesToCombined)
    -> SelectionSet decodesTo1 typeLock
    -> SelectionSet decodesTo2 typeLock
    -> SelectionSet decodesTo3 typeLock
    -> SelectionSet decodesToCombined typeLock
map3 combine (SelectionSet selectionFields1 selectionDecoder1) (SelectionSet selectionFields2 selectionDecoder2) (SelectionSet selectionFields3 selectionDecoder3) =
    SelectionSet
        (List.concat [ selectionFields1, selectionFields2, selectionFields3 ])
        (Decode.map3 combine selectionDecoder1 selectionDecoder2 selectionDecoder3)


{-| -}
map4 :
    (decodesTo1 -> decodesTo2 -> decodesTo3 -> decodesTo4 -> decodesToCombined)
    -> SelectionSet decodesTo1 typeLock
    -> SelectionSet decodesTo2 typeLock
    -> SelectionSet decodesTo3 typeLock
    -> SelectionSet decodesTo4 typeLock
    -> SelectionSet decodesToCombined typeLock
map4 combine (SelectionSet selectionFields1 selectionDecoder1) (SelectionSet selectionFields2 selectionDecoder2) (SelectionSet selectionFields3 selectionDecoder3) (SelectionSet selectionFields4 selectionDecoder4) =
    SelectionSet
        (List.concat [ selectionFields1, selectionFields2, selectionFields3, selectionFields4 ])
        (Decode.map4 combine selectionDecoder1 selectionDecoder2 selectionDecoder3 selectionDecoder4)


{-| -}
map5 :
    (decodesTo1 -> decodesTo2 -> decodesTo3 -> decodesTo4 -> decodesTo5 -> decodesToCombined)
    -> SelectionSet decodesTo1 typeLock
    -> SelectionSet decodesTo2 typeLock
    -> SelectionSet decodesTo3 typeLock
    -> SelectionSet decodesTo4 typeLock
    -> SelectionSet decodesTo5 typeLock
    -> SelectionSet decodesToCombined typeLock
map5 combine (SelectionSet selectionFields1 selectionDecoder1) (SelectionSet selectionFields2 selectionDecoder2) (SelectionSet selectionFields3 selectionDecoder3) (SelectionSet selectionFields4 selectionDecoder4) (SelectionSet selectionFields5 selectionDecoder5) =
    SelectionSet
        (List.concat [ selectionFields1, selectionFields2, selectionFields3, selectionFields4, selectionFields5 ])
        (Decode.map5 combine selectionDecoder1 selectionDecoder2 selectionDecoder3 selectionDecoder4 selectionDecoder5)


{-| -}
map6 :
    (decodesTo1 -> decodesTo2 -> decodesTo3 -> decodesTo4 -> decodesTo5 -> decodesTo6 -> decodesToCombined)
    -> SelectionSet decodesTo1 typeLock
    -> SelectionSet decodesTo2 typeLock
    -> SelectionSet decodesTo3 typeLock
    -> SelectionSet decodesTo4 typeLock
    -> SelectionSet decodesTo5 typeLock
    -> SelectionSet decodesTo6 typeLock
    -> SelectionSet decodesToCombined typeLock
map6 combine (SelectionSet selectionFields1 selectionDecoder1) (SelectionSet selectionFields2 selectionDecoder2) (SelectionSet selectionFields3 selectionDecoder3) (SelectionSet selectionFields4 selectionDecoder4) (SelectionSet selectionFields5 selectionDecoder5) (SelectionSet selectionFields6 selectionDecoder6) =
    SelectionSet
        (List.concat [ selectionFields1, selectionFields2, selectionFields3, selectionFields4, selectionFields5, selectionFields6 ])
        (Decode.map6 combine selectionDecoder1 selectionDecoder2 selectionDecoder3 selectionDecoder4 selectionDecoder5 selectionDecoder6)


{-| -}
map7 :
    (decodesTo1 -> decodesTo2 -> decodesTo3 -> decodesTo4 -> decodesTo5 -> decodesTo6 -> decodesTo7 -> decodesToCombined)
    -> SelectionSet decodesTo1 typeLock
    -> SelectionSet decodesTo2 typeLock
    -> SelectionSet decodesTo3 typeLock
    -> SelectionSet decodesTo4 typeLock
    -> SelectionSet decodesTo5 typeLock
    -> SelectionSet decodesTo6 typeLock
    -> SelectionSet decodesTo7 typeLock
    -> SelectionSet decodesToCombined typeLock
map7 combine (SelectionSet selectionFields1 selectionDecoder1) (SelectionSet selectionFields2 selectionDecoder2) (SelectionSet selectionFields3 selectionDecoder3) (SelectionSet selectionFields4 selectionDecoder4) (SelectionSet selectionFields5 selectionDecoder5) (SelectionSet selectionFields6 selectionDecoder6) (SelectionSet selectionFields7 selectionDecoder7) =
    SelectionSet
        (List.concat [ selectionFields1, selectionFields2, selectionFields3, selectionFields4, selectionFields5, selectionFields6, selectionFields7 ])
        (Decode.map7 combine selectionDecoder1 selectionDecoder2 selectionDecoder3 selectionDecoder4 selectionDecoder5 selectionDecoder6 selectionDecoder7)


{-| -}
map8 :
    (decodesTo1 -> decodesTo2 -> decodesTo3 -> decodesTo4 -> decodesTo5 -> decodesTo6 -> decodesTo7 -> decodesTo8 -> decodesToCombined)
    -> SelectionSet decodesTo1 typeLock
    -> SelectionSet decodesTo2 typeLock
    -> SelectionSet decodesTo3 typeLock
    -> SelectionSet decodesTo4 typeLock
    -> SelectionSet decodesTo5 typeLock
    -> SelectionSet decodesTo6 typeLock
    -> SelectionSet decodesTo7 typeLock
    -> SelectionSet decodesTo8 typeLock
    -> SelectionSet decodesToCombined typeLock
map8 combine (SelectionSet selectionFields1 selectionDecoder1) (SelectionSet selectionFields2 selectionDecoder2) (SelectionSet selectionFields3 selectionDecoder3) (SelectionSet selectionFields4 selectionDecoder4) (SelectionSet selectionFields5 selectionDecoder5) (SelectionSet selectionFields6 selectionDecoder6) (SelectionSet selectionFields7 selectionDecoder7) (SelectionSet selectionFields8 selectionDecoder8) =
    SelectionSet
        (List.concat [ selectionFields1, selectionFields2, selectionFields3, selectionFields4, selectionFields5, selectionFields6, selectionFields7, selectionFields8 ])
        (Decode.map8 combine selectionDecoder1 selectionDecoder2 selectionDecoder3 selectionDecoder4 selectionDecoder5 selectionDecoder6 selectionDecoder7 selectionDecoder8)


{-| Useful for Mutations when you don't want any data back.

    import Api.Mutation as Mutation
    import Graphql.Operation exposing (RootMutation)
    import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)

    sendChatMessage : String -> SelectionSet () RootMutation
    sendChatMessage message =
        Mutation.sendMessage { message = message } SelectionSet.empty

-}
empty : SelectionSet () typeLock
empty =
    SelectionSet [] (Decode.succeed ())


{-| FragmentSelectionSet type
-}
type FragmentSelectionSet decodesTo typeLock
    = FragmentSelectionSet String (List RawField) (Decoder decodesTo)



{- TODO add this documentation to `with`
   Used to pick out fields on an object.

      import Api.Enum.Episode as Episode exposing (Episode)
      import Api.Object
      import Api.Scalar
      import Graphql.SelectionSet exposing (SelectionSet, with)

      type alias Hero =
          { name : String
          , id : Api.Scalar.Id
          , appearsIn : List Episode
          }

      hero : SelectionSet Hero Api.Interface.Character
      hero =
          Character.commonSelection Hero
              |> with Character.name
              |> with Character.id
              |> with Character.appearsIn

-}


{-| Include a `SelectionSet` within a `SelectionSet`. This is the equivalent of
including a [GraphQL fragment](https://graphql.org/learn/queries/#fragments) in
plain GraphQL queries. This is a handy tool for modularizing your GraphQL queries.

([You can try the below query for yourself by pasting the query into the Github query explorer](https://developer.github.com/v4/explorer/)).

Let's say we want to query Github's GraphQL API like this:

    {
      repository(owner: "dillonkearns", name: "elm-graphql") {
        nameWithOwner
        ...timestamps
        stargazers(first: 0) { totalCount }
      }
    }

    fragment timestamps on Repository {
      createdAt
      updatedAt
    }

We could do the equivalent of the `timestamps` fragment with the `timestampsFragment`
we define below.

    import Github.Object
    import Github.Object.Repository as Repository
    import Github.Object.StargazerConnection
    import Graphql.Operation exposing (RootQuery)
    import Graphql.OptionalArgument exposing (OptionalArgument(..))
    import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
    import Iso8601
    import Time exposing (Posix)

    type alias Repo =
        { nameWithOwner : String
        , timestamps : Timestamps
        , stargazersCount : Int
        }

    type alias Timestamps =
        { createdAt : Posix
        , updatedAt : Posix
        }

    repositorySelection : SelectionSet Repo Github.Object.Repository
    repositorySelection =
        SelectionSet.succeed Repo
            |> with Repository.nameWithOwner
            |> withFragment timestampsFragment
            |> with stargazersCount

    timestampsFragment : SelectionSet Timestamps Github.Object.Repository
    timestampsFragment =
        SelectionSet.succeed Timestamps
            |> with (Repository.createdAt |> mapToDateTime)
            |> with (Repository.updatedAt |> mapToDateTime)

    mapToDateTime : Field Github.Scalar.DateTime typeLock -> Field Posix typeLock
    mapToDateTime =
        Field.mapOrFail
            (\(Github.Scalar.DateTime value) ->
                Iso8601.toTime value
                    |> Result.mapError (\_ -> "Failed to parse " ++ value ++ " as Iso8601 DateTime.")
            )

    stargazersCount : Field Int Github.Object.Repository
    stargazersCount =
        Repository.stargazers
            (\optionals -> { optionals | first = Present 0 })
            (fieldSelection Github.Object.StargazerConnection.totalCount)

Notice that we are using two different techniques for abstraction here.
We use `|> withFragment timestampsFragment` to include a fragment and we use
`|> with stargazersCount`. What's the difference? For the `timestampsFragment`,
we want to pull in some fields at the same level of the `SelectionSet` we are
building up. But for the `stargazersCount`, we are simply extracting a `Field`
which builds up a nested `SelectionSet` that grabs the `totalCount` within the
`stargazers` `Field`.

-}
with : SelectionSet a typeLock -> SelectionSet (a -> b) typeLock -> SelectionSet b typeLock
with (SelectionSet selectionFields1 selectionDecoder1) (SelectionSet selectionFields2 selectionDecoder2) =
    SelectionSet (selectionFields1 ++ selectionFields2)
        (Decode.map2 (|>)
            selectionDecoder1
            selectionDecoder2
        )


{-| Include a hardcoded value.

        import Api.Enum.Episode as Episode exposing (Episode)
        import Api.Object
        import Graphql.SelectionSet exposing (SelectionSet, with, hardcoded)

        type alias Hero =
            { name : String
            , movie : String
            }

        hero : SelectionSet Hero Api.Interface.Character
        hero =
            Character.commonSelection Hero
                |> with Character.name
                |> hardcoded "Star Wars"

-}
hardcoded : a -> SelectionSet (a -> b) typeLock -> SelectionSet b typeLock
hardcoded constant (SelectionSet objectFields objectDecoder) =
    SelectionSet objectFields
        (Decode.map2 (|>)
            (Decode.succeed constant)
            objectDecoder
        )


{-| Instead of hardcoding a field like `hardcoded`, `SelectionSet.succeed` hardcodes
an entire `SelectionSet`. This can be useful if you want hardcoded data based on
only the type when using a polymorphic type (Interface or Union).

    import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
    import Swapi.Interface
    import Swapi.Interface.Character as Character

    type alias Character =
        { typename : HumanOrDroid
        , name : String
        }

    type HumanOrDroid
        = Human
        | Droid

    hero : SelectionSet Character Swapi.Interface.Character
    hero =
        SelectionSet.succeed Character
            |> with heroType
            |> with Character.name

    heroType : SelectionSet HumanOrDroid Swapi.Interface.Character
    heroType =
        Character.fragments
            { onHuman = SelectionSet.succeed Human
            , onDroid = SelectionSet.succeed Droid
            }

-}
succeed : a -> SelectionSet a typeLock
succeed constructor =
    SelectionSet [] (Decode.succeed constructor)


{-| If the map function provided returns an `Ok` `Result`, it will map to that value.
If it returns an `Err`, the _entire_ response will fail to decode.

    import Time exposing (Posix)
    import Github.Object
    import Github.Object.Repository
    import Github.Scalar
    -- NOTE: Iso8601 comes from an external dependency in Elm >= 0.19:
    -- https://package.elm-lang.org/packages/rtfeldman/elm-iso8601-date-strings/latest/
    import Iso8601
    import Graphql.SelectionSet as SelectionSet exposing (with)

    type alias Timestamps =
    { created : Posix
    , updated : Posix
    }


    timestampsSelection : SelectionSet Timestamps Github.Object.Repository
    timestampsSelection =
        SelectionSet.succeed Timestamps
            |> with (Repository.createdAt |> mapToDateTime)
            |> with (Repository.updatedAt |> mapToDateTime)


    mapToDateTime : Field Github.Scalar.DateTime typeLock -> Field Posix typeLock
    mapToDateTime =
        Field.mapOrFail
            (\(Github.Scalar.DateTime value) ->
                Iso8601.toTime value
                    |> Result.mapError (\_ -> "Failed to parse " ++ value ++ " as Iso8601 DateTime.")

-}
mapOrFail : (decodesTo -> Result String mapsTo) -> SelectionSet decodesTo typeLock -> SelectionSet mapsTo typeLock
mapOrFail mapFunction (SelectionSet field decoder) =
    decoder
        |> Decode.map mapFunction
        |> Decode.andThen
            (\result ->
                case result of
                    Ok value ->
                        Decode.succeed value

                    Err errorMessage ->
                        Decode.fail ("Check your code for calls to mapOrFail, your map function returned an `Err` with the message: " ++ errorMessage)
            )
        |> SelectionSet field


{-| Effectively turns an attribute that is `String` => `String!`, or `User` =>
`User!` (if you're not familiar with the GraphQL type language notation, learn more
[here](http://graphql.org/learn/schema/#type-language)).

This will cause your _entire_ decoder to fail if the field comes back as null.
It's far better to fix your schema then to use this escape hatch!

-}
nonNullOrFail : SelectionSet (Maybe decodesTo) typeLock -> SelectionSet decodesTo typeLock
nonNullOrFail (SelectionSet fields decoder) =
    decoder
        |> Decode.andThen
            (\result ->
                case result of
                    Just value ->
                        Decode.succeed value

                    Nothing ->
                        Decode.fail "Expected non-null but got null, check for calls to nonNullOrFail in your code. Ideally your schema should indicate that this is non-nullable so you don't need to use nonNullOrFail at all."
            )
        |> SelectionSet fields


{-| Effectively turns a field that is `[String]` => `[String!]`, or `[User]` =>
`[User!]` (if you're not familiar with the GraphQL type language notation, learn more
[here](http://graphql.org/learn/schema/#type-language)).

This will cause your _entire_ decoder to fail if any elements in the list for this
field comes back as null.
It's far better to fix your schema then to use this escape hatch!

Often GraphQL schemas will contain things like `[String]` (i.e. a nullable list
of nullable strings) when they really mean `[String!]!` (a non-nullable list of
non-nullable strings). You can chain together these nullable helpers if for some
reason you can't go in and fix this in the schema, for example:

    releases : SelectionSet (List Release) Github.Object.ReleaseConnection
    releases =
        Github.Object.ReleaseConnection.nodes release
            |> Field.nonNullOrFail
            |> Field.nonNullElementsOrFail

Without the `Field.nonNull...` transformations here, the type would be
`SelectionSet (Maybe (List (Maybe Release))) Github.Object.ReleaseConnection`.

-}
nonNullElementsOrFail : SelectionSet (List (Maybe decodesTo)) typeLock -> SelectionSet (List decodesTo) typeLock
nonNullElementsOrFail (SelectionSet fields decoder) =
    decoder
        |> Decode.andThen
            (\result ->
                case combineMaybeList result of
                    Nothing ->
                        Decode.fail "Expected only non-null list elements but found a null. Check for calls to nonNullElementsOrFail in your code. Ideally your schema should indicate that this is non-nullable so you don't need to use nonNullElementsOrFail at all."

                    Just listWithoutNulls ->
                        Decode.succeed listWithoutNulls
            )
        |> SelectionSet fields


combineMaybeList : List (Maybe a) -> Maybe (List a)
combineMaybeList listOfMaybes =
    let
        step maybeElement accumulator =
            case maybeElement of
                Nothing ->
                    Nothing

                Just element ->
                    Maybe.map ((::) element) accumulator
    in
    List.foldr step (Just []) listOfMaybes
