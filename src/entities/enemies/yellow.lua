local Invader = require("src.entities.enemies.invader")
local Yellow = Invader:extend()

local PlungerBullet = require("src.entities.bullets.plunger")
local SquigglyBullet = require("src.entities.bullets.squiggly")
local ZigZagBullet = require("src.entities.bullets.zigzag")

function Yellow:new(x, y)
    Yellow.super.new(self, x, y)

    -- images
    self.image = love.graphics.newImage("assets/sprites/yellowquad.png")
    self.death_image = love.graphics.newImage("assets/sprites/enemy-death.png")
    self.image:setFilter("nearest", "nearest")

    -- frames and dimensions
    self.frames = {}
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
    self.score = 50
end

function Yellow:shoot(enemy_bullets)
    local shot_type = love.math.random(1, 3)
    if shot_type == 1 then
        table.insert(enemy_bullets, PlungerBullet(self.x + (self.width / 2), self.y, true))
    elseif shot_type == 2 then
        table.insert(enemy_bullets, SquigglyBullet(self.x, self.y, true))
    else
        table.insert(enemy_bullets, ZigZagBullet(self.x, self.y, true))
    end
end

return Yellow
