local Object = require("lib.classic")
local Barricade = Object:extend()

function Barricade:new()
    Barricade.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/barricade.png")
    self.speed = 100
    self.x = 100
    self.y = 500
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    return self
end

function Barricade:update(dt)
end

function Barricade:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return Barricade
