local criarArvore = require("objetos.arvore")
local Pedra = require("objetos.pedra")

function initObjetos()
    objetos = {
        criarArvore(1900, 500),
        Pedra.l(500, 1300),
        Pedra.m(1000, 1000),
        criarArvore(1200,700),
        Pedra.m(200, 1000)
    }
end