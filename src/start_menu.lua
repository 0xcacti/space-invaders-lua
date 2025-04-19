local Object = require("lib.classic")
local StartMenu = Object:extend()

function StartMenu:new(on_start)
    self.on_start = on_start
    self.screen_width = love.graphics.getWidth()
    self.screen_height = love.graphics.getHeight()
end

function StartMenu:draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("SPACE INVADERS", 0, self.screen_height / 3, self.screen_width, "center")
    love.graphics.printf("Press ENTER to Start", 0, self.screen_height / 2, self.screen_width, "center")
end

function StartMenu:update(dt)
end

function StartMenu:keypressed(key)
    if key == "return" or key == "space" then
        self.on_start()
    end
end

return StartMenu
