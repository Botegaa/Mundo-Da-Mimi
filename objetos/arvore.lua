local Objeto = require("objetos.objeto")

local function criarArvore(x, y)
    return Objeto:new("assets/cenario/Tree 1.png", x, y, {
        offsetX = 90,
        offsetY = 140,
        w = 70,
        h = 55
    })
end

return criarArvore