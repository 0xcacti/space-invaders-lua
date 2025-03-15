local Object = require("lib.classic")
local Red = Object:extend()

function Red:new(x, y)
    Red.super.new(self)
    self.image = love.graphics.newImage("assets/sprites/redquad.png")
    self.image:setFilter("nearest", "nearest")
    self.frames = {}

    -- logical size
    self.scale = 4
    self.image_width = 12
    self.image_height = 8
    self.width = self.image_width * self.scale
    self.height = self.image_height * self.scale

    table.insert(self.frames,
        love.graphics.newQuad(0, 0, self.image_width, self.image_height, self.image:getDimensions()))
    table.insert(self.frames,
        love.graphics.newQuad(self.image_width + 1, 0, self.image_width, self.image_height, self.image:getDimensions()))

    --  enemy atributes
    self.x = x
    self.y = y
    self.score = 10
    self.current_frame = 1
    self.is_dead = false
end

function Red:checkCollision(obj)
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

function Red:draw()
    love.graphics.draw(self.image, self.frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale, self
        .scale)
end

return Redlocal state_manager

function love.load()
    local StateManager = require("src.state_manager")
    state_manager = StateManager()
end

function love.update(dt)
    if state_manager.state.mode == "paused" then
        return
    end

    local res, score = state_manager.state:update(dt)

    if res then
        if res == "gameover" then
            current_level = 1
        elseif res == "win" then
            print("did we ever get here?")
            state_manager.level_idx = state_manager.level_idx + 1
            state_manager:load_game_state(state_manager.level_idx, score)
        end
    end
end

function love.keypressed(key)
    if key == "p" then
        if state_manager.state.mode == "paused" then
            state_manager.state.mode = "play"
        else
            state_manager.state.mode = "paused"
        end
    end
    if state_manager.state.mode == "paused" then
        return
    end

    state_manager.state:keypressed(key)
end

function love.draw()
    state_manager.state:draw()
end

