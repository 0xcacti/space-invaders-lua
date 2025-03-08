local Object = require("lib.classic")
local GameState = Object:extend()
local Player = require("src.entities.player")
local Red = require("src.entities.red")
local ScoreBoard = require("src.ui.score_board")

function GameState:new()
    self.state = 'play'
    self.player = Player()
    self.enemies = {}

    self.red = Red(50, 100)
    self.red2 = Red(50, 100)
    self.start_x = 50
    self.start_y = 100

    for i = 0, 10 do
        local enemy = Red(self.start_x + i * 20, self.start_y)
        print(enemy.x, enemy.y)
        table.insert(self.enemies, enemy)
    end
    self.player_bullets = {}
    self.enemy_bullets = {}
    self.score_board = ScoreBoard:new(20, 20)
    self.collision_manager = nil
end

function GameState:update(dt)
    self.player:update(dt)

    for i, bullet in ipairs(self.player_bullets) do
        bullet:update(dt)
        for _, enemy in ipairs(self.enemies) do
            if not enemy.is_dead and bullet:checkCollision(enemy) then
                if enemy:checkCollision(bullet) then
                    self.score_board.score = self.score_board.score + enemy.score
                    bullet.is_dead = true
                    break
                end
            end
        end

        if bullet.is_dead then
            table.remove(self.player_bullets, i)
        end
    end

    for _, enemy in ipairs(self.enemies) do
        enemy:update(dt)
        if not enemy.is_dead then
            enemy:chanceToShoot(self.enemy_bullets)
        end
    end

    for i, bullet in ipairs(self.enemy_bullets) do
        bullet:update(dt)
        local hit = bullet:checkCollision(self.player)
        if hit then
            self.player:checkCollision(bullet)
            table.remove(self.enemy_bullets, i)
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

    self.score_board:draw()

    for _, bullet in ipairs(self.player_bullets) do
        bullet:draw()
    end

    for _, bullet in ipairs(self.enemy_bullets) do
        bullet:draw()
    end
end

return GameState
