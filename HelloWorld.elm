module Main exposing (..)
import Html
import String
import List

(~+) a b = a + b + 0.1
add a b = (+) a b
result = add 1 2 |> add 3
result2 = add 2 2 |> \a->a%2 == 0
result3 = 2 ~+ 2
result4 = add 3 <| 4

counter = 0

increment_counter cnt amt =
    let
        localCount = cnt
    in
        localCount + amt

(~=) a b = (String.left 1 a) == (String.left 1 b)

countWords = (List.length << (String.split " ")) -- point free!

person = {name = "Paul", last = "Naranja"}

type Action = AddPlayer String | Score Int Int

action : Action -> String
action msg = case msg of
        AddPlayer name -> "Add player " ++ name
        Score id points ->
            "Player id " ++ (toString id) ++ " scored " ++ (toString points)


main = Html.text <| .name person
--main = Html.text <| toString <| countWords "Hello World"
