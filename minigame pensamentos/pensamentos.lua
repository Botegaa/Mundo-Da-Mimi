local Pensamentos = {}
Pensamentos.lista = {}

local SCALE = 0.2   


local imagens = {}
for i = 1, 8 do
    local path = string.format("assets/medo/balao_minigame_medo%d.png", i)
    imagens[i] = love.graphics.newImage(path)
end

local spawnTimer = 0
local spawnInterval = 0.8
local speedBase = 160
local dificuldade = 1

function Pensamentos.setDificuldade(novaDificuldade)
    dificuldade = novaDificuldade or 1
    spawnInterval = math.max(0.05, 0.8 / dificuldade)
    speedBase = 160 + (dificuldade * 10)
end

function Pensamentos.spawn()
    local quantidade = 1
    local extra = math.floor(math.sqrt(dificuldade) / 1.5)
    quantidade = quantidade + extra
    quantidade = math.min(quantidade, 4)

    for i = 1, quantidade do

        local img = imagens[math.random(1, #imagens)]
        local realW = img:getWidth()
        local realH = img:getHeight()

      
        local w = realW * SCALE
        local h = realH * SCALE

        table.insert(Pensamentos.lista, {
            x = math.random(0, love.graphics.getWidth() - w),
            y = -h,
            w = w,
            h = h,
            speed = speedBase + math.random(-20, 20),
            img = img
        })
    end
end

function Pensamentos.update(dt, yBasePlayer)
    spawnTimer = spawnTimer + dt
    if spawnTimer > spawnInterval then
        Pensamentos.spawn()
        spawnTimer = 0
    end

    for i = #Pensamentos.lista, 1, -1 do
        local p = Pensamentos.lista[i]
        p.y = p.y + p.speed * dt

        if p.y > yBasePlayer then
            table.remove(Pensamentos.lista, i)
        end
    end
end

function Pensamentos.draw()
    love.graphics.setColor(1, 1, 1)
    for _, p in ipairs(Pensamentos.lista) do
       
        love.graphics.draw(p.img, p.x, p.y, 0, SCALE, SCALE)
    end
end

function Pensamentos.reset()
    Pensamentos.lista = {}
    spawnTimer = 0
    spawnInterval = 0.8
    speedBase = 160
    dificuldade = 1
end

return Pensamentos
