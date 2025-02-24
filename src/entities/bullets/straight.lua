local Bullet = require("src.entities.bullets.bullet")
local StraightBullet = Bullet:extend()

function StraightBullet:new(x, y, is_enemy)
    StraightBullet.super.new(self, x, y, is_enemy)
    self.image = love.graphics.newImage("assets/sprites/bullets/straight.png")
    self.image:setFilter("nearest", "nearest")
    self.scale = 4
    self.width = self.image:getWidth() * self.scale
    self.height = self.image:getHeight() * self.scale
    return self
end

function StraightBullet:update(dt)
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

function StraightBullet:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end

function StraightBullet:checkCollision(obj)
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

return StraightBullet
