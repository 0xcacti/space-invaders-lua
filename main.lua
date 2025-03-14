local state

function love.load(args)
    local GameState = require("src.game_state")

    invaderSounds = {
        love.audio.newSource("assets/sfx/fastinvader1.wav", "static"),
        love.audio.newSource("assets/sfx/fastinvader2.wav", "static"),
        love.audio.newSource("assets/sfx/fastinvader3.wav", "static"),
        love.audio.newSource("assets/sfx/fastinvader4.wav", "static"),
    }

    for _, sound in ipairs(invaderSounds) do
        sound:setVolume(0.5)
    end


    -- Sound effect timing variables
    currentInvaderSound = 1
    invaderSoundTimer = 0
    invaderSoundInterval = 0.5

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

    invaderSoundTimer = invaderSoundTimer + dt
    if invaderSoundTimer >= invaderSoundInterval then
        invaderSoundTimer = 0

        -- Stop all sounds first
        for _, sound in ipairs(invaderSounds) do
            sound:stop()
        end

        -- Then play the current one
        invaderSounds[currentInvaderSound]:play()
        currentInvaderSound = currentInvaderSound % #invaderSounds + 1
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
