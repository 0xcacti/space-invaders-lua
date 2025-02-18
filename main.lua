function love.load()
    Object = require("classic")
    require("shape")
    require("circle")
    require("rectangle")

    r1 = Rectangle(100, 100, 200, 50)
    r2 = Circle(350, 80, 40)

end

function love.keypressed(key)
end

function love.update(dt)
    r1:update(dt)
    r2:update(dt)
end

function love.draw()
    r1:draw()
    r2:draw()
end
