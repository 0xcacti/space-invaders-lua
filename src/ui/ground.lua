local Object = require("lib.classic")
local Ground = Object:extend()

function Ground:new(x_start, x_end, y)
    Ground.super.new(self)
    self.x_start = x_start
    self.x_end = x_end
    self.y = y
    self.thickness = 2
    self.color = { 0, 255, 0 }
end

function Ground:draw()
    love.graphics.push('all')
    love.graphics.setLineWidth(self.thickness)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x_start, self.y, self.x_end, self.y)
    love.graphics.pop()
end

return Ground
