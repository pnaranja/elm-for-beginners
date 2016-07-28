module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import String


-- Model
type alias Model = {calories:Int,inp:Int}

initModel : Model
initModel = {calories=0, inp=0}

-- Update
-- What things can change?
-- How should the Model change?

type Msg = Input String | AddCalorie | Clear

update : Msg -> Model -> Model
update msg model =
    case msg of
    Input val -> 
        case String.toInt val of
            Ok input -> {model | inp = input}
            Err err -> {model | inp = 0}

    AddCalorie -> {model | calories = model.calories + model.inp, inp=0} -- Set back the input field to 0 after update?

    Clear -> initModel

-- View
-- What should the page look like given the current Model?

view : Model -> Html Msg
view model = div [] [h3 [] [text ("Total Calories: " ++ (toString model.calories))]
                            ,input [type' "text"
                                    , onInput Input
                                    , value (if model.inp == 0 then ""
                                            else (toString model.inp))] []
                            ,button [type' "button", onClick AddCalorie] [text "Add"]
                            ,button [type' "button", onClick Clear] [text "Clear"]
                    ]

main = App.beginnerProgram {model=initModel, update=update, view=view}
