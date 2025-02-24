local Bullet = require("src.entities.bullets.bullet")
local PlungerBullet = Bullet:extend()

function PlungerBullet:new(x, y, is_enemy)
    PlungerBullet.super.new(self, x, y, is_enemy)

    self.image = love.graphics.newImage("assets/sprites/bullets/plungerquad.png")
    self.image:setFilter("nearest", "nearest")
    self.frames = {}


    -- 4 frames
    for i = 0, 3 do
        local offset = i * 4
        table.insert(self.frames,
            love.graphics.newQuad(offset, 0, 3, 7, self.image:getDimensions()))
    end
    self.current_frame = 1

    self.scale = 4
    self.width = 1 * self.scale
    self.height = 7 * self.scale
    self.visual_width = 3 * self.scale
    self.visual_height = 7 * self.scale
    return self
end

function PlungerBullet:update(dt)
    if self.is_enemy then
        self.y = self.y + self.speed * dt
    else
        self.y = self.y - self.speed * dt
    end
    local window_height = love.graphics.getHeight()

    if self.y < 0 or self.y + self.width > window_height then
        self.is_dead = true
    end

    self.current_frame = self.current_frame + dt * 5
    if self.current_frame >= #self.frames + 1 then
        self.current_frame = 1
    end
end

function PlungerBullet:draw()
    love.graphics.draw(self.image, self.frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale, self
        .scale)
end

function PlungerBullet:checkCollision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if self_right > obj_left and
        self_left < obj_right and
        self_bottom > obj_top and
        self_top < obj_bottom then
        self.is_dead = true
        return true
    end

    return false
end

return PlungerBullet
