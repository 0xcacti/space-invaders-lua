function love.load()
    fruits = { "apple", "banana" }
    table.insert(fruits, "orange")
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        x = x + 100 * dt
    elseif love.keyboard.isDown("left") then
        x = x - 100 * dt
    end
end

function love.draw()
    -- love.graphics.rectangle("fill", x, 200, 50, 80)
    love.graphics.print("Test", 100, 100)
end
