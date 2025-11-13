local Objeto = require("objetos.objeto")

local Arvore = {}

function Arvore.L(x, y)
    return Objeto:new("assets/cenario/Tree 1.png", x, y, {
        offsetX = 90,
        offsetY = 140,
        w = 70,
        h = 55
    })
end
function Arvore.R(x, y)
    return Objeto:new("assets/cenario/Árvores/Tree 2.png", x, y, {
        offsetX = 90,
        offsetY = 140,
        w = 70,
        h = 55
    })
end

return Arvore
