module Main exposing (main)

-- import HelloWorld exposing (helloWorld)

import Browser
import Browser.Events exposing (onKeyDown)
import Html exposing (Html, a, button, code, div, h1, header, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Json.Decode
import Keyboard.Event exposing (decodeKeyboardEvent)
import Msg exposing (Msg(..))
import Ports exposing (addMessage, runShellCommand)
import RouteView exposing (routeView)
import Settings exposing (Entry(..), Key, Property(..), getNode, getProperty, getShellCommand, rootEntry, stepDown)


main : Program () Entry Msg
main =
    Browser.element { init = initialModel, update = update, view = view, subscriptions = subscriptions }


initialModel : () -> ( Entry, Cmd Msg )
initialModel _ =
    ( rootEntry, Cmd.none )


subscriptions : Entry -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onKeyDown (Json.Decode.map HandleKeyboardEvent decodeKeyboardEvent)
        , addMessage GetMessage
        ]


{-| Get all command entry children of the current RouteEntry
-}
getCommandEntries : Entry -> List Entry
getCommandEntries entry =
    case entry of
        CommandEntry _ ->
            []

        RouteEntry { children } ->
            let
                filteredChild =
                    List.filter
                        (\child ->
                            case child of
                                RouteEntry _ ->
                                    False

                                CommandEntry _ ->
                                    True
                        )
                        children
            in
            filteredChild


isCommandKey : String -> Entry -> Bool
isCommandKey key model =
    List.member key (getCommandEntries model |> List.map (\x -> getProperty x Key))


update : Msg -> Entry -> ( Entry, Cmd Msg )
update msg model =
    case msg of
        HandleKeyboardEvent keyboardEvent ->
            case keyboardEvent.key of
                -- case getNode model (List.singleton key) of
                Just someKey ->
                    if someKey == "Escape" then
                        ( rootEntry, Cmd.none )

                    else if isCommandKey someKey model then
                        case getShellCommand model someKey of
                            Just someCommand ->
                                ( model, runShellCommand { program = someCommand.program, args = someCommand.args } )

                            Nothing ->
                                ( model, Cmd.none )

                    else
                        case getNode model (List.singleton someKey) of
                            Just someEntry ->
                                ( someEntry, Cmd.none )

                            Nothing ->
                                ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        GetMessage _ ->
            ( model, Cmd.none )

        RunShellCommand shellCommand ->
            ( model, runShellCommand { program = shellCommand.program, args = shellCommand.args } )


view : Entry -> Html Msg
view model =
    div [ class "text-center" ]
        [ header [ class "bg-white min-h-100vh flex flex-col items-center justify-center" ]
            [ routeView model ]
        ]



-- grid : List Key -> Html Msg
-- grid keys =
--     let
--         ourNode =
--             getNode rootEntry keys
--     in
--     div []
--         [ h1 [ class "mt-2em animate-bounce-alt animate-2s" ] [ text ("You are on haha page " ++ List.foldl (++) "" keys) ]
--         ]
