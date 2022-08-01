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
import Settings exposing (Entry, Key, getNode, rootEntry, stepDown)


main : Program () Entry Msg
main =
    let
        dummy =
            Debug.log "dump " (getNode rootEntry [ "n" ])

        -- Debug.log "dump " (stepDown rootEntry "n")
    in
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


update : Msg -> Entry -> ( Entry, Cmd Msg )
update msg model =
    case msg of
        HandleKeyboardEvent keyboardEvent ->
            case keyboardEvent.key of
                -- case getNode model (List.singleton key) of
                Just someKey ->
                    if someKey == "Escape" then
                        ( rootEntry, Cmd.none )

                    else
                        case getNode model (List.singleton someKey) of
                            Just someEntry ->
                                ( someEntry, runShellCommand { program = "notify-send", args = [ "hello world" ] } )

                            Nothing ->
                                ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        GetMessage _ ->
            ( model, Cmd.none )


view : Entry -> Html Msg
view model =
    div [ class "text-center" ]
        [ header [ class "bg-white min-h-100vh flex flex-col items-center justify-center" ]
            [ routeView model ]
        ]


grid : List Key -> Html Msg
grid keys =
    let
        ourNode =
            getNode rootEntry keys
    in
    div []
        [ h1 [ class "mt-2em animate-bounce-alt animate-2s" ] [ text ("You are on haha page " ++ List.foldl (++) "" keys) ]
        ]
