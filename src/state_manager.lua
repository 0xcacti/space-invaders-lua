local Object = require("lib.classic")
local StateManager = Object:extend()
local GameState = require("src.game_state")

local levels = {
    start_y = 50,
}

function StateManager:new(state)
    self.level_num = 1
    self.state = state
end

function StateManager:load_game_state(level_num, score)
    local level = levels[level_num]
    self.state = GameState(level, score)
end
