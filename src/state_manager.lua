local Object = require("lib.classic")
local StateManager = Object:extend()
local GameState = require("src.game_state")

local levels = {
    {
        start_y = 50,
    },
    {
        start_y = 70,
    }
}

function StateManager:new(level, score, state)
    self.level_idx = level or 1
    self.score = score or 0
    self.state = state or GameState(levels[self.level_idx])
end

function StateManager:load_game_state(level_idx, score)
    local level = levels[level_idx]
    self.score = score
    self.state = GameState(level, score)
end

return StateManager
