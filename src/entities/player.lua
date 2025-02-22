local Object = require("lib.classic")
local Player = Object:extend()

function Player:new()
    Player.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/player.png")
    self.height = 30
    self.speed = 200
    self.x = 800
    self.y = 600
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    return self
end

function Player:update(dt)
    local window_width = love.graphics.getWidth()

    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end

    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > window_width then
        self.x = window_width - self.width
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return Player
