# space-invaders-lua

Building a Space Invaders game in Lua using the Love2D framework.
Previously wanted to build this in rust, but then I realized 
that I despise rust, and I don't want to use it for anything.  
I enjoy using Lua for neovim, so I decided that I would do some 
cool stuff with it to build a game outside of the context of neovim.


## TODO 

- [ ] UI 
    - [x] show score
        - [x] Make scoreboard
        - [x] Make scoreboard less ugly
    - [x] Show lives 
    - [x] add bottom line 

- [ ] Create a player 
    - [x] Add ability to shoot
    - [x] Center bullet shooting from player 
    - [x] Restrict to one bullet at a time
    - [ ] Add player death animation 

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
    - [ ] Add game over screen 
    - [ ] Add start screen
    - [ ] Add save files

- [ ] Add music and sounds 
- [ ] Add player death animation 
- [ ] Add persistent barriers between levels 
- [ ] Fix barrier spacing 
- [ ] make player persistent across levels 


