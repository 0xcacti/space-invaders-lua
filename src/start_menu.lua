local Object = require("lib.classic")
local StartMenu = Object:extend()

function StartMenu:new(on_start)
    self.on_start = on_start
    self.large_text_font = love.graphics.newFont("assets/font/text.ttf", 64)
    self.text_font = love.graphics.newFont("assets/font/text.ttf", 32)
    self.screen_width = love.graphics.getWidth()
    self.screen_height = love.graphics.getHeight()
    self.shake_amount = 1
    self.shake_speed = 5
    self.time = 0
end

function StartMenu:draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(0, 255, 0)
    love.graphics.setFont(self.large_text_font)
    love.graphics.printf("SPACE INVADERS", 0, self.screen_height / 3, self.screen_width, "center")
    love.graphics.setFont(self.text_font)

    local shake_x = math.sin(self.time * self.shake_speed) * self.shake_amount
    local shake_y = math.cos(self.time * self.shake_speed) * self.shake_amount / 2

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press ENTER to Start",
        0 + shake_x,
        self.screen_height / 2 + shake_y,
        self.screen_width,
        "center"
    )
end

function StartMenu:update(dt)
    self.time = self.time + dt
end

function StartMenu:keypressed(key)
    if key == "return" or key == "space" then
        self.on_start()
    end
end

function StartMenu:textinput(text)
    _ = text
end

return StartMenu
