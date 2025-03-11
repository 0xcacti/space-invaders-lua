local Object = require("lib.classic")
local UFO = Object:extend()

function UFO:new(x, y)
    UFO.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/ufo.png")
    self.image:setFilter("nearest", "nearest")
    self.scale = 4
    self.width = self.image:getWidth() * self.scale
    self.height = self.image:getHeight() * self.scale

    self.speed = 400
    self.x = x
    self.y = y
    self.score = 10
    self.current_frame = 1
    self.is_dead = false
end

function UFO:update(dt)
    local window_width = love.graphics.getWidth()

    self.x = self.x + self.speed * dt
    if self.x < 0 then
        self.x = 0
        self.speed = -self.speed
        self.y = self.y + self.height
    elseif self.x + self.width > window_width then
        self.x = window_width - self.width
        self.speed = -self.speed
        self.y = self.y + self.height
    end

    self.current_frame = self.current_frame + dt
    if self.current_frame >= #self.frames + 1 then
        self.current_frame = 1
    end
end

function UFO:checkCollision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if self_right > obj_left and
        self_left < obj_right and
        self_bottom > obj_top and
        self_top < obj_bottom then
        self.is_dead = true
        return true
    end

    return false
end

function UFO:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self
        .scale)
end

return UFO
