local Invader = require("src.entities.enemies.invader")
local Green = Invader:extend()

function Green:new(x, y)
    Green.super.new(self, x, y)

    -- images
    self.image = love.graphics.newImage("assets/sprites/greenquad.png")
    self.death_image = love.graphics.newImage("assets/sprites/enemy-death.png")
    self.image:setFilter("nearest", "nearest")

    -- frames and dimensions
    self.frames = {}
    self.scale = 4
    self.image_width = 11
    self.image_height = 8
    self.width = self.image_width * self.scale
    self.height = self.image_height * self.scale

    table.insert(self.frames,
        love.graphics.newQuad(0, 0, self.image_width, self.image_height, self.image:getDimensions()))
    table.insert(self.frames,
        love.graphics.newQuad(self.image_width + 1, 0, self.image_width, self.image_height, self.image:getDimensions()))

    --  enemy atributes
    self.score = 20
end

return Green
