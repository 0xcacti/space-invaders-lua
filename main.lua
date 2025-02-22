local player

function love.load()
    local Player = require("src.entities.player")
    local Red = require("src.entities.red")
    local Green = require("src.entities.green")
    local Yellow = require("src.entities.yellow")
    player = Player:new()
    red = Red:new()
    green = Green:new()
    yellow = Yellow:new()
end

function love.update(dt)
    player:update(dt)
    red:update(dt)
    yellow:update(dt)
    green:update(dt)
end

function love.draw()
    player:draw()
    red:draw()
    yellow:draw()
    green:draw()
end
