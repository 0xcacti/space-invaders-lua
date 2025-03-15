local Object = require("lib.classic")
local ScoreBoard = Object:extend()

function ScoreBoard:new(x, y, score)
    ScoreBoard.super.new(self)
    self.score = score or 0
    self.max_score = 999999
    self.x = x
    self.y = y
    local text_font = love.graphics.newFont("assets/font/text.ttf", 32)
    local number_font = love.graphics.newFont("assets/font/numbers.ttf", 64)
    self.text_font = text_font
    self.number_font = number_font
    self.width = text_font:getWidth("Score: ") + number_font:getWidth("999999")
    self.text_height = text_font:getHeight("Score: ")
end

function ScoreBoard:draw()
    love.graphics.setFont(self.text_font)
    love.graphics.print("Score: ", self.x, self.y)
    love.graphics.setFont(self.number_font)

    love.graphics.print(string.format("%06d", self.score), self.x + self.text_font:getWidth("Score: "), self.y - self.text_height / 2)
end

return ScoreBoard
