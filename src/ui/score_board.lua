local Object = require("lib.classic")
local ScoreBoard = Object:extend()

function ScoreBoard:new(x, y, score)
    ScoreBoard.super.new(self)
    self.score = score or 0
    self.max_score = 999999
    self.x = x
    self.y = y
    local font = love.graphics.newFont(20)
    self.font = font
    self.width = font:getWidth("Score: 999999")
    self.height = font:getHeight()
end

function ScoreBoard:draw()
    love.graphics.print("Score: " .. self.score, self.font, self.x, self.y)
end

return ScoreBoard
