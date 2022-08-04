module Msg exposing (Msg(..))

import Keyboard.Event exposing (KeyboardEvent)
import Settings exposing (Key, ShellCommand)


type Msg
    = HandleKeyboardEvent KeyboardEvent
    | GetMessage String
    | RunShellCommand ShellCommand
