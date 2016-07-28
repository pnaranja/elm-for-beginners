module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- Model
type alias Model = Int

initModel : Model
initModel = 0

-- Update
-- What things can change?
-- How should the Model change?

type Msg = AddCalorie | Clear

update : Msg -> Model -> Model
update msg model =
    case msg of
    AddCalorie -> model + 1
    Clear -> 0

-- View
-- What should the page look like given the current Model?

-- view :: Model -> Html Msg
-- view = div [] [text "Total Calories"]