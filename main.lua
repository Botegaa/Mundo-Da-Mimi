require("objetos.objetos")
require("player.player")

local desatencao   = require("minigame desatencao.minigame")
local pensamentos  = require("minigame pensamentos.minigame")
local respiracao   = require("minigame respiracao.minigame")
local Dialogo      = require("objetos.dialogo")

local estado = "mundo"


local falas1 = {
    "Bella? Bella, onde voce esta?",
    "Bella?! BELLA?!",
    "Ela se foi para sempre, Mimi... Voce a perdeu por sua culpa...",
    "Se voce nao fosse tao distraida... Se voce prestasse atencao... Bella estaria aqui!",
    "Nao... nao... isso nao pode estar acontecendo! Bella, volta!"
}


local falasRespiracao = {
    "Mimi, minha querida, respire comigo. Voce nao esta sozinha.",
    "Mas... mas eu perdi a Bella! Eu sou terrivel! Nao consigo fazer nada direito!",
    "Crianca, todos nos cometemos erros.",
    "O importante agora e acalmar seu coracao...",
    "Inspire pelo nariz contando ate 4...",
    "Segure por 4...",
    "Expire contando ate 6..."
}


local falasBellaFinal = {
    "Eu... eu estou me sentindo um pouco melhor...",
    "Muito bem! Agora sua mente esta mais clara.",
    "Voce consegue procurar onde a Belinha esta?",
    "Consigo sim! Acho que ela esta aqui perto."
}


function iniciarMinigame()
    estado = "desatencao"
    desatencao.reset()
end
_G.iniciarMinigame = iniciarMinigame


local function iniciarDialogo1()
    estado = "dialogo1"
    Dialogo.start(falas1)

    Dialogo.onFinish = function()
        estado = "pensamentos"
        pensamentos.start()
    end
end


local function iniciarDialogoRespiracao()
    estado = "dialogo_respiracao"
    Dialogo.start(falasRespiracao)

    Dialogo.onFinish = function()
        estado = "respiracao"
        respiracao.load()
    end
end


local function iniciarDialogoBellaFinal()
    estado = "dialogo_bella"
    Dialogo.start(falasBellaFinal)

    Dialogo.onFinish = function()
        estado = "mundo"
        if _G.bellaAparecer then
            _G.bellaAparecer()
        end
    end
end

_G.fimDoJogo = false




function love.load()
    love.keyboard.setKeyRepeat(true)
    love.window.setMode(0, 0, {fullscreen=false})

    initPlayer()
    initObjetos()
end


function love.update(dt)

    if _G.fimDoJogo then return end 

    if estado == "mundo" then
        for _, obj in ipairs(objetos) do
            if obj.update then obj:update(dt) end
        end
        updatePlayer(dt, objetos)

    elseif estado == "desatencao" then
        desatencao.update(dt)
        if desatencao.isFinished() then
            iniciarDialogo1()
        end

    elseif estado == "dialogo1" then
        Dialogo.update(dt)

    elseif estado == "pensamentos" then
        pensamentos.update(dt)
        if pensamentos.isFinished() then
            iniciarDialogoRespiracao()
        end

    elseif estado == "dialogo_respiracao" then
        Dialogo.update(dt)

    elseif estado == "respiracao" then
        respiracao.update(dt)
        if respiracao.isFinished() then
            iniciarDialogoBellaFinal()
        end

    elseif estado == "dialogo_bella" then
        Dialogo.update(dt)
    end
end


function love.keypressed(key)

    if _G.fimDoJogo then return end

    -- diálogos
    if estado == "dialogo1" or estado == "dialogo_respiracao" or estado == "dialogo_bella" then
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
        if respiracao.keypressed(key) == "fim" then
            iniciarDialogoBellaFinal()
        end
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

    elseif estado == "dialogo1" then
        drawMundo(objetos)
        Dialogo.draw()

    elseif estado == "pensamentos" then
        pensamentos.draw()

    elseif estado == "dialogo_respiracao" then
        drawMundo(objetos)
        Dialogo.draw()

    elseif estado == "respiracao" then
        respiracao.draw()

    elseif estado == "dialogo_bella" then
        drawMundo(objetos)
        Dialogo.draw()
    end

 
    if _G.fimDoJogo then
        love.graphics.setColor(0,0,0,0.65)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
        love.graphics.setColor(1,1,1)
        love.graphics.printf(
            "Mimi encontrou a Bella.\nFim da demo ",
            0, love.graphics.getHeight()/2 - 20,
            love.graphics.getWidth(),
            "center"
        )
    end
end
