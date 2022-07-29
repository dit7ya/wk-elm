module Main exposing (main)

-- import HelloWorld exposing (helloWorld)

import Browser
import Html exposing (Html, a, button, code, div, h1, header, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Msg exposing (Msg(..))
import RouteView exposing (routeView)
import Settings exposing (Entry, Key, getNode, rootEntry, stepDown)


main : Program () Entry Msg
main =
    let
        dummy =
            Debug.log "dump " (getNode rootEntry [ "n" ])

        -- Debug.log "dump " (stepDown rootEntry "n")
    in
    Browser.sandbox { init = initialModel, update = update, view = view }


initialModel : Entry
initialModel =
    rootEntry


update : Msg -> Entry -> Entry
update (KeyPressed key) model =
    case getNode model (List.singleton key) of
        Just someEntry ->
            someEntry

        Nothing ->
            model


view : Entry -> Html Msg
view model =
    div [ class "text-center" ]
        [ header [ class "bg-white min-h-100vh flex flex-col items-center justify-center" ]
            [ div [ class "logo" ] []
            , routeView model
            ]
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
