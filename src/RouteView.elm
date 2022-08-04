module RouteView exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (class)
import Msg exposing (Msg(..))
import Settings exposing (Entry(..), Property(..), getProperty)


makeButton : Entry -> Html Msg
makeButton entry =
    button [ class "p-2 m-2 w-48 text-blue-800" ] [ text (getProperty entry Key ++ " " ++ getProperty entry Description) ]


routeView : Entry -> Html Msg
routeView entry =
    div
        [ class "border rounded" ]
        [ p []
            (case entry of
                RouteEntry { children } ->
                    List.map makeButton children

                CommandEntry _ ->
                    []
            )
        ]
