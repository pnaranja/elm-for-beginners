module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import String


--MODEL


type Mode player
    = EditPlayer player
    | AddPlayer


type PlayerSelect
    = Select
    | NotSelect


type alias Id =
    Int


type alias Points =
    Int


type alias Model =
    { players : List Player
    , name : String
    , mode : Mode Player
    , plays : List Play
    }


type alias Player =
    { id : Id
    , name : String
    , totalpoints : Points
    , select : PlayerSelect
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
    = Edit Player
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

        Edit player ->
            editModeModelHighlight player model

        Score player pts ->
            changePtsModel model player pts

        Delete play ->
            deletePlayModel model play


saveModel : Model -> Model
saveModel model =
    case model.mode of
        AddPlayer ->
            { model
                | players = (Player (List.length model.players) model.name 0 NotSelect) :: model.players
                , name = ""
            }

        EditPlayer player ->
            changeNameModel player model


editModeModelHighlight : Player -> Model -> Model
editModeModelHighlight player model =
    let
        newPlayers =
            List.map
                (\p ->
                    if p.name == player.name then
                        { p | select = Select }
                    else
                        p
                )
                model.players
    in
        { model
            | name = player.name
            , mode = EditPlayer player
            , players = newPlayers
        }



-- To edit a player, you need to change the Player.name and Play.name


changeNameModel : Player -> Model -> Model
changeNameModel player model =
    { model
        | players = List.map (changePlayerNameSelect player.id model.name) model.players
        , plays = List.map (changePlayName player model.name) model.plays
        , name = ""
        , mode = AddPlayer
    }


changePlayerNameSelect : Id -> String -> Player -> Player
changePlayerNameSelect id newname player =
    if player.id == id then
        { player | name = newname, select = NotSelect }
    else
        player


changePlayName : Player -> String -> Play -> Play
changePlayName player newname play =
    if play.name == player.name then
        { play | name = newname }
    else
        play



-- Need to change Player Point total and add a new play to the PlayList


changePtsModel : Model -> Player -> Int -> Model
changePtsModel model player pts =
    { model
        | players =
            List.map
                (\plyer -> changePlayerPtsIfMatch plyer player pts)
                model.players
        , plays =
            Play (List.length model.plays) player.id player.name pts
                :: model.plays
    }


changePlayerPtsIfMatch : Player -> Player -> Points -> Player
changePlayerPtsIfMatch player1 player2 pts =
    if player1.name == player2.name then
        { player1 | totalpoints = player1.totalpoints + pts }
    else
        player1



-- Delete the play from plays and player's totalpoints


deletePlayModel : Model -> Play -> Model
deletePlayModel model play =
    let
        newplays =
            List.filter (\p -> p.id /= play.id) model.plays

        newPlayers =
            List.map
                (\player ->
                    if player.name == play.name then
                        { player | totalpoints = player.totalpoints - play.points }
                    else
                        player
                )
                model.players
    in
        { model
            | plays = newplays
            , players = newPlayers
        }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "ScoreKeeper" ]
        , playerSection model
        , playerForm model
        , playSection model
        , div [] [ text <| toString model ]
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
        [ div [] [ text "Name" ]
        , div [] [ text "Points" ]
        ]



-- ul tag with li tag for each player


playerList : Model -> Html Msg
playerList model =
    ul [] <|
        List.map playerListRow <|
            List.sortBy .name <|
                model.players



-- Add CSS style for edit selects


editSelect : Player -> Attribute Msg
editSelect player =
    if player.select == Select then
        style [ ( "backgroundColor", "LightSkyBlue" ) ]
    else
        style [ ( "backgroundColor", "White" ) ]



-- Create a Player List row for the PlayerList
-- Needs to show:
--  icon to edit, the player name, 2/3pts buttons, and the total points


playerListRow : Player -> Html Msg
playerListRow player =
    li []
        [ i
            [ class "edit"
            , onClick (Edit player)
            ]
            []
        , div [ editSelect player ]
            [ text player.name ]
        , button
            [ type' "button"
            , onClick (Score player 2)
            ]
            [ text "2pts" ]
        , button
            [ type' "button"
            , onClick (Score player 3)
            ]
            [ text "3pts" ]
        , div []
            [ text <| toString player.totalpoints ]
        ]



-- Show total points of all the players


pointTotal : Model -> Html Msg
pointTotal model =
    let
        totalpts =
            List.sum <| List.map (\player -> player.totalpoints) model.players
    in
        footer []
            [ div [] [ text "Total: " ]
            , div [] [ text <| toString totalpts ]
            ]



-- To Add/Edit players


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
        ]



-- Show Plays


playHeader : Model -> Html Msg
playHeader model =
    header []
        [ div [] [ text "Plays" ]
        , div [] [ text "Points" ]
        ]


playSection : Model -> Html Msg
playSection model =
    div []
        [ playHeader model
        , ul [] <|
            List.map playListRow <|
                model.plays
        ]


playListRow : Play -> Html Msg
playListRow play =
    li []
        [ i [ class "remove", onClick <| Delete play ] []
        , div []
            [ text play.name ]
        , div []
            [ text <| toString play.points ]
        ]


main : Program Never
main =
    App.beginnerProgram { model = initModel, update = update, view = view }
