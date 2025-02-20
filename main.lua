function love.load()
    song = love.audio.newSource("assets/song.ogg", "stream")
    song:setLooping(true)
    song:play()

    sfx = love.audio.newSource("assets/sfx.ogg", "static")
end

function love.update(dt)

end

function love.keypressed(key)
    if key == "space" then
        sfx:play()
    end
end

function love.draw()

end
