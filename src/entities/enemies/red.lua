local Invader = require("src.entities.enemies.invader")
local Red = Invader:extend()

function Red:new(x, y)
    Red.super.new(self, x, y)

    -- images
    self.image = love.graphics.newImage("assets/sprites/redquad.png")
    self.death_image = love.graphics.newImage("assets/sprites/enemy-death.png")
    self.image:setFilter("nearest", "nearest")

    -- frames and dimensions
    self.frames = {}
    self.scale = 4
    self.image_width = 12
    self.image_height = 8
    self.width = self.image_width * self.scale
    self.height = self.image_height * self.scale

    table.insert(self.frames,
        love.graphics.newQuad(0, 0, self.image_width, self.image_height, self.image:getDimensions()))
    table.insert(self.frames,
        love.graphics.newQuad(self.image_width + 1, 0, self.image_width, self.image_height, self.image:getDimensions()))

    --  enemy atributes
    self.score = 10
end

return Red
