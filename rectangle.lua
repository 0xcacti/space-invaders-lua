Rectangle = Shape:extend()

function Rectangle:new(x, y, width, height)
    Rectangle.super.new(self, x, y)
    self.width = width
    self.height = height
    self.speed = 100
end

function Rectangle:draw() 
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
