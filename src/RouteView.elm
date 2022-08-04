module RouteView exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (class)
import Msg exposing (Msg(..))
import Settings exposing (Entry(..), Property(..), getProperty)


mkEntry : Entry -> Html Msg
mkEntry entry =
    div [ class "p-2 m-2 w-64 rounded flex" ]
        [ div [ class "bg-gray-200 w-6 rounded mr-2" ] [ text (getProperty entry Key) ]
        , text (getProperty entry Description)
        ]


routeView : Entry -> Html Msg
routeView entry =
    div [ class "grid grid-cols-3 m-2" ]
        (case entry of
            RouteEntry { children } ->
                List.map mkEntry children

            CommandEntry _ ->
                []
        )
