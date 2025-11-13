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


function respiracao.reset()
    fase = "inspirar"
    tempo = 0
    contador = duracao[fase]
    currentFrame = 1
    calma = 0
    acabouRespirar = false
end


function respiracao.start()
    respiracao.reset()
end


function respiracao.load()
    for i = 1, totalFrames do
        frames[i] = love.graphics.newImage("assets/respiracao/Breathe" .. i .. ".png")
    end

    centerX = love.graphics.getWidth() / 2
    centerY = love.graphics.getHeight() / 2
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

local function resetFaseInterno()
    tempo = 0
    currentFrame = 1
    contador = duracao[fase]
end


function respiracao.update(dt)
    if acabouRespirar then return end

  
    if fase == "inspirar" then
        if not love.keyboard.isDown("space") then resetFaseInterno() return end
    elseif fase == "segurar" then
        if not love.keyboard.isDown("c") then resetFaseInterno() return end
    elseif fase == "expirar" then
        if not love.keyboard.isDown("v") then resetFaseInterno() return end
    end

    tempo = tempo + dt
    contador = math.max(0, math.ceil(duracao[fase] - tempo))

  
    local progresso = tempo / duracao[fase]
    currentFrame = math.floor(progresso * totalFrames)
    currentFrame = math.max(1, math.min(currentFrame, totalFrames))

    
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

        resetFaseInterno()
    end
end


function respiracao.keypressed(key)
    if acabouRespirar and key == "return" then
        return "fim"
    end
end


function respiracao.draw()
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
        string.format(
            "Fase: %s   |   %d segundos\n[ESPAÇO] inspirar  |  [C] segurar  |  [V] expirar",
            fase, contador
        ),
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
            "Respiração concluída.\nPressione ENTER para continuar.",
            0,
            love.graphics.getHeight()/2 + 180,
            love.graphics.getWidth(),
            "center"
        )
    end
end

return respiracao
