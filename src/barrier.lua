local Object = require('lib.classic')
local Barrier = Object:extend()

function Barrier:new(x, y)
    Barrier.super.new(self)
    self.x = x
    self.y = y
    self.pixelSize = 4 -- Size of each destructible pixel
    self.width = 44    -- Total width in pixels
    self.height = 32   -- Total height in pixels

    -- Initialize the pixel grid
    self.pixels = self:createBarrierPixels()
end

function Barrier:createBarrierPixels()
    -- Create the 2D grid representing our barrier
    local grid = {}
    for y = 1, self.height / self.pixelSize do
        grid[y] = {}
        for x = 1, self.width / self.pixelSize do
            -- Start with all pixels filled (will be shaped below)
            grid[y][x] = 0
        end
    end

    -- Define the barrier shape (similar to the original Space Invaders)
    local rows = self.height / self.pixelSize
    local cols = self.width / self.pixelSize

    -- Fill in the main body
    for y = 1, rows - 2 do
        for x = 1, cols do
            grid[y][x] = 1
        end
    end

    -- Create the bottom part with the space in the middle
    for y = rows - 1, rows do
        for x = 1, cols do
            if x < cols / 3 or x > 2 * cols / 3 then
                grid[y][x] = 1
            end
        end
    end

    return grid
end

function Barrier:checkCollision(bullet)
    -- Convert bullet position to grid coordinates
    local gridX = math.floor((bullet.x - self.x) / self.pixelSize) + 1
    local gridY = math.floor((bullet.y - self.y) / self.pixelSize) + 1

    -- Check if these coordinates are within bounds and if the pixel exists
    if gridX >= 1 and gridX <= self.width / self.pixelSize and
        gridY >= 1 and gridY <= self.height / self.pixelSize and
        self.pixels[gridY][gridX] == 1 then
        -- Destroy this pixel and potentially surrounding pixels
        self:destroyPixelsAround(gridX, gridY)
        return true
    end
    return false
end

function Barrier:destroyPixelsAround(centerX, centerY)
    -- Destroy a small cluster of pixels around the hit point
    local radius = 1 -- How many pixels around to destroy

    for y = centerY - radius, centerY + radius do
        for x = centerX - radius, centerX + radius do
            if x >= 1 and x <= self.width / self.pixelSize and
                y >= 1 and y <= self.height / self.pixelSize then
                self.pixels[y][x] = 0 -- Mark as destroyed
            end
        end
    end
end

function Barrier:update(dt)
    -- Not much to update for barriers, they're mostly static
    -- You might add effects like debris falling after destruction here
end

function Barrier:draw()
    love.graphics.setColor(0, 1, 0) -- Green color like original game

    -- Draw each pixel that still exists
    for y = 1, self.height / self.pixelSize do
        for x = 1, self.width / self.pixelSize do
            if self.pixels[y][x] == 1 then
                love.graphics.rectangle(
                    'fill',
                    self.x + (x - 1) * self.pixelSize,
                    self.y + (y - 1) * self.pixelSize,
                    self.pixelSize,
                    self.pixelSize
                )
            end
        end
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

return Barrier
