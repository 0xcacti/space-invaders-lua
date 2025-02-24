local Object = require("lib.classic")
local Bullet = Object:extend()

function Bullet:new(x, y, is_enemy)
    Bullet.super.new(self)
    self.is_enemy = is_enemy
    self.x = x
    self.y = y
    if is_enemy then
        self.speed = 300
    else
        self.speed = 700
    end
    self.is_dead = false
    return self
end

return Bullet
