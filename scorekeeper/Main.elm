module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import String


--MODEL


type Mode id
    = EditPlayer id
    | AddPlayer


type alias Id =
    Int


type alias Points =
    Int


type alias Model =
    { players : List Player
    , name : String
    , mode : Mode Id
    , plays : List Play
    }


type alias Player =
    { id : Id
    , name : String
    , totalpoints : Points
    }


type alias Play =
    { id : Id
    , playerId : Id
    , name : String
    , points : Points
    }


initModel : Model
initModel =
    { players = []
    , name = ""
    , mode = AddPlayer
    , plays = []
    }



--UPDATE


type Msg
    = Edit Id
    | Score Player Points
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

        Edit id ->
            { model | mode = EditPlayer id }

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

        EditPlayer id ->
            changeNameModel id model



-- To edit a player, you need to change the Player.name and Play.name


changeNameModel : Id -> Model -> Model
changeNameModel id model =
    { model
        | players = List.map (changePlayerName id model.name) model.players
        , plays = List.map (changePlayName id model.name) model.plays
        , name = ""
        , mode = AddPlayer
    }


changePlayerName : Id -> String -> Player -> Player
changePlayerName id newname player =
    if player.id == id then
        { player | name = newname }
    else
        player


changePlayName : Id -> String -> Play -> Play
changePlayName id newname play =
    if play.id == id then
        { play | name = newname }
    else
        play



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "ScoreKeeper" ]
        , playerSection model
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
            , onClick (Edit 1)
            ]
            [ text "Edit" ]
        ]

-- Return a div with 3 sections
playerSection : Model -> Html Msg
playerSection model =
    div []
    [ playerListHeader
    , playerList model
    , pointTotal model
    ]

playerListHeader : Html Msg
playerListHeader =
    header []
    [ div [] [text "Name"]
    , div [] [text "Points"]
    ]

-- ul tag with li tag for each player
playerList : Model -> Html Msg
playerList model =
    ul []
     (List.map playerListRow model.players)

-- Create a Player List row for the PlayerList
-- Needs to show:
 --  icon to edit, the player name, 2/3pts buttons, and the total points
playerListRow : Player -> Html Msg
playerListRow player =
    li []
    [ i [class "edit"
        , onClick (Edit player.id)
        ] []
     , div []
        [text player.name]
     , button [type' "button"
                , onClick (Score player 2)]
        [text "2pts"]
     , button [type' "button"
                , onClick (Score player 3)]
        [text "3pts"]
     , div []
        [text <| toString player.totalpoints]
    ]

-- Show total points of all the players
pointTotal : Model -> Html Msg
pointTotal model =
    let totalpts =
        List.sum <| List.map (\player -> player.totalpoints) model.players
        
    in
       footer [] 
           [ div [] [text "Total: "]
            ,div [] [text <| toString totalpts]
            ]

main : Program Never
main =
    App.beginnerProgram { model = initModel, update = update, view = view }
