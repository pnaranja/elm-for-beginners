module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import List
import Date

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

someDate theDate =
    case theDate of
        Ok theDate -> "It was a legit date"
        Err err -> err

maybeNum = Just 235
maybeResult = Maybe.map (add 2) maybeNum

type alias Item = {name:String, price:Float, qty:Int, discounted:Bool}
type alias Item2 = {name:String, qty:Int, freeQty:Int}

cart : List Item
cart = 
    [ {name="Lemon", price=0.5, qty=11, discounted=False},
      {name="Apple", price=1.2, qty=5, discounted=False}]

discount: Int -> Float -> Item -> Item
discount minQty discPct item =
    if item.qty >=minQty then {item | price = item.price*(1.0-discPct), discounted=True}
    else item

-- Use composition to combine 10 and 5 quantity discounts
fiveOrMoreDiscount = discount 10 0.8 << discount 5 0.5

cart2 : List Item2
cart2 =
    [ {name="Lemon", qty=1, freeQty = 0},
      {name="Apple", qty=5, freeQty = 0},
      {name="Pear", qty=11, freeQty = 0}
      ]

freeQuantity: Int -> Int -> Item2 -> Item2
freeQuantity minQty addQty item =
    if item.qty >= minQty
        then {item | freeQty=item.freeQty+addQty}
        else item

freeQuantities = freeQuantity 10 3 << freeQuantity 5 1

newcart = List.map fiveOrMoreDiscount cart
newcart2 = List.map freeQuantities cart2

-- main : Program Never
main =
    div
    [ style [("background-color", "red")], class "content", id "main-body"]
    [h1 [] [text "Hello World!"], text <| toString <| newcart2]

--main = Html.text <| toString <| newcart2
--main = Html.text <| toString <| maybeResult
--main = Html.text <| toString <| Date.fromString "09/08/1979"
--main = Html.text <| .name person
--main = Html.text <| toString <| countWords "Hello World"
