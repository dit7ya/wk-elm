port module Ports exposing (..)


type alias ShellCommand =
    { program : String, args : List String }


port runShellCommand : ShellCommand -> Cmd msg


port addMessage : (String -> msg) -> Sub msg
