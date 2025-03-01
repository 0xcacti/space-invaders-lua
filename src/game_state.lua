local Object = require("lib.classic")
local GameState = Object:extend()
local Player = require("src.entities.player")
local Red = require("src.entities.red")
local ScoreBoard = require("src.ui.score_board")

function GameState:new()
    GameState.super.new(self)
    self.state = 'play'
    self.player = Player:new()
    self.red = Red:new()
    self.enemies = { Red:new() }
    self.player_bullets = {}
    self.enemy_bullets = {}
    self.score_board = ScoreBoard:new(20, 20)
    self.collision_manager = nil


    return self
end

function GameState:update(dt)
    self.player:update(dt)
    self.red:update(dt)

    for i, bullet in ipairs(self.player_bullets) do
        bullet:update(dt)
        local hit = bullet:checkCollision(self.red)
        if hit then
            if self.red:checkCollision(bullet) then
                self.score_board.score = self.score_board.score + self.red.score
            end
        end

        if bullet.is_dead then
            table.remove(self.player_bullets, i)
        end
    end

    self.red:chanceToShoot(self.enemy_bullets)

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
    if not self.red.is_dead then
        self.red:draw()
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
