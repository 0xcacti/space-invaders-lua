function love.load()
    frames = {}
    table.insert(frames, love.graphics.newImage("assets/jump1.png"))
    table.insert(frames, love.graphics.newImage("assets/jump2.png"))
    table.insert(frames, love.graphics.newImage("assets/jump3.png"))
    table.insert(frames, love.graphics.newImage("assets/jump4.png"))
    table.insert(frames, love.graphics.newImage("assets/jump5.png"))

    currentFrame = 1
end

function love.update(dt)
    currentFrame = currentFrame + 10 * dt
    if currentFrame >= 6 then
        currentFrame = 1
    end
end

function love.draw()
    love.graphics.draw(frames[math.floor(currentFrame)])
end
