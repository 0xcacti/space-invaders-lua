# space-invaders-lua

Building a Space Invaders game in Lua using the Love2D framework.
Previously wanted to build this in rust, but then I realized 
that I despise rust, and I don't want to use it for anything.  
I enjoy using Lua for neovim, so I decided that I would do some 
cool stuff with it to build a game outside of the context of neovim.


## TODO 

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

- [ ] Add supplementals
    - [ ] Properly manage game state
        - [x] Correctly transition between states
        - [x] Add start screen
        - [x] Add game over state 
        - [ ] Add game paused state
        - [x] Add save files
        - [x] Add high scores
        - [ ] make game over look nice
    - [ ] Add music and sounds 
    - [ ] Configure 
        - [ ] Proper space ship rate 
        - [ ] Proper fire rates


