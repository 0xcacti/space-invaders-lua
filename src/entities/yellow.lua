local Object = require("lib.classic")
local StraightBullet = require("src.entities.bullets.straight")
local PlungerBullet = require("src.entities.bullets.plunger")
local SquigglyBullet = require("src.entities.bullets.squiggly")
local ZigZagBullet = require("src.entities.bullets.zigzag")
local Yellow = Object:extend()

function Yellow:new(x, y)
    Yellow.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/yellowquad.png")
    self.image:setFilter("nearest", "nearest")
    self.frames = {}

    -- logical size
    self.scale = 4
    self.image_width = 8
    self.image_height = 8
    self.width = self.image_width * self.scale
    self.height = self.image_height * self.scale

    table.insert(self.frames,
        love.graphics.newQuad(0, 0, self.image_width, self.image_height, self.image:getDimensions()))
    table.insert(self.frames,
        love.graphics.newQuad(self.image_width + 1, 0, self.image_width, self.image_height, self.image:getDimensions()))

    --  enemy atributes
    self.speed = 100
    self.x = x
    self.y = y
    self.score = 10
    self.current_frame = 1
    self.is_dead = false
    self.chance_to_shoot = 0.01
end

function Yellow:shoot(enemy_bullets)
    local shot_type = love.math.random(1, 3)
    if shot_type == 1 then
        table.insert(enemy_bullets, PlungerBullet(self.x, self.y, true))
    elseif shot_type == 2 then
        table.insert(enemy_bullets, SquigglyBullet(self.x, self.y, true))
    else
        table.insert(enemy_bullets, ZigZagBullet(self.x, self.y, true))
    end
end

function Yellow:update(dt)
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

function Yellow:checkCollision(obj)
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

function Yellow:draw()
    love.graphics.draw(self.image, self.frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale, self
        .scale)
end

return Yellow
