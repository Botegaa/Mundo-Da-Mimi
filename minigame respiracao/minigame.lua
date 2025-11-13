local respiracao = {}

local fase = "inspirar"
local tempo = 0

local duracao = {
    inspirar = 4,
    segurar  = 4,
    expirar  = 6
}

local contador = 0

local frames = {}
local currentFrame = 1
local totalFrames = 15

local calma = 0
local calmaMax = 100
local acabouRespirar = false

local centerX, centerY

local scale = 0.8


local bgImage

function respiracao.load()
  
    bgImage = love.graphics.newImage("assets/respiracao/Breathe_BG.png")

    for i = 1, totalFrames do
        frames[i] = love.graphics.newImage("assets/respiracao/Breathe" .. i .. ".png")
    end

    centerX = love.graphics.getWidth() / 2
    centerY = love.graphics.getHeight() / 2

    resetFase()
end

local function tamanhoPorFase()
    if fase == "inspirar" then
        return currentFrame
    elseif fase == "segurar" then
        return totalFrames
    elseif fase == "expirar" then
        return (totalFrames - currentFrame) + 1
    end
end

function resetFase()
    tempo = 0
    currentFrame = 1
    contador = duracao[fase]
end

function respiracao.update(dt)
    if acabouRespirar then return end

    if fase == "inspirar" then
        if not love.keyboard.isDown("space") then resetFase(); return end
    elseif fase == "segurar" then
        if not love.keyboard.isDown("c") then resetFase(); return end
    elseif fase == "expirar" then
        if not love.keyboard.isDown("v") then resetFase(); return end
    end

    tempo = tempo + dt

    contador = duracao[fase] - tempo
    if contador < 0 then contador = 0 end
    contador = math.ceil(contador)

    local progresso = tempo / duracao[fase]
    currentFrame = math.floor(progresso * totalFrames)
    if currentFrame < 1 then currentFrame = 1 end
    if currentFrame > totalFrames then currentFrame = totalFrames end

    if tempo >= duracao[fase] then
        if fase == "inspirar" then
            fase = "segurar"
        elseif fase == "segurar" then
            fase = "expirar"
        elseif fase == "expirar" then
            calma = calma + 25
            if calma >= calmaMax then
                acabouRespirar = true
            end
            fase = "inspirar"
        end
        resetFase()
    end
end

function respiracao.keypressed(key)
    if acabouRespirar and key == "return" then
        return "fim"
    end
end

function respiracao.draw()

    if bgImage then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(
            bgImage,
            0, 0, 0,
            love.graphics.getWidth() / bgImage:getWidth(),
            love.graphics.getHeight() / bgImage:getHeight()
        )
    end

    love.graphics.setColor(1,1,1)

    local img = frames[tamanhoPorFase()]
    if img then
        local iw = img:getWidth()
        local ih = img:getHeight()

        love.graphics.draw(
            img,
            centerX - (iw * scale) / 2,
            centerY - (ih * scale) / 2,
            0,
            scale,
            scale
        )
    end

    love.graphics.printf(
        string.format("Fase: %s   |   %d segundos\n[ESPACO] inspirar  |  [C] segurar  |  [V] expirar",
        fase, contador),
        0, 40,
        love.graphics.getWidth(),
        "center"
    )

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", 50, 50, 200, 20)

    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", 50, 50, 200 * (calma / calmaMax), 20)

    love.graphics.setColor(1,1,1)

    if acabouRespirar then
        love.graphics.printf(
            "Respiracao concluida.\nPressione ENTER para continuar.",
            0,
            love.graphics.getHeight()/2 + 180,
            love.graphics.getWidth(),
            "center"
        )
    end
end

function respiracao.isFinished()
    return acabouRespirar
end

function respiracao.start()
    acabouRespirar = false
    calma = 0
    fase = "inspirar"
    resetFase()
end

return respiracao
