local player
local game_state
local player_bullets

function love.load()
    game_state = 'play'

    local ZigZagBullet = require("src.entities.bullets.zigzag")
    bullet = ZigZagBullet:new(100, 100, true)


    local Player = require("src.entities.player")
    local Red = require("src.entities.red")
    local ScoreBoard = require("src.systems.score_board")
    player = Player:new()
    red = Red:new()
    player_bullets = {}
    enemy_bullets = {}

    score_board = ScoreBoard:new(20, 20)
    print(score_board)
end

function love.update(dt)
    player:update(dt)
    red:update(dt)
    score_board:update(dt)

    for i, bullet in ipairs(player_bullets) do
        bullet:update(dt)
        local hit = bullet:checkCollision(red)
        if hit then
            if red:checkCollision(bullet) then
                score_board.score = score_board.score + red.score
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

function love.keypressed(key)
    player:keyPressed(key, player_bullets)
end

function love.draw()
    for i = 1, #bullet.frames do
        local x = 50 + (i - 1) * 50
        local y = 150
        local rotation

        if i == 1 then
            rotation = -math.pi / 6
        elseif i == 2 then
            rotation = math.pi / 6
        else
            rotation = math.pi / 4
        end



        -- Draw three rotated versions of each frame
        love.graphics.draw(
            bullet.image,
            bullet.frames[i],
            x,
            y,
            rotation,
            bullet.scale,
            bullet.scale,
            1.5, -- Center of rotation adjustments
            3.5
        )
    end


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
