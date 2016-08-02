module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import String


--MODEL


type Mode a
    = EditPlayer a
    | AddPlayer


type alias PlayerId =
    Int


type alias Model =
    { players : List Player
    , name : String
    , mode : Mode PlayerId
    , plays : List Play
    }


type alias Player =
    { id : Int
    , name : String
    , totalpoints : Int
    }


type alias Play =
    { id : Int
    , playerId : PlayerId
    , name : Int
    , points : Int
    }


initModel : Model
initModel =
    { players = []
    , name = ""
    , mode = AddPlayer
    , plays = []
    }



--UPDATE


type Pts
    = Int


type Msg
    = Edit Player
    | Score Player Pts
    | Input String
    | Save
    | Cancel
    | Delete Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            { model | name = name }

        Cancel ->
            { model | name = "", mode = AddPlayer }

        Save ->
            if (String.isEmpty model.name) then
                model
            else
                saveModel model

        Edit player ->
            { model | mode = EditPlayer 0 }

        _ ->
            model


saveModel : Model -> Model
saveModel model =
    case model.mode of
        AddPlayer ->
            { model
                | players = (Player (List.length model.players) model.name 0) :: model.players
                , name = ""
            }

        EditPlayer a ->
            { model | name = "", mode = AddPlayer }



-- To edit a player, you need to change the Player.name and Play.name


changePlayerNameModel : Player -> Model -> Model
changePlayerNameModel newplayer model =
    { model | players = List.map (changePlayerName newplayer.name) model.players }


changePlayerName : String -> Player -> Player
changePlayerName newname player =
    if player.name == newname then
        { player | name = newname }
    else
        player



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "ScoreKeeper" ]
        , playerForm model
        , div [] [ text (toString model) ]
        ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ input
            [ type' "text"
            , placeholder "Add/Edit Player"
            , onInput Input
            , value model.name
            ]
            []
        , button [ type' "submit" ] [ text "Save" ]
        , button [ type' "button", onClick Cancel ] [ text "Cancel" ]
          -- For debugging EditPlayer
        , button
            [ type' "button"
            , onClick (Edit { id = 1, name = "", totalpoints = 1 })
            ]
            [ text "Edit" ]
        ]


main : Program Never
main =
    App.beginnerProgram { model = initModel, update = update, view = view }
