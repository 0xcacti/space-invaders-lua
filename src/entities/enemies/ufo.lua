local Object = require("lib.classic")
local UFO = Object:extend()

function UFO:new(direction)
    UFO.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/ufo.png")
    self.sound = love.audio.newSource("assets/sfx/ufo_highpitch.wav", "static")
    self.sound:setLooping(true)
    self.sound:setVolume(0.1)


    self.image:setFilter("nearest", "nearest")
    self.scale = 4
    self.width = self.image:getWidth() * self.scale
    self.height = self.image:getHeight() * self.scale

    self.speed = 200
    self.direction = direction
    if self.direction == 1 then
        self.x = -self.width
    else
        self.x = love.graphics.getWidth()
    end
    self.y = 60
    self.is_dead = false
end

function UFO:update(dt)
    local window_width = love.graphics.getWidth()
    if not self.sound:isPlaying() and not self.is_dead then
        self.sound:play()
    end

    self.x = self.x + self.direction * self.speed * dt
    if self.x + self.width < 0 then
        self.is_dead = true
    elseif self.x > window_width then
        self.is_dead = true
    end
    if self.is_dead then
        self.sound:stop()
    end
end

function UFO:score(shots_fired)
    local last_digit = shots_fired % 10
    if last_digit == 0 or last_digit == 5 then
        return 300
    elseif last_digit == 1 or last_digit == 6 or last_digit == 9 then
        return 100
    elseif last_digit == 2 or last_digit == 4 or last_digit == 7 then
        return 50
    elseif last_digit == 3 or last_digit == 8 then
        return 150
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
    if not self.is_dead then
        love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self
            .scale)
    end
end

return UFO
