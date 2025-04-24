local Object = require("lib.classic")
local GameOverMenu = Object:extend()

function GameOverMenu:new(score, on_game_end)
    self.score = score
    self.top_scores = {}
    self.top_names = {}
    self.filename = "highscores.txt"

    self.is_high_score = false
    self.has_saved = false
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
        assert(type(file_str) == "string", "file_str must be string")
        for line in file_str:gmatch("([^\n]*)\n?") do
            local name, score = line:match("(.+):(.+)")
            if name and score then
                table.insert(self.top_names, name)
                table.insert(self.top_scores, tonumber(score))
            end
        end
    end
    table.sort(self.top_scores, function(a, b) return a > b end)
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
    local gave_over_height = self.screen_height / 20
    local font_height = self.large_text_font:getHeight()
    local gap_y = 10

    love.graphics.printf("GAME OVER", 0, self.screen_height / 20, self.screen_width, "center")

    local your_score_height = gave_over_height + font_height + gap_y
    love.graphics.setFont(self.text_font)
    love.graphics.printf("Your Score: " .. self.score, 0, your_score_height, self.screen_width, "center")

    font_height = self.text_font:getHeight()
    local top_scores_height = your_score_height + font_height + gap_y * 2
    love.graphics.printf("Top Scores", 0, top_scores_height, self.screen_width, "center")

    local scores_start_y = top_scores_height + self.text_font:getHeight() + gap_y
    for i = 1, #self.top_scores do
        local y_pos = scores_start_y + (i - 1) * (font_height + gap_y)
        if i == self.new_score_index then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(0, 1, 0)
        end
        love.graphics.printf(self.top_names[i] .. ": " .. self.top_scores[i], 0, y_pos, self.screen_width, "center")
    end
    love.graphics.setColor(1, 1, 1)
    if not self.has_saved and self.is_high_score and not self.is_entering_name then
        love.graphics.printf("Press Space to enter your name", 0, self.screen_height - 100, self.screen_width,
            "center")
    elseif self.is_entering_name then
        self:draw_popup()
    else
        love.graphics.printf("Press Space or Enter to start a new game", 0, self.screen_height - 100, self.screen_width,
            "center")
    end
end

function GameOverMenu:draw_popup()
    local width = self.screen_width * 2 / 3
    local height = self.screen_height * 2 / 3
    local x = (self.screen_width - width) / 2
    local y = (self.screen_height - height) / 2
    local corner_radius = 15
    love.graphics.setColor(0, 0, 0, 1.0)
    love.graphics.rectangle("fill", x, y, width, height, corner_radius, corner_radius)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, width, height, corner_radius, corner_radius)
    love.graphics.printf("Enter Name for High Score, Return to save", x, y + 20, width, "center")

    -- draw player name and cursor
    local name_y = y + height / 2 - self.text_font:getHeight() / 2
    local name_x = x + width / 2 - self.text_font:getWidth(self.player_name) / 2
    local name_width = self.text_font:getWidth(self.player_name)
    local name_height = self.text_font:getHeight()
    local cursor_x = name_x + self.text_font:getWidth(self.player_name)
    local cursor_y = name_y 
    local cursor_width = self.text_font:getWidth("|")
    local cursor_height = self.text_font:getHeight()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.player_name, name_x, name_y, name_width, "center")
    if self.show_cursor then
        love.graphics.rectangle("fill", cursor_x, cursor_y, cursor_width, cursor_height)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function GameOverMenu:update(dt)
    self.time = self.time + dt
    if self.is_entering_name then
        self.blink_timer = self.blink_timer + dt
        if self.blink_timer >= self.blink_rate then
            self.show_cursor = not self.show_cursor
            self.blink_timer = 0
        end
    end
end

function GameOverMenu:keypressed(key)
    if self.is_high_score and not self.has_saved then
        if key == "space" then
            self.is_entering_name = true
        end
        if key == "return" and #self.player_name > 0 then
            self.top_names[self.new_score_index] = self.player_name
            self.is_entering_name = false
            self.has_saved = true
            self:save()
        end
        return
    end
    if self.is_entering_name then
        if key == "return" and #self.player_name > 0 then
            self.top_names[self.new_score_index] = self.player_name
            self.is_entering_name = false
            self.has_saved = true
            self:save()
        elseif key == "backspace" then
            self.player_name = string.sub(self.player_name, 1, -2)
        end
        return
    end
    if not self.is_entering_name then
        if key == "space" or key == "return" then
            self.on_game_end()
        end
    end
end

function GameOverMenu:textinput(text)
    if self.is_entering_name and #self.player_name < 15 then
        if text:match("[%w%s_%-]") then
            self.player_name = self.player_name .. text
        end
    end
end

return GameOverMenu
