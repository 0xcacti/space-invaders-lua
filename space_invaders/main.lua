function love.load()
    -- Initialization code, runs once at the start
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2) -- Set background to dark gray
    message = "Hello, World!"
    font = love.graphics.newFont(32)                -- Load a font at size 32
    love.graphics.setFont(font)
end

function love.update(dt)
    -- Called every frame to update game state
    -- `dt` is the time delta since the last frame
end

function love.draw()
    -- Called every frame to draw on the screen
    love.graphics.setColor(1, 1, 1) -- Set color to white
    love.graphics.printf(message, 0, love.graphics.getHeight() / 2 - font:getHeight() / 2, love.graphics.getWidth(),
        "center")
end
