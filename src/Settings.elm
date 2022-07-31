module Settings exposing (..)

import Html exposing (node)
import Html.Attributes exposing (property)


type alias ShellCommand =
    String


type alias Key =
    String


type Entry
    = CommandEntry
        { command : ShellCommand
        , description : String
        , key : Key
        }
    | RouteEntry
        { description : String
        , key : Key
        , children : List Entry
        }


type Property
    = Description
    | Key


getProperty : Entry -> Property -> String
getProperty entry property =
    case entry of
        RouteEntry { description, key } ->
            if property == Description then
                description

            else
                key

        CommandEntry { description, key } ->
            if property == Description then
                description

            else
                key


rootEntry : Entry
rootEntry =
    RouteEntry
        { description = "Root Entry"
        , key = "SPC"
        , children =
            [ RouteEntry
                { description = "Send Notifications"
                , key = "n"
                , children =
                    [ CommandEntry
                        { command = "notify-send Hello World"
                        , key = "h"
                        , description = "Say hello world."
                        }
                    , CommandEntry
                        { command = "notify-send Cool, isn't it? "
                        , key = "c"
                        , description = "Say something cool."
                        }
                    ]
                }
            , RouteEntry
                { description = "Control Brightness"
                , key = "b"
                , children =
                    [ CommandEntry
                        { command = "light -A 1"
                        , key = "i"
                        , description = "Increase by 1%"
                        }
                    , CommandEntry
                        { command = "light -U 1"
                        , key = "d"
                        , description = "Decrease by 1%"
                        }
                    ]
                }
            ]
        }



-- Get a node after the keystrokes from a root node


keyExists : Entry -> Key -> Bool
keyExists entry keyToFind =
    case entry of
        CommandEntry { key } ->
            key == keyToFind

        RouteEntry { key } ->
            key == keyToFind


stepDown : Entry -> Key -> Maybe Entry
stepDown node keyToFind =
    case node of
        CommandEntry _ ->
            Nothing

        RouteEntry { children } ->
            let
                filteredChild =
                    List.filter (\child -> keyExists child keyToFind) children
            in
            filteredChild |> List.head


{-| Get a node by walking the tree following `keys`
-}
getNode : Entry -> List Key -> Maybe Entry
getNode node keys =
    List.head keys
        |> Maybe.andThen (stepDown node)
        |> Maybe.andThen
            (\aNode ->
                List.tail keys
                    |> Maybe.andThen
                        (\x ->
                            if List.isEmpty x then
                                Just aNode

                            else
                                getNode aNode x
                        )
            )
