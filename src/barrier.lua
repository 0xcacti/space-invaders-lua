local Object = require('lib.classic')
local Barrier = Object:extend()

function Barrier:new(x, y)
    Barrier.super.new(self)
    self.height = 14
    self.width = 28
    self.x = x
    self.y = y
    self.pixelSize = 4

    -- bitmap
    self.bitmap = {}

    -- fill the bitmap with 1s
    for r = 1, self.height do
        self.bitmap[r] = {}
        for c = 1, self.width do
            self.bitmap[r][c] = 1
        end
    end

    local arch_width = 8
    local arch_height = 8
    local arch_start = math.floor((self.width - arch_width) / 2)

    for r = arch_height, self.height do
        for c = arch_start, arch_start + arch_width + 1 do
            self.bitmap[r][c] = 0
        end
    end

    self.bitmap[1][1] = 0
    self.bitmap[1][2] = 0
    self.bitmap[2][1] = 0
    self.bitmap[2][2] = 0
    self.bitmap[3][1] = 0
    self.bitmap[1][3] = 0

    self.bitmap[1][self.width] = 0
    self.bitmap[1][self.width - 1] = 0
    self.bitmap[2][self.width] = 0
    self.bitmap[2][self.width - 1] = 0
    self.bitmap[3][self.width] = 0
    self.bitmap[1][self.width - 2] = 0

    self.bitmap[arch_height][arch_start] = 1
    self.bitmap[arch_height][arch_start + arch_width + 1] = 1
    self.bitmap[arch_height][arch_start + 1] = 1
    self.bitmap[arch_height][arch_start + arch_width] = 1
    self.bitmap[arch_height + 1][arch_start] = 1
    self.bitmap[arch_height + 1][arch_start + arch_width + 1] = 1


    self.quadrantWidth = math.floor(self.width / 2)
    self.quadrantHeight = math.floor(self.height / 2)
    self.quadrants = {
        { active = true, hits = 0 },
        { active = true, hits = 0 },
        { active = true, hits = 0 },
        { active = true, hits = 0 }
    }
    self.maxHitsPerQuadrant = 5
    self.activeQuadrants = 4
end

function Barrier:checkCollision(bullet)
    local bulletX = math.floor((bullet.x - self.x) / self.pixelSize) + 1
    local bulletY = math.floor((bullet.y - self.y) / self.pixelSize) + 1

    if bulletX >= 1 and bulletX <= self.width and
        bulletY >= 1 and bulletY <= self.height then
        if self.bitmap[bulletY][bulletX] == 1 then
            self:damage(bulletX, bulletY)
            return true
        end
    end
    return false
end

function Barrier:damage(x, y)
    local quadX = x > self.quadrantWidth and 2 or 1
    local quadY = y > self.quadrantHeight and 2 or 1
    local quadIndex = (quadY - 1) * 2 + quadX

    if not self.quadrants[quadIndex].active then return end

    local damageRadius = 4
    local pixelsDamaged = 0
    for dy = -damageRadius, damageRadius do
        for dx = -damageRadius, damageRadius do
            local newY = y + dy
            local newX = x + dx
            if newX >= 1 and newX <= self.width and
                newY >= 1 and newY <= self.height then
                if self.bitmap[newY][newX] == 1 and math.random() > 0.5 then
                    self.bitmap[newY][newX] = 0
                    pixelsDamaged = pixelsDamaged + 1
                end
            end
        end
    end

    -- Update quadrant damage (count hits based on actual damage)
    if pixelsDamaged > 0 then
        self.quadrants[quadIndex].hits = self.quadrants[quadIndex].hits + 1
        if self.quadrants[quadIndex].hits >= self.maxHitsPerQuadrant then
            self:destroyQuadrant(quadIndex)
        end
    end
end

function Barrier:destroyQuadrant(index)
    if not self.quadrants[index].active then return end

    self.quadrants[index].active = false
    self.activeQuadrants = self.activeQuadrants - 1

    local startX = (index % 2 == 0) and self.quadrantWidth + 1 or 1
    local startY = (index > 2) and self.quadrantHeight + 1 or 1
    local endX = startX + self.quadrantWidth - 1
    local endY = startY + self.quadrantHeight - 1

    for y = startY, endY do
        for x = startX, endX do
            self.bitmap[y][x] = 0
        end
    end
end

function Barrier:isDestroyed()
    return self.activeQuadrants <= 0
end

function Barrier:draw()
    if self.activeQuadrants <= 0 then return end

    love.graphics.setColor(0, 1, 0)
    for y = 1, self.height do
        for x = 1, self.width do
            if self.bitmap[y][x] == 1 then
                love.graphics.rectangle("fill",
                    self.x + (x - 1) * self.pixelSize,
                    self.y + (y - 1) * self.pixelSize,
                    self.pixelSize, self.pixelSize)
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

return Barrier
