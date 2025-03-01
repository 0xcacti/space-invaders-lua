local state

function love.load()
    local GameState = require("src.game_state")
    state = GameState:new()
end

function love.update(dt)
    state:update(dt)
end

function love.keypressed(key)
    state:keypressed(key)
end

function love.draw()
    state:draw()
end
