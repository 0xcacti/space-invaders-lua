local Object = require("lib.classic")
local StateManager = Object:extend()
local GameState = require("src.game_state")
local Barrier = require("src.barrier")
local Player = require("src.entities.player")

local levels = {
    {
        start_y = 110,
        move_interval = 0.5,
        ufo_chance = 0.0001
    },
    {
        start_y = 120,
        move_interval = 0.45,
        ufo_chance = 0.0001
    },
    {
        start_y = 130,
        move_interval = 0.40,
        ufo_chance = 0.0001
    },
    {
        start_y = 140,
        move_interval = 0.35,
        ufo_chance = 0.0001
    },
    {
        start_y = 150,
        move_interval = 0.30,
        ufo_chance = 0.0001
    },
    {
        start_y = 160,
        move_interval = 0.25,
        ufo_chance = 0.0001
    },
}

function StateManager:new()
    self.level_idx = 1
    self.score = 0
    self.player = Player()
    self.barriers = {}
    self:create_barriers()
    self:create_game_state()
    self.mode = "play"
end

function StateManager:create_game_state()
    local callbacks = {
        on_score = function(points) self.score = self.score + points end,
        on_win = function() self:on_win() end,
        on_game_over = function() self:on_game_over() end,
    }

    self.state = GameState(levels[self.level_idx], self.score, self.player, self.barriers, callbacks)
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

function StateManager:create_barriers()
    local tmp_barrier = Barrier(0, 0)
    -- Get the actual rendered width, not just the bitmap width
    local actual_barrier_width = tmp_barrier.width * tmp_barrier.pixelSize
    local screen_width = love.graphics.getWidth()
    local num_barriers = 4
    
    -- Calculate total space needed and spacing
    local total_barriers_width = num_barriers * actual_barrier_width
    local spacing = (screen_width - total_barriers_width) / (num_barriers + 1)
    
    self.barriers = {}
    for i = 1, num_barriers do
        local x = spacing * i + actual_barrier_width * (i - 1)
        local barrier = Barrier(x, 530)
        table.insert(self.barriers, barrier)
    end
end


function StateManager:on_game_over()
    self.level_idx = 1
    self.score = 0
    self.player = Player()
    self.barriers = {}

    self:create_game_state()
end

return StateManager
