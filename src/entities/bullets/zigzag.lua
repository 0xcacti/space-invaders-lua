local Bullet = require("src.entities.bullets.bullet")
local ZigZagBullet = Bullet:extend()

function ZigZagBullet:new(x, y, is_enemy)
    ZigZagBullet.super.new(self, x, y, is_enemy)

    self.image = love.graphics.newImage("assets/sprites/bullets/zigzagquad.png")
    self.image:setFilter("nearest", "nearest")
    self.frames = {}

    table.insert(self.frames,
        love.graphics.newQuad(0, 0, 3, 5, self.image:getDimensions()))

    table.insert(self.frames,
        love.graphics.newQuad(4, 0, 5, 4, self.image:getDimensions()))

    table.insert(self.frames,
        love.graphics.newQuad(9, 0, 3, 5, self.image:getDimensions()))

    self.current_frame = 1
    self.frame_timer = 0
    self.animation_direction = 1

    self.scale = 4
    self.width = 1 * self.scale
    self.height = 7 * self.scale
    self.visual_width = 3 * self.scale
    self.visual_height = 5 * self.scale
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


    local animation_speed = 0.1

    self.frame_timer = (self.frame_timer or 0) + dt

    if self.frame_timer >= animation_speed then
        self.frame_timer = self.frame_timer - animation_speed

        if self.current_frame == 1 then
            self.current_frame = 2
        elseif self.current_frame == 2 then
            if self.animation_direction == 1 then
                self.current_frame = 3
            else
                self.current_frame = 1
            end
        elseif self.current_frame == 3 then
            self.current_frame = 2
            self.animation_direction = -1
        end
    end
end

function ZigZagBullet:draw()
    local rotation
    local scaleX = self.scale
    local currentFrame = math.floor(self.current_frame)
    local x_loc = self.x


    if currentFrame == 1 then
        rotation = -math.pi / 6
        x_loc = self.x - self.visual_width / 2 + (self.width)
    elseif currentFrame == 2 then
        rotation = math.pi / 4
        x_loc = self.x + 2 * (self.width)
    else
        rotation = math.pi / 6
        x_loc = self.x + self.visual_width / 2 + (self.width)
    end

    love.graphics.draw(
        self.image,
        self.frames[currentFrame],
        x_loc,
        self.y + self.visual_height / 2,
        rotation,
        scaleX,
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
