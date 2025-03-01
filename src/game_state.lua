local Object = require("lib.classic")
local GameState = Object:extend()
local Player = require("src.entities.player")
local Red = require("src.entities.red")
local ScoreBoard = require("src.ui.score_board")

function GameState:init()
    GameState.super.new(self)
    self.state = 'play'
    self.player = Player()
    self.enemies = { Red:new() }
    self.player_bullets = {}
    self.enemy_bullets = {}
    self.score_board = ScoreBoard:new(20, 20)
    self.collision_manager = nil


    return self
end

function GameState:update(dt)
    player:update(dt)
    red:update(dt)

    for i, bullet in ipairs(player_bullets) do
        bullet:update(dt)
        local hit = bullet:checkCollision(red)
        if hit then
            if red:checkCollision(bullet) then
                self.score_board.score = self.score_board.score + red.score
            end
        end

        if bullet.is_dead then
            table.remove(player_bullets, i)
        end
    end

    red:chanceToShoot(enemy_bullets)

    for i, bullet in ipairs(enemy_bullets) do
        bullet:update(dt)
        local hit = bullet:checkCollision(player)
        if hit then
            player:checkCollision(bullet)
            table.remove(enemy_bullets, i)
        end
    end
end

function GameState:keypressed(key)
    player:keyPressed(key, player_bullets)
end

function GameState:draw()
    player:draw()
    if not red.is_dead then
        red:draw()
    end
    score_board:draw()

    for _, bullet in ipairs(player_bullets) do
        bullet:draw()
    end

    for _, bullet in ipairs(enemy_bullets) do
        bullet:draw()
    end
end

return GameState
