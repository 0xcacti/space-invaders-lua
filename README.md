# space-invaders-lua

Building a Space Invaders game in Lua using the Love2D framework.
Previously wanted to build this in rust, but then I realized 
that I despise rust, and I don't want to use it for anything.  
I enjoy using Lua for neovim, so I decided that I would do some 
cool stuff with it to build a game outside of the context of neovim.

okay, now writing this after the fact. Love2D is awesome.  It's so easy 
to just rip out a game.  Great experience and very fun to build a 2D game. 


## TODO 

Below is a general todo list that I used to keep track of what was left.  
It's somewhat incomplete because I started halfway through the project, 
and normally I would remove it, but I like it.  I tried to build this game 
mostly without the help of the internet or AI, so I tried to break everything 
down into really small steps.  It was fun.


- [x] UI 
    - [x] show score
        - [x] Make scoreboard
        - [x] Make scoreboard less ugly
    - [x] Show lives 
    - [x] add bottom line 

- [x] Create a player 
    - [x] Add ability to shoot
    - [x] Center bullet shooting from player 
    - [x] Restrict to one bullet at a time
    - [x] Add player death animation 
    - [x] Pause everything else during death animation

- [x] Create shot patterns 
    - [x] Straight 
    - [x] Zigzag
    - [x] Squiggly
    - [x] Plunger

- [x] Create enemies
    - [x] Add enemy death animation
    - [x] Create octopus enemy
        - [x] Customize to have correct behavior
    - [x] Create crab enemy
        - [x] Customize to have correct behavior
    - [x] Create squid enemy
        - [x] Customize to have correct behavior
    - [x] Implement correct shooting behavior
    - [x] Implement correct movement behavior 
    - [x] Create the UFO 

- [x] Create the game loop
    - [x] create grid of enemies
    - [x] Add enemy movement with increasing speed 
    - [x] Add rounds and ultimate end state 

- [x] Add supplementals
    - [x] Properly manage game state
        - [x] Correctly transition between states
        - [x] Add start screen
        - [x] Add game over state 
        - [x] Add game paused state
        - [x] Add save files
        - [x] Add high scores
        - [x] finish scoreboard
        - [x] make game over look nice
    - [x] Add music and sounds 


