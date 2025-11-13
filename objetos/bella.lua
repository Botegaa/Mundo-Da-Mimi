local Bella = {
    x = 2100,
    y = 700,
    tipo = "bella",
    interagido = false,
    isInterativo = true,
    withOutline = true
}

Bella.img = love.graphics.newImage("assets/bella/new bella front1.png")

_G.fimDoJogo = false

function Bella:getHitbox()
    return self.x, self.y, self.img:getWidth(), self.img:getHeight()
end

function Bella:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

function Bella:interagir()
    if not self.interagido then
        self.interagido = true
        _G.fimDoJogo = true
    end
end

return Bella
