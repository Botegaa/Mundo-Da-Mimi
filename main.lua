require("objetos.objetos")
require("player.player")

-- Estado atual do jogo
local estado = "mundo"
local desatencao = require("minigame desatencao.minigame")

-- Função global para iniciar o minigame
function iniciarMinigame()
    estado = "minigame"
    desatencao.reset()
end
_G.iniciarMinigame = iniciarMinigame

-- Função global para voltar ao mundo
function voltarAoMundo()
    estado = "mundo"
     
end
_G.voltarAoMundo = voltarAoMundo

-- Inicialização
function love.load()
    love.keyboard.setKeyRepeat(true)
    love.window.setMode(0, 0, {fullscreen = false})
    initPlayer()
    initObjetos()
end

-- Atualização principal
function love.update(dt)
    if estado == "mundo" then
        for _, obj in ipairs(objetos) do
            if obj.update then obj:update(dt) end
        end
        updatePlayer(dt, objetos)

    elseif estado == "minigame" then
        desatencao.update(dt)
    end
end

-- Entradas do teclado
function love.keypressed(key)
    if estado == "mundo" then
        if key == "r" then
            iniciarMinigame()
        end
    elseif estado == "minigame" then
        if key == "escape" then
            voltarAoMundo()
        else
            desatencao.keypressed(key)
        end
    end
end

-- Renderização
function love.draw()
    if estado == "mundo" then
        for _, obj in ipairs(objetos) do
            if obj.draw then obj:draw() end
        end
        drawMundo(objetos)
        love.graphics.setColor(1, 1, 1)


    elseif estado == "minigame" then
        desatencao.draw()
    end
end
