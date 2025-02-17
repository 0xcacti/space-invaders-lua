require("example")
print(test)
function love.load()
    listOfRectangles = {}
end

function createRect()
    table.insert(listOfRectangles, { x = 0, y = 0, width = 100, height = 100, speed = 100 })
end

function love.keypressed(key)
    if key == "space" then
        createRect()
    end
end

function love.update(dt)
    for i, rect in ipairs(listOfRectangles) do
        rect.x = rect.x + rect.speed * dt
    end
end

function love.draw()
    for i, rect in ipairs(listOfRectangles) do
        love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
    end
end
