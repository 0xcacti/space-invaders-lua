local Object = require("lib.classic")
local GameState = Object:extend()
local Player = require("src.entities.player")
local Red = require("src.entities.red")
local Green = require("src.entities.green")
local Yellow = require("src.entities.yellow")
local ScoreBoard = require("src.ui.score_board")
local Ground = require("src.ui.ground")

function GameState:new(level, score)
    assert(level, "GameState requires a non-nil level parameter")
    self.mode = 'play'
    self.player = Player()
    self.enemies = {}
    self.shooting_enemies = {}
    self.screen_width = love.graphics.getWidth()   -- window cant be resized
    self.screen_height = love.graphics.getHeight() -- window cant be resized
    self.end_height = 0.70 * self.screen_height
    self.ground_height = 0.90 * self.screen_height

    self.start_x = self.screen_width / 2
    self.start_y = level.start_y or 50

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
    self.move_interval = 0.2
    self.move_direction = 1
    self.move_step = width / 5

    -- enemy fire rates
    self.player_bullets = {}
    self.enemy_bullets = {}
end

function GameState:update(dt)
    if self.state == 'gameover' then
        return false, self.score_board.score
    elseif self.state == 'win' then
        return true, self.score_board.score
    end

    self.player:update(dt)

    self.move_timer = self.move_timer + dt
    if self.move_timer >= self.move_interval then
        self.move_timer = 0
        self:move_enemies()
    end

    for i, bullet in ipairs(self.player_bullets) do
        bullet:update(dt)
        for _, enemy in ipairs(self.enemies) do
            if not enemy.is_dead and enemy:checkCollision(bullet) then
                self.score_board.score = self.score_board.score + enemy.score
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

        if bullet.is_dead then
            table.remove(self.player_bullets, i)
        end
    end

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

    for i, bullet in ipairs(self.enemy_bullets) do
        bullet:update(dt)
        if bullet.is_dead then
            table.remove(self.enemy_bullets, i)
        end
        local hit = bullet:checkCollision(self.player)
        if hit then
            self.player:checkCollision(bullet)
            table.remove(self.enemy_bullets, i)
        end
    end

    if #self.enemies == 0 then 
        self.state = 'win'
    end
end

function GameState:move_enemies()
    local window_width = love.graphics.getWidth()
    local should_move_down = false
    for _, enemy in ipairs(self.enemies) do
        local next_x = enemy.x + self.move_step * self.move_direction
        if next_x < 0 or next_x + enemy.width > window_width then
            should_move_down = true
            self.move_direction = -self.move_direction
            break
        end
    end

    for _, enemy in ipairs(self.enemies) do
        if not enemy.is_dead then
            if should_move_down then
                enemy.y = enemy.y + enemy.height
            else
                enemy.x = enemy.x + self.move_step * self.move_direction
            end
            if enemy.current_frame == 1 then
                enemy.current_frame = 2
            else
                enemy.current_frame = 1
            end
            if enemy.y + enemy.height >= self.end_height then
                -- TODO end game
                love.load()
            end
        end
    end
end

function GameState:keypressed(key)
    self.player:keyPressed(key, self.player_bullets)
end

function GameState:draw()
    self.player:draw()

    for _, enemy in ipairs(self.enemies) do
        if not enemy.is_dead then
            enemy:draw()
        end
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
end

return GameState
