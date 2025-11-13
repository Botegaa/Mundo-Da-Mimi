local player = require("minigame pensamentos.player")
local pensamentos = require("minigame pensamentos.pensamentos")

local Minigame = {}

local vidas = 3
local acabou = false
local dificuldade = 1
local tempoTotal = 0

local function checaColisao(px, py, pw, ph, ox, oy, ow, oh)
    return px < ox + ow and ox < px + pw and py < oy + oh and oy < py + ph
end

function Minigame.start()
    vidas = 3
    acabou = false      
    dificuldade = 1
    tempoTotal = 0
    player.reset()
    pensamentos.reset()
end

function Minigame.update(dt)
    if acabou then return end

    tempoTotal = tempoTotal + dt
    dificuldade = 1 + tempoTotal / 10
    pensamentos.setDificuldade(dificuldade)

    player.update(dt)

    local px, py, pw, ph = player.getHitbox()
    local yBasePlayer = py + ph

    pensamentos.update(dt, yBasePlayer)

    for i = #pensamentos.lista, 1, -1 do
        local p = pensamentos.lista[i]
        if checaColisao(px, py, pw, ph, p.x, p.y, p.w, p.h) then
            if not player.isInvencivel() then
                vidas = vidas - 1
                player.setInvencivel()
                table.remove(pensamentos.lista, i)

                if vidas <= 0 then
                    acabou = true
                end
            end
        end
    end
end

function Minigame.draw()
    love.graphics.clear(1, 1, 1)

    player.draw()
    pensamentos.draw()

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Vidas: " .. vidas, 10, 10)
    love.graphics.print("Dificuldade: " .. string.format("%.1f", dificuldade), 10, 30)

    if acabou then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Game Over", love.graphics.getWidth() / 2 - 40, love.graphics.getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("Pressione R para continuar...", love.graphics.getWidth() / 2 - 90, love.graphics.getHeight() / 2 + 30)
    end
end

function Minigame.keypressed(key)
    if acabou and key == "r" then
        Minigame.start()
    elseif key == "f1" then
        player.toggleDebug()
    end
end


function Minigame.isFinished()
    return acabou
end

return Minigame
