# space-invaders-lua

Building a Space Invaders game in Lua using the Love2D framework.
Previously wanted to build this in rust, but then I realized 
that I despise rust, and I don't want to use it for anything.  
I enjoy using Lua for neovim, so I decided that I would do some 
cool stuff with it to build a game outside of the context of neovim.


## TODO 

- [ ] Create a player 
    - [ ] Add ability to shoot
    - [ ] Center bullet shooting from player 
    - [ ] Add player death animation 

- [ ] Create enemies
    - [ ] Create shot patterns 
        - [ ] Investigate types, draw, implement
    - [ ] Add enemy death animation
    - [ ] Create octopus enemy
        - [ ] Customize to have correct behavior
    - [ ] Create crab enemy
        - [ ] Customize to have correct behavior
    - [ ] Create squid enemy
        - [ ] Customize to have correct behavior
    - [ ] Create the UFO 

- [ ] Create the game loop
    - [ ] create grid of enemies
    - [ ] 

- [ ] Add supplementals
    - [ ] Add game over screen 
    - [ ] Add start screen
    - [ ] Add save files


--- 

Original Space Invaders (1978) Game Mechanics
Player Mechanics

Movement: The player controls a laser cannon that can only move horizontally (left and right) at the bottom of the screen
Shooting: Player can only have one bullet on screen at a time
Lives: Player starts with 3 lives
Score: Displayed at top of screen, points awarded for each alien destroyed

Alien Mechanics

Formation: 5 rows of 11 aliens (55 total)
Types:

Top row: Octopus (worth 10 points)
Middle two rows: Crab (worth 20 points)
Bottom two rows: Squid (worth 30 points)


Movement:

Aliens move horizontally in unison
When reaching the edge of the screen, the entire formation drops down one line and reverses direction
Movement speed increases as aliens are destroyed
If any alien reaches the bottom of the screen, the game ends regardless of remaining lives



Alien Attack Pattern

Only one alien can fire at a time
Maximum of 1 to 3 alien bullets on screen simultaneously (number increases with difficulty level)
Firing alien is chosen pseudo-randomly, with preference given to aliens in the lower positions
Three types of alien bullets with different movement patterns:

Squiggly (zigzag movement)
Rolling (tumbling appearance)
Plunger (straight line)



Defensive Bunkers

Four destructible shields between player and aliens
Shields degrade when hit by either player or alien bullets
Can be used strategically for protection
Eventually disintegrate completely after multiple hits

UFO Mechanics

Appears randomly at the top of the screen moving horizontally
Worth between 50-300 points (in the original, always 300 points - value varied in later versions)
Makes distinctive sound when appearing

Game Progression

After clearing all aliens, a new wave appears with the same formation
Each new wave starts one line lower than the previous
Game speed increases with each wave
No formal "end" to the game - continues until player loses all lives

Technical Details

Runs at approximately 60 cycles per second (60Hz)
The original limitation of one bullet was due to hardware constraints
The gradual speedup occurs because fewer aliens means less processing time per frame
The game uses a simple RNG (Random Number Generator) for alien shooting behavior
No background music during gameplay, only sound effects
Distinctive four-note descending bass line plays continuously during gameplay, speeding up as aliens move faster

The game had no levels, upgrades, power-ups, or boss fights. Its elegance came from the simple but effective increasing difficulty created by the accelerating alien movement.
