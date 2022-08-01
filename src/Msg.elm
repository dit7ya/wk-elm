module Msg exposing (Msg(..))

import Keyboard.Event exposing (KeyboardEvent)
import Settings exposing (Key)


type Msg
    = HandleKeyboardEvent KeyboardEvent
    | GetMessage String
