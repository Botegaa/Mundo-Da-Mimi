local Desatencao = {}

local popups = {}
local spawnTimer = 0
local spawnInterval = 1.2
local tempoPopup = 3
local desatencao = 0
local maxDesatencao = 100
local tempoTotal = 30     
local tempoRestante = tempoTotal
local finalizado = false

local keys = {"w", "a", "s", "d"}

function Desatencao.reset()
    popups = {}
    spawnTimer = 0
    desatencao = 0
    spawnInterval = 1.2
    tempoRestante = tempoTotal
    finalizado = false
end

local function spawnPopup()
    local k = keys[math.random(#keys)]
    table.insert(popups, {
        x = math.random(120, love.graphics.getWidth() - 240),
        y = math.random(120, love.graphics.getHeight() - 240),
        tecla = k,
        timer = tempoPopup
    })
end

function Desatencao.update(dt)
    if finalizado then return end

    tempoRestante = tempoRestante - dt
    if tempoRestante <= 0 then
        finalizado = true
        
        if _G.voltarAoMundo then
            _G.voltarAoMundo()  
        end
        return
    end

    spawnTimer = spawnTimer + dt
    if spawnTimer > spawnInterval then
        local qtd = math.random(1, math.min(3, 1 + math.floor(desatencao / 25)))
        for i = 1, qtd do
            spawnPopup()
        end
        spawnTimer = 0
        spawnInterval = math.max(0.25, spawnInterval - 0.03)
    end

    for i = #popups, 1, -1 do
        local p = popups[i]
        p.timer = p.timer - dt
        if p.timer <= 0 then
            table.remove(popups, i)
            desatencao = math.min(maxDesatencao, desatencao + 8)
        end
    end

    desatencao = math.min(maxDesatencao, desatencao + dt * 1.2)
end

function Desatencao.keypressed(key)
    if finalizado and key == "r" then
        Desatencao.reset()
        return
    end

    for i = #popups, 1, -1 do
        if key == popups[i].tecla then
            table.remove(popups, i)
            desatencao = math.max(0, desatencao - 2)
            break
        end
    end
end

function Desatencao.draw()
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.rectangle("fill", 100, 100, love.graphics.getWidth()-200, love.graphics.getHeight()-200, 20, 20)

    for _, p in ipairs(popups) do
        local alpha = math.max(0.5, p.timer / tempoPopup)
        love.graphics.setColor(1, 0.7, 0.7, alpha)
        love.graphics.rectangle("fill", p.x, p.y, 120, 80, 10, 10)
        love.graphics.setColor(0.2, 0, 0)
        love.graphics.printf("Fechar ["..p.tecla:upper().."]", p.x, p.y + 25, 120, "center")
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Tempo restante: "..math.ceil(tempoRestante).."s", 0, 10, love.graphics.getWidth(), "center")

    if desatencao > 60 then
        local intensidade = (desatencao - 60) / 40
        love.graphics.setColor(1, 1, 1, intensidade * 0.2)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    if finalizado then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("TU TA LOUCA JA, R PRA COMECAR DNV.", 0, love.graphics.getHeight()/2 - 30, love.graphics.getWidth(), "center")
    end
end

return Desatencao
