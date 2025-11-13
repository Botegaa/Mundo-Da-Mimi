require("objetos.objetos")
require("player.player")

local desatencao = require("minigame desatencao.minigame")
local pensamentos = require("minigame pensamentos.minigame")
local Dialogo = require("objetos.dialogo")

local estado = "mundo"
local falas = {
    "Bella? Bella, onde voce esta?",
    "Bella?! BELLA?!",
    "Ela se foi para sempre, Mimi... Voce a perdeu por sua culpa...",
    "Se voce nao fosse tao distraida... Se voce prestasse atencao... Bella estaria aqui!",
    "Nao... nao... isso nao pode estar acontecendo! Bella, volta!"
}

function iniciarMinigame()
    estado = "desatencao"
    desatencao.reset()
end
_G.iniciarMinigame = iniciarMinigame

local function iniciarDialogo()
    estado = "dialogo"
    Dialogo.start(falas)

    Dialogo.onFinish = function()
        estado = "pensamentos"
        pensamentos.start()
    end
end

function voltarAoMundo()
    estado = "mundo"
end
_G.voltarAoMundo = voltarAoMundo

function love.load()
    love.keyboard.setKeyRepeat(true)
    love.window.setMode(0, 0, {fullscreen = false})

    initPlayer()
    initObjetos()
end

function love.update(dt)
    if estado == "mundo" then
        for _, obj in ipairs(objetos) do
            if obj.update then obj:update(dt) end
        end
        updatePlayer(dt, objetos)

    elseif estado == "desatencao" then
        desatencao.update(dt)

        if desatencao.isFinished() then
    iniciarDialogo()
end

    elseif estado == "dialogo" then
        Dialogo.update(dt)

    elseif estado == "pensamentos" then
        pensamentos.update(dt)
    end
end

function love.keypressed(key)
    if estado == "dialogo" then
        if key == "return" or key == "space" then
            Dialogo.next()
        end
        return
    end

    if estado == "desatencao" then
        desatencao.keypressed(key)
        return
    end

    if estado == "pensamentos" then
        pensamentos.keypressed(key)
        return
    end
end

function love.draw()
    if estado == "mundo" then
        for _, obj in ipairs(objetos) do
            if obj.draw then obj:draw() end
        end
        drawMundo(objetos)

    elseif estado == "desatencao" then
        desatencao.draw()

    elseif estado == "dialogo" then
        drawMundo(objetos) -- mantém o mundo visível
        Dialogo.draw()

    elseif estado == "pensamentos" then
        pensamentos.draw()
    end
end
