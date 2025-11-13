local Objeto = require("objetos.objeto")
local Peixe  = require("objetos.peixe")

local function Lago(x, y)
    local path = "assets/cenario/Lago.png"
    local img = love.graphics.newImage(path)

    local lago = Objeto:new(path, x, y, {
        offsetX = 0,
        offsetY = 0,
        w = 720,
        h = 500
    })
    lago.img = img

    
    local peixe = Peixe:new(x + 300, y + 100)
    lago.peixe = peixe

    function lago:update(dt)
        local px, py = getPlayerPosition()
        peixe:update(dt, px, py)
    end

    function lago:draw(bgScale)
        love.graphics.draw(self.img, self.x, self.y, 0, bgScale or 1, bgScale or 1)
        peixe:draw()
    end

    
    function lago:getPeixe()
        return self.peixe
    end

    return lago
end

return Lago