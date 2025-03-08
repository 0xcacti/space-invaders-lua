local Object = require("lib.classic")
local StraightBullet = require("src.entities.bullets.straight")
local Player = Object:extend()

function Player:new()
    Player.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/player.png")
    self.height = 30
    self.speed = 200
    self.x = 800
    self.y = 600
    self.lives = 3
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
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

function Player:keyPressed(key, list_of_bullets)
    if key == "space" and #list_of_bullets == 0 then
        table.insert(list_of_bullets, StraightBullet(self.x + (self.width / 2), self.y, false))
    end
end

function Player:checkCollision(obj)
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
        self.lives = self.lives - 1
        if self.lives == 0 then
            love.load()
        end
        return true
    end

    return false
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return Player
