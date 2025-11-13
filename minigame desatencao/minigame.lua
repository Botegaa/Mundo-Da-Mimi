local Desatencao = {}



local popups = {}
local keys = {"w", "a", "s", "d"}

local spawnTimer = 0
local spawnInterval = 1.2

local desatencao = 0
local maxDesatencao = 100

local tempoTotal = 30
local tempoRestante = tempoTotal
local finalizado = false


local popupW = 190
local popupH = 60



local imgCelular
local celularScale = 0.55

local celularX = 0
local celularY = 0
local celularW = 0
local celularH = 0


local telaX, telaY, telaW, telaH

local notifA = {}
local notifS = {}

local notifCount = { A = 2, S = 2 }



function Desatencao.load()
    imgCelular = love.graphics.newImage("assets/desatencao/telefone.png")

    local originalW = imgCelular:getWidth()
    local originalH = imgCelular:getHeight()

    celularW = originalW * celularScale
    celularH = originalH * celularScale

    celularX = 70
    celularY = love.graphics.getHeight()/2 - celularH/2


    telaX = celularX + 55
    telaY = celularY + 90
    telaW = celularW - 110
    telaH = celularH - 180

    for i = 1, notifCount.A do
        notifA[i] = love.graphics.newImage("assets/desatencao/A1_Notification" .. i .. ".png")
    end

    for i = 1, notifCount.S do
        notifS[i] = love.graphics.newImage("assets/desatencao/S1_Notification" .. i .. ".png")
    end
end



function Desatencao.reset()
    if not imgCelular then
        Desatencao.load()
    end

    popups = {}
    spawnTimer = 0
    desatencao = 0
    spawnInterval = 2
    tempoRestante = tempoTotal
    finalizado = false
end




local function spawnPopup()
    local tipo = math.random() < 0.5 and "A" or "S"

    table.insert(popups, {
        x = math.random(celularW),
        y = math.random(celularH),
        tipo = tipo,
        frame = 1,
        frameTimer = 0,
        tecla = keys[math.random(#keys)]
       
    })
end



function Desatencao.update(dt)
    if finalizado then return end

    tempoRestante = tempoRestante - dt
    if tempoRestante <= 0 then
        finalizado = true
        if _G.voltarAoMundo then _G.voltarAoMundo() end
        return
    end

    spawnTimer = spawnTimer + dt
    if spawnTimer > spawnInterval then
        for i = 1, math.random(1) do
            spawnPopup()
        end

        spawnTimer = 0
        spawnInterval = math.max(0.25, spawnInterval - 0.03)
    end

    for _, p in ipairs(popups) do
        p.frameTimer = p.frameTimer + dt

        if p.frameTimer >= 0.15 then
            p.frame = p.frame + 1
            p.frameTimer = 0

            local maxFrames = (p.tipo == "A") and notifCount.A or notifCount.S
            if p.frame > maxFrames then
                p.frame = 1
            end
        end
    end


    desatencao = math.min(maxDesatencao, desatencao + dt * 1.2)
end



function Desatencao.keypressed(key)
    if finalizado then return end

    for i = #popups, 1, -1 do
        local p = popups[i]
        if key == p.tecla then
            table.remove(popups, i)  
            break
        end
    end
end



function Desatencao.draw()

    love.graphics.setColor(1,1,1)
    love.graphics.draw(imgCelular, celularX, celularY, 0, celularScale, celularScale)

  
    for _, p in ipairs(popups) do
        local img = nil

        if p.tipo == "A" then img = notifA[p.frame]
        else img = notifS[p.frame] end

        if img then
            love.graphics.setColor(1,1,1, 0.9)
            love.graphics.draw(img, p.x, p.y, 0, popupW / img:getWidth(), popupH / img:getHeight())
        end
    end

    love.graphics.setColor(0,0,0)
    love.graphics.printf("Tempo restante: "..math.ceil(tempoRestante),
        0, 40, love.graphics.getWidth(), "center")

    love.graphics.setColor(1,1,1)
end



function Desatencao.isFinished()
    return finalizado
end

return Desatencao
