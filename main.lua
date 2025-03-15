local state_manager

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
