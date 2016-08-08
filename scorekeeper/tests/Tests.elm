module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import ScoreKeeper exposing (..)

all : Test
all =
    describe "A Test Suite"
        [ test "InitModel" <|
            \() -> initModelTest
                
        , test "String.left" <|
            \() ->
                Expect.equal "a" (String.left 1 "abcdefg")
        ]

initModelTest : Expect.Expectation
initModelTest = Expect.equal ScoreKeeper.initModel {players =[],name="",mode=AddPlayer,plays=[]}
