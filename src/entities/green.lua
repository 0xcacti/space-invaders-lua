local Object = require("lib.classic")
local Green = Object:extend()

function Green:new()
    Green.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/green.png")
    self.speed = 100
    self.x = 130
    self.y = 100
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    return self
end

function Green:update(dt)
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

function Green:draw()
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return Green
