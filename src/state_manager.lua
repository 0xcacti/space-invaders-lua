local Object = require("lib.classic")
local StateManager = Object:extend()
local GameState = require("src.game_state")

local levels = {
    {
        start_y = 110,
        ufo_chance = 0.1
    },
    {
        start_y = 140,
        ufo_chance = 0.1
    },
}

function StateManager:new()
    self.level_idx = 1
    self.score = 0
    self:create_game_state()
    self.mode = "play"
end

function StateManager:create_game_state()
    local callbacks = {
        on_score = function(points) self.score = self.score + points end,
        on_win = function() self:on_win() end,
        on_game_over = function() self:on_game_over() end,
    }

    self.state = GameState(levels[self.level_idx], self.score, callbacks)
end

function StateManager:on_win()
    self.level_idx = self.level_idx + 1
    if self.level_idx <= #levels then
        self:create_game_state()
    else
        self.level_idx = 1
        self.score = 0
        self:create_game_state()
    end
end

function StateManager:on_game_over()
    self.level_idx = 1
    self.score = 0
    self:create_game_state()
end

return StateManager
