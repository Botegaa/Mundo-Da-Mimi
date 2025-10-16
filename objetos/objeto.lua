local Objeto = {}
Objeto.__index = Objeto

function Objeto:new(imgPath, x, y, hitbox)
    local self = setmetatable({}, Objeto)
    self.img = love.graphics.newImage(imgPath)
    self.x, self.y = x, y
    self.hitboxOffsetX = hitbox.offsetX or 0
    self.hitboxOffsetY = hitbox.offsetY or 0
    self.hitboxW = hitbox.w or self.img:getWidth()
    self.hitboxH = hitbox.h or self.img:getHeight()
    self.drawOffsetY = hitbox.drawOffsetY or 0
    return self
end

function Objeto:getHitbox()
    return self.x + self.hitboxOffsetX,
           self.y + self.hitboxOffsetY,
           self.hitboxW,
           self.hitboxH
end

function Objeto:draw(bgScale)
    love.graphics.draw(self.img, self.x, self.y + self.drawOffsetY, 0, bgScale, bgScale)
end

return Objeto