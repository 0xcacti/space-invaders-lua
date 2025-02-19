function love.load()
    circle = {}
    circle.x = 100
    circle.y = 100
    circle.radius = 25
    circle.speed = 200
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
    angle = math.atan2(mouse_y - circle.y, mouse_x - circle.x)
    cos = math.cos(angle)
    sin = math.sin(angle)

    --Make the circle move towards the mouse
    circle.x = circle.x + circle.speed * cos * dt
    circle.y = circle.y + circle.speed * sin * dt
end

function love.draw()
    love.graphics.circle("line", circle.x, circle.y, circle.radius)

    --Print the angle
    love.graphics.print("angle: " .. angle, 10, 10)

    --Here are some lines to visualize the velocities
    love.graphics.line(circle.x, circle.y, mouse_x, circle.y)
    love.graphics.line(circle.x, circle.y, circle.x, mouse_y)

    --The angle
    love.graphics.line(circle.x, circle.y, mouse_x, mouse_y)
end
