local Object = require("lib.classic")
local StraightBullet = require("src.entities.bullets.straight")
local Player = Object:extend()

function Player:new()
    Player.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/player.png")
    self.shoot_sound = love.audio.newSource("assets/sfx/shoot.wav", "static")
    self.shoot_sound:setVolume(0.1)
    self.shoot_sound:setPitch(1.5)
    self.height = 30
    self.speed = 200
    self.x = 800
    self.y = 600
    self.lives = 3
    self.is_dead = false
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.shot_count = 0
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
    if key == "space" and #list_of_bullets <= 100 then
        self.shoot_sound:play()
        self.shot_count = self.shot_count + 1
        table.insert(list_of_bullets, StraightBullet(self.x + (self.width / 2), self.y, false))
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return Player
