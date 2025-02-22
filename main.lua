local player
local game_state
local font
local window_width
local window_height

function love.load()
    game_state = 'play'
    window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()
    local menu_options = { 'Play', 'Options' }
    local selected_menu_item = 1
    font = love.graphics.newFont(20)

    local Player = require("src.entities.player")
    local Red = require("src.entities.red")
    local Green = require("src.entities.green")
    local Yellow = require("src.entities.yellow")
    local Barricade = require("src.entities.barricade")
    player = Player:new()
    red = Red:new()
    green = Green:new()
    yellow = Yellow:new()
    barricade = Barricade:new()
end

function love.update(dt)
    player:update(dt)
    red:update(dt)
    yellow:update(dt)
    green:update(dt)
end

function love.draw()
    if game_state == 'menu' then
    elseif game_state == 'options' then
    elseif game_state == 'pause' then
    elseif game_state == 'play' then
        love.graphics.print("999999", font, window_width - 80, 20)
        player:draw()
        red:draw()
        yellow:draw()
        green:draw()
        barricade:draw()
    end
end
