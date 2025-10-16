local Objeto = require("objetos.objeto")

local Pedra = {}

function Pedra.l(x, y)
    return Objeto:new("assets/cenario/Pedra (L).png", x, y, {
        offsetX = 30,
        offsetY = 20,
        w = 150,
        h = 50
    })
end

function Pedra.m(x, y)
    return Objeto:new("assets/cenario/Pedra (M).png", x, y, {
        offsetX = 40,
        offsetY = 10,
        w = 70,
        h = 10
    })
end

return Pedra