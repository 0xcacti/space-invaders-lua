local Object = require("lib.classic")
local Bullet = require("src.entities.bullet")
local Red = Object:extend()

function Red:new()
    Red.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/redquad.png")
    self.frames = {}
    self.width = 12
    self.height = 8

    table.insert(self.frames, love.graphics.newQuad(4, 0, self.width, self.height, self.image:getDimensions()))
    local offset = 5 + self.width 
    table.insert(self.frames, love.graphics.newQuad(offset, 0, self.width, self.height, self.image:getDimensions()))

    self.speed = 100
    self.x = 50
    self.y = 100
    self.score = 10
    self.current_frame = 1
    self.is_dead = false
    self.chance_to_shoot = 0.001

    return self
end

function Red:update(dt)
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

    self.current_frame = self.current_frame +  dt
    if self.current_frame >= 3 then
        self.current_frame = 1
    end
end

function Red:chanceToShoot(enemy_bullets)
    if love.math.random() < self.chance_to_shoot and not self.is_dead then
        table.insert(enemy_bullets, Bullet(self.x, self.y, true))
    end
end

function Red:checkCollision(obj)
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

function Red:draw()
    love.graphics.draw(self.image, self.frames[math.floor(self.current_frame)], self.x, self.y)
end

return Red
