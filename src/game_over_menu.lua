local Object = require("lib.classic")
local GameOverMenu = Object:extend()

function GameOverMenu:new(score, on_game_end)

    self.score = score
    self.top_scores = {}
    self.top_names = {}
    self.filename = "highscores.txt"
    self.is_high_score = false 
    self.is_entering_name = false
    self.player_name = ""
    self.new_score_index = nil
    self.blink_timer = 0
    self.blink_rate = 0.5
    self.show_cursor = true

    if not love.filesystem.getInfo(self.filename) then
        love.filesystem.write(self.filename, "")
    end

    self.on_game_end = on_game_end
    self.large_text_font = love.graphics.newFont("assets/font/text.ttf", 64)
    self.text_font = love.graphics.newFont("assets/font/text.ttf", 32)
    self.screen_width = love.graphics.getWidth()
    self.screen_height = love.graphics.getHeight()

    self:load()

    for i = 1, #self.top_scores + 1 do
        if i > 10 then break end
        if i > #self.top_scores or score > self.top_scores[i] then
            self.is_high_score = true
            self.is_entering_name = true
            self.new_score_index = i
            
            -- Insert the new score and a placeholder name
            table.insert(self.top_scores, i, score)
            table.insert(self.top_names, i, "")
            
            -- Keep only top 10
            if #self.top_scores > 10 then
                table.remove(self.top_scores, 11)
                table.remove(self.top_names, 11)
            end
            
            break
        end
    end

    self.time = 0
end

function GameOverMenu:load()
    self.top_scores = {}
    if love.filesystem.getInfo(self.filename) then
        local file_str = love.filesystem.read("string", self.filename)
        for line in file_str:gmatch("([^\n]*)\n?") do
            local name, score = line:match("(.+):(.+)")
            if name and score then
                table.insert(self.top_names, name)
                table.insert(self.top_scores, tonumber(score))
            end
        end
    end
end

function GameOverMenu:save()
    local content = ""
    for i = 1, #self.top_scores do
        content = content .. self.top_names[i] .. ":" .. self.top_scores[i] .. "\n"
    end
    love.filesystem.write(self.filename, content)
end

function GameOverMenu:draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(0, 1, 0)
    love.graphics.setFont(self.large_text_font)
    local gave_over_height = self.screen_height / 7
    local font_height = self.large_text_font:getHeight()
    local gap_y = 10

    love.graphics.printf("GAME OVER", 0, self.screen_height / 7, self.screen_width, "center")

    local your_score_height = gave_over_height + font_height + gap_y
    love.graphics.setFont(self.text_font)
    love.graphics.printf("Your Score: " .. self.score, 0, your_score_height, self.screen_width, "center")

    if self.is_high_score and not self.is_entering_name then 
        love.graphics.setColor(1, 1, 0)
        love.graphics.printf("NEW HIGH SCORE!", 0, your_score_height + font_height + gap_y, self.screen_width, "center")
        love.graphics.setColor(0, 1, 0)
    end

    font_height = self.text_font:getHeight()
    local top_scores_height = your_score_height + font_height + gap_y * 3
    love.graphics.printf("Top Scores", 0, top_scores_height, self.screen_width, "center")

    local scores_start_y = top_scores_height + self.text_font:getHeight() + gap_y
    for i = 1, #self.top_scores do 
        local y_pos = scores_start_y + (i - 1) * (font_height + gap_y)
        if i == self.new_score_index then 
            love.graphics.setColor(1, 1, 0) 
        else 
            love.graphics.setColor(0, 1, 0)
        end

        if self.is_entering_name then 
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("Enter your name and press Enter", 0, self.screen_height - 100, self.screen_width, "center")
        else 
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("Press Space or Enter to continue", 0, self.screen_height - 100, self.screen_width, "center")
        end
    end
end

function GameOverMenu:update(dt)
    self.time = self.time + dt
    
    -- Handle cursor blinking
    if self.is_entering_name then
        self.blink_timer = self.blink_timer + dt
        if self.blink_timer >= self.blink_rate then
            self.show_cursor = not self.show_cursor
            self.blink_timer = 0
        end
    end
end

function GameOverMenu:keypressed(key)
    if self.is_entering_name then
        if key == "return" and #self.player_name > 0 then
            self.top_names[self.new_score_index] = self.player_name
            self.is_entering_name = false
            self:save()
        elseif key == "backspace" then
            self.player_name = string.sub(self.player_name, 1, -2)
        elseif key == "escape" then
            -- Cancel name entry
            table.remove(self.top_scores, self.new_score_index)
            table.remove(self.top_names, self.new_score_index)
            self:load() -- Reload original scores
            self.is_entering_name = false
        end
    else
        if key == "return" or key == "space" then
            self.on_game_end()
        end
    end
end

function GameOverMenu:textinput(text)
    if self.is_entering_name and #self.player_name < 15 then
        -- Only allow alphanumeric and some special characters
        if text:match("[%w%s_%-]") then
            self.player_name = self.player_name .. text
        end
    end
end

return GameOverMenu
