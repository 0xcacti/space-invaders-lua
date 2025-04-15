local Object = require("lib.classic")
local GameState = Object:extend()
local Player = require("src.entities.player")
local Red = require("src.entities.enemies.red")
local Green = require("src.entities.enemies.green")
local Yellow = require("src.entities.enemies.yellow")
local UFO = require("src.entities.enemies.ufo")
local ScoreBoard = require("src.ui.score_board")
local Ground = require("src.ui.ground")
local Barrier = require("src.barrier")
require("src.utils")

function GameState:new(level, score, player, barriers, callbacks)
    assert(level, "GameState requires a non-nil level parameter")
    assert(score, "GameState requires a non-nil score parameter")
    assert(callbacks, "GameState requires a non-nil callbacks parameter")

    self.mode = 'play'
    self.callbacks = callbacks

    self.player = player or Player()
    self.enemies = {}
    self.shooting_enemies = {}

    -- ufo setup
    self.ufo_chance = level.ufo_chance
    self.ufos = {}

    self.screen_width = love.graphics.getWidth()   -- window cant be resized
    self.screen_height = love.graphics.getHeight() -- window cant be resized
    self.end_height = 0.70 * self.screen_height
    self.ground_height = 0.90 * self.screen_height

    self.start_x = self.screen_width / 2
    self.start_y = level.start_y

    self.x_gap = 10
    self.y_gap = 10

    local temp_enemy = Red(self.start_x, self.start_y)
    local width = temp_enemy.width
    local height = temp_enemy.height
    local x_spacing = width + self.x_gap
    local y_spacing = height + self.y_gap

    self.start_x = self.start_x - width

    for i = 1, 5 do
        if i >= 4 then
            local enemy = Red(self.start_x, self.start_y)
            table.insert(self.enemies, enemy)
            for j = 1, 5 do
                local r_enemy = Red(self.start_x + j * x_spacing, self.start_y)
                local l_enemy = Red(self.start_x - j * x_spacing, self.start_y)
                table.insert(self.enemies, r_enemy)
                table.insert(self.enemies, l_enemy)
            end
        elseif i >= 2 then
            local enemy = Green(self.start_x, self.start_y)
            table.insert(self.enemies, enemy)
            for j = 1, 5 do
                local r_enemy = Green(self.start_x + j * x_spacing, self.start_y)
                local l_enemy = Green(self.start_x - j * x_spacing, self.start_y)
                table.insert(self.enemies, r_enemy)
                table.insert(self.enemies, l_enemy)
            end
        else
            temp_enemy = Yellow(0, 0)
            local yellow_width = temp_enemy.width
            local center_offset = (width - yellow_width) / 4
            local yellow_center_x = self.start_x + center_offset

            local enemy = Yellow(yellow_center_x, self.start_y)
            table.insert(self.enemies, enemy)
            table.insert(self.shooting_enemies, enemy)
            for j = 1, 5 do
                local r_enemy = Yellow(yellow_center_x + j * x_spacing, self.start_y)
                local l_enemy = Yellow(yellow_center_x - j * x_spacing, self.start_y)
                table.insert(self.enemies, r_enemy)
                table.insert(self.enemies, l_enemy)
                table.insert(self.shooting_enemies, r_enemy)
                table.insert(self.shooting_enemies, l_enemy)
            end
        end
        self.start_y = self.start_y + y_spacing
    end

    self.score_board = ScoreBoard(20, 20, score)
    self.ground = Ground(0, self.screen_width, self.ground_height)

    -- move rates
    self.move_timer = 0
    self.base_move_interval = level.move_interval
    self.move_interval = self.base_move_interval
    self.move_direction = 1
    self.move_step = width / 5
    self.y_move_step = height / 3
    self.speed_increase_per_drop = 0.05

    -- enemy fire rates
    self.player_bullets = {}
    self.enemy_bullets = {}

    -- barriers
    self.barriers = barriers
end

function GameState:update(dt)
    self:check_state()
    self.player:update(dt)

    self:should_ufo()
    for _, ufo in ipairs(self.ufos) do
        ufo:update(dt)
    end

    for _, enemy in ipairs(self.enemies) do
        if enemy.is_dead then
            enemy.death_timer = enemy.death_timer + dt
            if enemy.death_timer >= enemy.death_duration then
                enemy.remove = true
            end
        end
    end


    self.move_timer = self.move_timer + dt
    if self.move_timer >= self.move_interval then
        self.move_timer = 0
        self:move_enemies(dt)
    end

    self:check_player_bullets(dt)
    self:enemy_fire()
    self:check_enemy_bullets(dt)
    self:check_ufo()

    if self.player.is_dead then
        self.state = 'gameover'
    end
end

function GameState:check_state()
    if all_dead(self.enemies) then
        self.state = 'win'
    end

    if self.state == 'gameover' and not self.state_change_triggered then
        self.state_change_triggered = true
        self:cleanup()
        self.callbacks.on_game_over()
        return
    elseif self.state == 'win' and not self.state_change_triggered then
        self.state_change_triggered = true
        self:cleanup()
        self.callbacks.on_win()
        return
    end
    collectgarbage("collect")
end

function GameState:check_player_bullets(dt)
    for i, bullet in ipairs(self.player_bullets) do
        bullet:update(dt)
        for _, enemy in ipairs(self.enemies) do
            print(enemy.height)
            if not enemy.is_dead and enemy:checkCollision(bullet) then
                self.score_board.score = self.score_board.score + enemy.score
                self.callbacks.on_score(enemy.score)

                bullet.is_dead = true
                if enemy:is(Yellow) then
                    for j, e in ipairs(self.shooting_enemies) do
                        if e == enemy then
                            table.remove(self.shooting_enemies, j)
                            break
                        end
                    end
                end
                break
            end
        end

        for _, ufo in ipairs(self.ufos) do
            if ufo:checkCollision(bullet) then
                local score = ufo:score(self.player.shot_count)
                self.score_board.score = self.score_board.score + score
                self.callbacks.on_score(score)
                bullet.is_dead = true
                break
            end
        end

        for _, barrier in ipairs(self.barriers) do
            if barrier:checkCollision(bullet) then
                bullet.is_dead = true
                break
            end
        end

        if bullet.is_dead then
            table.remove(self.player_bullets, i)
        end
    end
end

function GameState:enemy_fire()
    if #self.enemy_bullets < 3 and #self.shooting_enemies > 0 and love.math.random() < 0.005 then
        local alive_shooters = {}
        for _, enemy in ipairs(self.shooting_enemies) do
            if not enemy.is_dead then
                table.insert(alive_shooters, enemy)
            end
        end
        if #alive_shooters > 0 then
            local shooter_idx = love.math.random(1, #alive_shooters)
            local shooter = alive_shooters[shooter_idx]
            shooter:shoot(self.enemy_bullets)
        end
    end
end

function GameState:check_enemy_bullets(dt)
    for i, bullet in ipairs(self.enemy_bullets) do
        bullet:update(dt)
        if bullet.is_dead then
            table.remove(self.enemy_bullets, i)
        end

        local hit = bullet:checkCollision(self.player)
        if hit then
            self.player.lives = self.player.lives - 1
            if self.player.lives == 0 then
                self.player.is_dead = true
            end
            table.remove(self.enemy_bullets, i)
            return
        end

        for _, barrier in ipairs(self.barriers) do
            if barrier:checkCollision(bullet) then
                bullet.is_dead = true
                break
            end
        end
    end
end

function GameState:should_ufo()
    if #self.ufos == 0 and love.math.random() < self.ufo_chance then
        local direction = love.math.random(0, 1)
        if direction == 0 then
            direction = -1
        end
        local ufo = UFO(direction)
        table.insert(self.ufos, ufo)
    end
end

function GameState:check_ufo()
    for i, ufo in ipairs(self.ufos) do
        if ufo.is_dead then
            ufo.sound:stop()
            table.remove(self.ufos, i)
        end
    end
end

function GameState:cleanup()
    for _, ufo in ipairs(self.ufos) do
        ufo.sound:stop()
    end
    self.enemies = {}
    self.shooting_enemies = {}
    self.ufos = {}
    self.player_bullets = {}
    self.enemy_bullets = {}
end

function GameState:move_enemies(dt)
    local should_move_down = false

    for _, enemy in ipairs(self.enemies) do
        if not enemy.is_dead then
            local next_x = enemy.x + self.move_step * self.move_direction
            if next_x < 0 or next_x + enemy.width > self.screen_width then
                should_move_down = true
                self.move_direction = -self.move_direction
                break
            end
        end
    end

    for _, enemy in ipairs(self.enemies) do
        if not enemy.is_dead then
            if should_move_down then
                enemy.y = enemy.y + (enemy.height / 3)
            else
                enemy.x = enemy.x + self.move_step * self.move_direction
            end
            if enemy.current_frame == 1 then
                enemy.current_frame = 2
            else
                enemy.current_frame = 1
            end
            if enemy.y + enemy.height >= self.end_height then
                self.state = 'gameover'
            end
        end
    end

    if should_move_down then
        self.move_interval = self.move_interval * (1 - self.speed_increase_per_drop)
    end
end

function GameState:keypressed(key)
    self.player:keyPressed(key, self.player_bullets)
end

function GameState:draw()
    self.player:draw()

    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end

    for _, ufo in ipairs(self.ufos) do
        ufo:draw()
    end

    self.ground:draw()
    self.score_board:draw()

    for _, bullet in ipairs(self.player_bullets) do
        bullet:draw()
    end

    for _, bullet in ipairs(self.enemy_bullets) do
        if bullet.y + bullet.height < self.ground_height then
            bullet:draw()
        end
    end

    for _, barrier in ipairs(self.barriers) do
        barrier:draw()
    end

    local p_width = self.player.width
    local p_height = self.player.image:getHeight()
    local gap_right = 10
    local total_width = (p_width + gap_right) * 3
    for i=1, self.player.lives do 
        local x = (self.screen_width - p_width - 2 * gap_right) - (i-1) * (p_width + gap_right)
        local y = total_height
        love.graphics.draw(self.player.image, x, p_height)
    end
end

return GameState
