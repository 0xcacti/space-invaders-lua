--! file: wall.lua
Wall = Entity:extend()

function Wall:new(x, y)
    Wall.super.new(self, x, y, "wall.png")
end
