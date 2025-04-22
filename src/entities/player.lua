local Object = require("lib.classic")
local StraightBullet = require("src.entities.bullets.straight")
local Player = Object:extend()

function Player:new()
    Player.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/player.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.death_image = love.graphics.newImage("assets/sprites/player-deathquad.png")
    self.death_image:setFilter("nearest", "nearest") -- Add this line

    self.cur_death_frame = 0
    self.death_frames = {}
    local death_img_width = self.death_image:getWidth()
    local death_img_height = self.death_image:getHeight()


    self.death_frames[1] = love.graphics.newQuad(
        0, 0,
        death_img_width / 2,
        death_img_height,
        death_img_width,
        death_img_height
    )

    self.death_frames[2] = love.graphics.newQuad(
        death_img_width / 2, 0,
        death_img_width / 2,
        death_img_height,
        death_img_width,
        death_img_height
    )

    self.death_scale_x = self.width / (death_img_width / 2)
    self.death_scale_y = self.height / death_img_height

    self.shoot_sound = love.audio.newSource("assets/sfx/shoot.wav", "static")
    self.shoot_sound:setVolume(0.1)
    self.shoot_sound:setPitch(1.5)
    self.height = 30
    self.speed = 200
    self.x = 800
    self.y = 600
    self.lives = 3
    self.is_dead = false

    self.is_hit = false
    self.hit_timer = 0
    self.hit_duration = 0.5
    self.hit_flash_rate = 8

    self.remove = false
    self.death_timer = 0
    self.death_duration = 0.5
    self.shot_count = 0
end

function Player:update(dt)
    if self.is_dead then
        self.death_timer = self.death_timer + dt
        if self.death_timer >= self.death_duration then
            self.remove = true
        end
        return
    end

    if self.is_hit then
        self.hit_timer = self.hit_timer + dt
        if self.hit_timer >= self.hit_duration then
            self.is_hit = false
            self.hit_timer = 0
        end
    end

    local window_width = love.graphics.getWidth()
    if not self.is_dead and not self.is_hit then
        if love.keyboard.isDown("left") then
            self.x = self.x - self.speed * dt
        elseif love.keyboard.isDown("right") then
            self.x = self.x + self.speed * dt
        end
    end

    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > window_width then
        self.x = window_width - self.width
    end
end

function Player:keyPressed(key, list_of_bullets)
    if key == "space" and #list_of_bullets < 1 then
        self.shoot_sound:play()
        self.shot_count = self.shot_count + 1
        table.insert(list_of_bullets, StraightBullet(self.x + (self.width / 2), self.y, false))
    end
end

function Player:take_hit()
    self.is_hit = true
    self.hit_timer = 0
end

function Player:mark_dead()
    self.is_dead = true
    self.death_timer = 0
end

function Player:draw()
    if self.is_dead then
        if not self.remove then
            local frame_index = math.floor(self.death_timer * self.hit_flash_rate) % 2 + 1
            love.graphics.draw(
                self.death_image,
                self.death_frames[frame_index],
                self.x, -- Remove the +100 here
                self.y,
                0,      -- rotation
                self.death_scale_x,
                self.death_scale_y
            )
        end
    elseif self.is_hit then
        local frame_index = math.floor(self.hit_timer * self.hit_flash_rate) % 2 + 1
        love.graphics.draw(
            self.death_image,
            self.death_frames[frame_index],
            self.x, -- Remove the +100 here
            self.y,
            0,      -- rotation
            self.death_scale_x,
            self.death_scale_y
        )
    else
        love.graphics.draw(self.image, self.x, self.y)
    end
end

return Player
