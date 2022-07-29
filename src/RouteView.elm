module RouteView exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Settings exposing (Entry(..), Property(..), getProperty)


makeButton : Entry -> Html Msg
makeButton entry =
    button [ onClick (KeyPressed (getProperty entry Key)) ] [ text (getProperty entry Description) ]


routeView : Entry -> Html Msg
routeView entry =
    div []
        [ p []
            (case entry of
                RouteEntry { children } ->
                    List.map makeButton children

                CommandEntry _ ->
                    []
            )
        ]
