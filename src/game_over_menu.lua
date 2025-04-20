local Object = require("lib.classic")
local GameOverMenu = Object:extend()

function GameOverMenu:new(score, on_game_end)
    self.top_scores = {}
    self.filename = "highscores.txt"
    if not love.filesystem.getInfo(self.filename) then
        love.filesystem.write(self.filename, "")
    end
    self.on_game_end = on_game_end
    self.large_text_font = love.graphics.newFont("assets/font/text.ttf", 64)
    self.text_font = love.graphics.newFont("assets/font/text.ttf", 32)
    self.screen_width = love.graphics.getWidth()
    self.screen_height = love.graphics.getHeight()
    self.time = 0
end

function GameOverMenu:load()
    self.top_scores = {}

    if love.filesystem.getInfo(self.filename) then
        local file = love.filesystem.read("string", self.filename)
        for line in file:gmatch("([^\n\r]*)[\n\r]*") do
            self.top_scores[#self.top_scores + 1] = tonumber(line)
        end
    end
end

function GameOverMenu:draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(0, 255, 0)
    love.graphics.setFont(self.large_text_font)
    love.graphics.printf("GAME OVER", 0, self.screen_height / 7, self.screen_width, "center")
    love.graphics.setFont(self.text_font)
end

function GameOverMenu:update(dt)
    self.time = self.time + dt
end

function GameOverMenu:keypressed(key)
    if key == "return" or key == "space" then
        self.on_game_end()
    end
end

return GameOverMenu
