#Planning BasketBall ScoreKeeping App

##Model (Data)

TODO: Model's Shape
```
Model = { players : List Player
        , playerName : String
        , playerId : Maybe Int (for determining Add or Edit)
        , plays : List Play
        }
```

TODO: Player's Shape
```
 Player = { id : Int (Unique id - is this needed?)
        , name : String
        , totalpoints : Int -- Running point total
          }
```

TODO: Play's Shape
```
 Play = {id : Int
        , playerId : Int (Corresponds to the Models playerId
        , name : String
        , points : Int
        }
```

TODO: Initial Model
```
Model = { players = {}
        , playerName = ""
        , playerId = Empty
        , plays = {}
        }
```

---
##Update (Behavior)
What can be done to our app?

 * Edit
 * Score (2/3 pt)
 * Input Player Name
 * Save Player Name
 * Cancel Player Name
 * Delete Plays

TODO: Create Message Union Type for the above actions

TODO: Create Update Functions

---
##View (UI)
Break the view into several components

 * Main View
     * Player Section
         * Player Header
         * Player List
             * player
         * Point Total
     * Player Form (to add/edit player)
        * Save
        * Cancel
     * Play List
        * play list header
        * play list
            * play

TODO: Create Functions for above
