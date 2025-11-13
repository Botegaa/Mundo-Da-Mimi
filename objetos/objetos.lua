local Arvore = require("objetos.arvore")
local Pedra = require("objetos.pedra")
local Borboleta = require("objetos.borboleta")
local Passaro = require("objetos.passaro")
local Lago = require("objetos.lago")
local Bella = require("objetos.bella")

function initObjetos()
    local lago = Lago(680, 480)          
    local peixe = lago:getPeixe()        

    objetos = {
        lago,                            
        peixe,                          
        Borboleta(2050, 1500),
        Pedra.l(3127, 1750),
        Passaro(3127, 1750, true),
    }
end


function love.update(dt)
    for _, obj in ipairs(objetos) do
        if obj.update then
            obj:update(dt)
        end
    end
end

function love.draw()
    for _, obj in ipairs(objetos) do
        if obj.draw then
            obj:draw()
        end
    end
end





function _G.bellaAparecer()
    table.insert(objetos, Bella)  
end