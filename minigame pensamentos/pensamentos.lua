local Pensamentos = {}
Pensamentos.lista = {}

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
        table.insert(Pensamentos.lista, {
            x = math.random(0, love.graphics.getWidth() - 30),
            y = -30,
            w = 30,
            h = 30,
            speed = speedBase + math.random(-20, 20)
        })
    end
end

-- recebe yBasePlayer,
function Pensamentos.update(dt, yBasePlayer)
    spawnTimer = spawnTimer + dt
    if spawnTimer > spawnInterval then
        Pensamentos.spawn()
        spawnTimer = 0
    end

    for i = #Pensamentos.lista, 1, -1 do
        local p = Pensamentos.lista[i]
        p.y = p.y + p.speed * dt
        -- Remove quando passar da base do player
        if p.y > yBasePlayer then
            table.remove(Pensamentos.lista, i)
        end
    end
end

function Pensamentos.draw()
    love.graphics.setColor(0, 0, 0)
    for _, p in ipairs(Pensamentos.lista) do
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
    end
    love.graphics.setColor(1, 1, 1)
end

function Pensamentos.reset()
    Pensamentos.lista = {}
    spawnTimer = 0
    spawnInterval = 0.8
    speedBase = 160
    dificuldade = 1
end

return Pensamentos

