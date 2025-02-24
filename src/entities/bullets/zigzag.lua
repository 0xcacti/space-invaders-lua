local Bullet = require("src.entities.bullets.bullet")
local ZigZagBullet = Bullet:extend()

function ZigZagBullet:new(x, y, is_enemy)
    ZigZagBullet.super.new(self, x, y, is_enemy)

    self.image = love.graphics.newImage("assets/sprites/bullets/zigzagquad.png")
    self.image:setFilter("nearest", "nearest")
    self.frames = {}

    -- Your quad setup: 3 frames (left, center, right)
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
    self.animation_timer = 0
    self.animation_speed = 5  -- Controls how fast it oscillates between frames

    self.scale = 4
    self.width = 1 * self.scale          -- Collision width
    self.height = 7 * self.scale         -- Collision height
    self.visual_width = 3 * self.scale   -- Visual width for centering
    self.visual_height = 7 * self.scale  -- Visual height

    return self
end

function ZigZagBullet:update(dt)
    -- Straight vertical movement
    if self.is_enemy then
        self.y = self.y + self.speed * dt
    else
        self.y = self.y - self.speed * dt
    end
    local window_height = love.graphics.getHeight()

    if self.y < 0 or self.y + self.height > window_height then
        self.is_dead = true
    end

    -- Animate through frames for the wiggle effect
    self.animation_timer = self.animation_timer + dt * self.animation_speed
    self.current_frame = 1 + math.abs(math.sin(self.animation_timer) * 2)  -- Oscillates between 1 and 3
end

function ZigZagBullet:draw()
    local currentFrame = math.floor(self.current_frame)
    love.graphics.draw(
        self.image,
        self.frames[currentFrame],
        self.x - self.visual_width / 2,  -- Center the sprite
        self.y,
        0,  -- No rotation
        self.scale,
        self.scale
    )
end

function ZigZagBullet:checkCollision(obj)
    local self_left = self.x - self.visual_width / 2
    local self_right = self.x + self.visual_width / 2
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
