local state

function love.load(args)
    local GameState = require("src.game_state")
    -- music = love.audio.newSource("assets/music/spaceinvaders2.ogg", "stream")
    -- music:setLooping(true)
    -- music:setVolume(0.5)
    -- music:play()
    s1 = love.audio.newSource("assets/sfx/fastinvader1.wav", "static")
    s2 = love.audio.newSource("assets/sfx/fastinvader2.wav", "static")
    s3 = love.audio.newSource("assets/sfx/fastinvader3.wav", "static")
    s4 = love.audio.newSource("assets/sfx/fastinvader4.wav", "static")
    s1:play()
    s2:play()
    s3:play()
    s4:play()
    sources = { s1, s2, s3, s4 }
    currentSource = 1
    playDelay = 0.5 -- Time between sounds in seconds
    timer = 0

    state = GameState(nil, 0)
end

function load_game_state()

end

function love.update(dt)
    timer = timer + dt

    -- Check if it's time to play the next sound
    if currentSource <= #sources and timer >= playDelay then
        sources[currentSource]:play()
        currentSource = currentSource + 1
        timer = 0 -- Reset timer
    end
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
