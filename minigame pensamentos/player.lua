local player = {}

local x, y = 300, 800
local velocidade = 300
local direcao = "direita"
local frame, tempo, intervalo = 1, 0, 0.15
local scaleX, scaleY = 0.5, 0.5

local debugMode = false
local invencivel = false
local invencivelTimer = 0
local piscaIntervalo = 0.12
local piscaTimer = 0
local visivel = true

local sprites = {
    direita = {
            love.graphics.newImage("assets/personagem/mimiRight3.png"),
            love.graphics.newImage("assets/personagem/mimiRight2.png"),
            love.graphics.newImage("assets/personagem/mimiRight3.png"),
            love.graphics.newImage("assets/personagem/mimiRight1.png")
    },
    esquerda = {
            love.graphics.newImage("assets/personagem/mimiLeft1.png"),
            love.graphics.newImage("assets/personagem/mimiLeft2.png"),
            love.graphics.newImage("assets/personagem/mimiLeft1.png"),
            love.graphics.newImage("assets/personagem/mimiLeft3.png")
    }
}

local function calcHitbox()
    local sw = sprites.direita[1]:getWidth()
    local sh = sprites.direita[1]:getHeight()
    return {
        offsetX = 40,
        offsetY = 30,
        w = sw * scaleX - 70,
        h = sh * scaleY - 50
    }
end

local playerHitbox = calcHitbox()

function player.update(dt)
    local andando = false
    local novoX, novoY = x, y

    if love.keyboard.isDown("d") then
        novoX = x + velocidade * dt
        direcao = "direita"
        andando = true
    elseif love.keyboard.isDown("a") then
        novoX = x - velocidade * dt
        direcao = "esquerda"
        andando = true
    end

    novoX = math.max(0, math.min(novoX, love.graphics.getWidth() - playerHitbox.w))

    if andando then
        tempo = tempo + dt
        if tempo > intervalo then
            tempo = 0
            frame = frame % #sprites[direcao] + 1
        end
    else
        frame = 1
        tempo = 0
    end

    x, y = novoX, novoY

    -- Invencibilidade piscando
    if invencivel then
        invencivelTimer = invencivelTimer - dt
        piscaTimer = piscaTimer + dt
        if piscaTimer > piscaIntervalo then
            visivel = not visivel
            piscaTimer = 0
        end
        if invencivelTimer <= 0 then
            invencivel = false
            visivel = true
        end
    end
end

function player.draw()
    if not visivel then return end

    love.graphics.setColor(1,1,1)
    local sprite = sprites[direcao][frame]
    love.graphics.draw(sprite, x, y, 0, scaleX, scaleY)

    if debugMode then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle(
            "line",
            x + playerHitbox.offsetX,
            y + playerHitbox.offsetY,
            playerHitbox.w,
            playerHitbox.h
        )
        love.graphics.setColor(1, 1, 1)
    end
end

function player.getHitbox()
    return
        x + playerHitbox.offsetX,
        y + playerHitbox.offsetY,
        playerHitbox.w,
        playerHitbox.h
end

function player.reset()
    x, y = 300, 800
    direcao = "direita"
    frame = 1
    tempo = 0
    invencivel = false
    invencivelTimer = 0
    piscaTimer = 0
    visivel = true
end

function player.toggleDebug()
    debugMode = not debugMode
end

function player.isInvencivel()
    return invencivel
end

function player.setInvencivel(duracao)
    invencivel = true
    invencivelTimer = duracao or 1.2
    piscaTimer = 0
    visivel = true
end

return player
