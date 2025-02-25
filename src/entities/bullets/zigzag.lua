local Bullet = require("src.entities.bullets.bullet")
local ZigZagBullet = Bullet:extend()

function ZigZagBullet:new(x, y, is_enemy)
    ZigZagBullet.super.new(self, x, y, is_enemy)

    self.image = love.graphics.newImage("assets/sprites/bullets/zigzagquad.png")
    self.image:setFilter("nearest", "nearest")
    self.frames = {}


    for i = 0, 2 do
        local offset = i * 4
        local width = 3
        if i == 2 then
            width = 4
        end
        table.insert(self.frames,
            love.graphics.newQuad(offset, 0, width, 5, self.image:getDimensions()))
    end

    self.current_frame = 1
    self.animation_direction = 1

    self.scale = 4
    self.width = 1 * self.scale
    self.height = 7 * self.scale
    self.visual_width = 3 * self.scale
    self.visual_height = 7 * self.scale
    return self
end

function ZigZagBullet:update(dt)
    if self.is_enemy then
        self.y = self.y + self.speed * dt
    else
        self.y = self.y - self.speed * dt
    end
    local window_height = love.graphics.getHeight()

    if self.y < 0 or self.y + self.width > window_height then
        self.is_dead = true
    end

    self.current_frame = self.current_frame + (dt * 5 * self.animation_direction)
    if self.animation_direction == 1 and self.current_frame >= #self.frames then
        self.animation_direction = -1
        self.current_frame = #self.frames
    elseif self.animation_direction == -1 and self.current_frame <= 1 then
        self.animation_direction = 1
        self.current_frame = 1
    end
end

function ZigZagBullet:draw()
    local rotation
    local currentFrame = math.floor(self.current_frame)

    if currentFrame == 1 then
        rotation = -math.pi / 6
    elseif currentFrame == 2 then
        rotation = math.pi / 6
    else
        rotation = math.pi / 4
    end

    love.graphics.draw(
        self.image,
        self.frames[currentFrame],
        self.x + self.visual_width / 2,
        self.y / 2, -- center point for rotation
        rotation,

        self.scale,
        self.scale,
        self.visual_width / (2 * self.scale),
        0
    )
end

function ZigZagBullet:checkCollision(obj)
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

return ZigZagBullet
