local player

function love.load()
    print("Starting load")
    local Player = require("src.entities.player")
    print("Got Player:", Player)
    player = Player:new()
    print("Created player:", player)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
end
