local Object = require("lib.classic")
local Invader = Object:extend()

function Invader:new(x, y)
    Invader.super.new(self)
    self.x = x
    self.y = y
    self.current_frame = 1
    self.is_dead = false
    self.death_timer = 0
    self.death_duration = 0.3
    self.remove = false
end

function Invader:mark_dead(dt)
    if self.is_dead then
        self.death_timer = self.death_timer + dt
        if self.death_timer >= self.death_duration then
            self.remove = true
        end
    end
end

function Invader:checkCollision(obj)
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

function Invader:draw()
    if not self.is_dead then
        love.graphics.draw(self.image, self.frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale, self
            .scale)
    elseif not self.remove then
        love.graphics.draw(self.death_image, self.x, self.y, 0, self.scale, self.scale)
    end
end

return Invader
