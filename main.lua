local state_manager

function love.load()
    local StateManager = require("src.state_manager")
    state_manager = StateManager()
end

function love.update(dt)
    state_manager:update(dt)
end

function love.keypressed(key)
    state_manager:keypressed(key)
end

function love.draw()
    state_manager:draw()
end
