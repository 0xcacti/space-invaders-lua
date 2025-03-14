local state_manager
local state

function love.load(args)
    local StateManager = require("src.state_manager")
    local GameState = require("src.game_state")

    state_manager = StateManager()


    state = GameState(nil, 0)
end

function load_game_state()

end

function love.update(dt)
    if state.mode == "paused" then
        return
    end
    local res = state:update(dt)

    if res then
        if res == "gameover" then
            current_level = 1
        elseif res == "win" then
            current_level = current_level + 1
        end
    end
end

function love.keypressed(key)
    if key == "p" then
        if state.mode == "paused" then
            state.mode = "play"
        else
            state.mode = "paused"
        end
    end
    if state.mode == "paused" then
        return
    end

    state:keypressed(key)
end

function love.draw()
    state:draw()
end
