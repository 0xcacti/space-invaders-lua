local Object = require("lib.classic")
local Bullet = Object:extend()

function Bullet:new(x, y, is_enemy)
    Bullet.super.new(self)
    self.is_enemy = is_enemy
    if is_enemy then
        self.image = love.graphics.newImage("assets/sprites/bullet.png")
    else
        self.image = love.graphics.newImage("assets/sprites/player_bullet.png")
        self.image:setFilter("nearest", "nearest")
        self.scale = 4
    end
    self.x = x
    self.y = y
    if is_enemy then
        self.speed = 300
    else
        self.speed = 700
    end
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.is_dead = false
    return self
end

function Bullet:update(dt)
    if self.is_enemy then
        self.y = self.y + self.speed * dt
    else
        self.y = self.y - self.speed * dt
    end
    local window_height = love.graphics.getHeight()

    if self.y < 0 or self.y + self.width > window_height then
        self.is_dead = true
    end
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end

function Bullet:checkCollision(obj)
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

return Bullet
