require("objetos.objetos")
require("player.player")

local desatencao = require("minigame desatencao.minigame")
local pensamentos = require("minigame pensamentos.minigame")
local respiracao = require("minigame respiracao.minigame")
local Dialogo = require("objetos.dialogo")

local estado = "mundo"

local falasDesatencao = {
    "Bella? Bella, onde voce esta?",
    "Bella?! BELLA?!",
    "Ela se foi para sempre, Mimi... Voce a perdeu por sua culpa...",
    "Se voce nao fosse tao distraida... Se voce prestasse atencao... Bella estaria aqui!",
    "Nao... nao... isso nao pode estar acontecendo! Bella, volta!"
}

local falasRespiracao = {
    "Mimi, minha querida, respire comigo. Voce nao esta sozinha.",
    "Mas... mas eu perdi a Bella! Eu sou terrivel! Nao consigo fazer nada direito!",
    "Crianca, todos nos cometemos erros. O importante agora eh acalmar seu coracao para pensar com clareza.",
    "Vamos fazer juntos: inspire por 4... segure por 4... e expire por 6..."
}

function iniciarMinigame()
    estado = "desatencao"
    desatencao.reset()
end
_G.iniciarMinigame = iniciarMinigame

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

        -- APENAS ADICIONADO PROTEÇÃO:
        if desatencao.isFinished and desatencao.isFinished() then
            estado = "dialogo"
            Dialogo.start(falasDesatencao)

            Dialogo.onFinish = function()
                estado = "pensamentos"
                pensamentos.start()
            end
        end

    elseif estado == "dialogo" then
        Dialogo.update(dt)

    elseif estado == "pensamentos" then
        pensamentos.update(dt)

        if pensamentos.isFinished and pensamentos.isFinished() then
            estado = "dialogo_resp"
            Dialogo.start(falasRespiracao)

            Dialogo.onFinish = function()
                estado = "respiracao"
                respiracao.load()
            end
        end

    elseif estado == "dialogo_resp" then
        Dialogo.update(dt)

    elseif estado == "respiracao" then
        respiracao.update(dt)
    end
end

function love.keypressed(key)

    if estado == "dialogo" or estado == "dialogo_resp" then
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

    if estado == "respiracao" then
        local r = respiracao.keypressed(key)
        if r == "fim" then
            voltarAoMundo()
        end
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

    elseif estado == "dialogo" or estado == "dialogo_resp" then
        drawMundo(objetos)
        Dialogo.draw()

    elseif estado == "pensamentos" then
        pensamentos.draw()

    elseif estado == "respiracao" then
        respiracao.draw()
    end
end
