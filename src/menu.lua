local Object = require("lib.classic")
local Menu = Object:extend()

function MenuState:new(callbacks)
    self.callbacks = callbacks
    self.mode = "menu"
    self.options = { "Play", "Scores", "Exit" }
    self.selected = 1
    self.title_y = 50
end

function Menu:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("SPACE INVADERS", 0, self.title_y, love.graphics.getWidth(), "center")
end
