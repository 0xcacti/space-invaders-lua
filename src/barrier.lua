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
    local arch_start_width = 3 
    local arch_end_width = 11
    local arch_height = 8
    local arch_start = math.floor((self.width - arch_width) / 2)

    for r = arch_height, self.height do 
        for c = arch_start , arch_start + arch_width + 1 do 
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




end

function Barrier:draw()
    love.graphics.setColor(0, 1, 0) -- Classic green color
    
    for y = 1, self.height do
        for x = 1, self.width do
            if self.bitmap[y][x] == 1 then
                love.graphics.rectangle("fill", 
                    self.x + (x-1) * self.pixelSize, 
                    self.y + (y-1) * self.pixelSize, 
                    self.pixelSize, self.pixelSize)
            end
        end
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1)
end


return Barrier


--[[ 

0001111111111111111111111000
0011111111111111111111111100
0111111111111111111111111110
1111111111111111111111111111
1111111111111111111111111111
1111111111110001111111111111
1111111111100000111111111111
1111111111000000011111111111
1111111110000000001111111111
1111111100000000000111111111
1111111100000000000111111111
1111111100000000000111111111
1111111100000000000111111111
1111111100000000000111111111



]]--
