player = {}
local sprites, frame, tempo, intervalo
local scaleX, scaleY = 0.5, 0.5
local velocidade = 300
local direcao = "baixo"
local background, bgScale, bgW, bgH
local debugMode = false
local podeInteragir = false
local objetoProximo = nil

local interacoes = {
    peixe = false,
    borboleta = false,
    passaro = false
}

local visivel = true 

function initPlayer()
    x, y = 2000, 700

    sprites = {
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
        },
        baixo = {
            love.graphics.newImage("assets/personagem/mimiFront1.png"),
            love.graphics.newImage("assets/personagem/mimiFront2.png"),
            love.graphics.newImage("assets/personagem/mimiFront1.png"),
            love.graphics.newImage("assets/personagem/mimiFront3.png")
        },
        cima = {
            love.graphics.newImage("assets/personagem/mimiBack1.png"),
            love.graphics.newImage("assets/personagem/mimiBack2.png"),
            love.graphics.newImage("assets/personagem/mimiBack1.png"),
            love.graphics.newImage("assets/personagem/mimiBack3.png")
        }
    }

    frame, tempo, intervalo = 1, 0, 0.15
    background = love.graphics.newImage("assets/cenario/Cenário.png")
    bgScale = 0.75
    bgW, bgH = background:getWidth() * bgScale, background:getHeight() * bgScale

    playerHitbox = {
        offsetX = 30,
        offsetY = 20,
        w = sprites.baixo[1]:getWidth() * scaleX - 55,
        h = sprites.baixo[1]:getHeight() * scaleY - 42
    }
end


function player.setVisible(v)
    visivel = v
end

function updatePlayer(dt, objetos)
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

    if love.keyboard.isDown("s") then
        novoY = y + velocidade * dt
        direcao = "baixo"
        andando = true
    elseif love.keyboard.isDown("w") then
        novoY = y - velocidade * dt
        direcao = "cima"
        andando = true
    end

    
    novoX = math.max(0, math.min(novoX, bgW - playerHitbox.w))
    novoY = math.max(0, math.min(novoY, bgH - playerHitbox.h))

    x, y = novoX, novoY

    -- animacao
    if andando then
        tempo = tempo + dt
        if tempo > intervalo then
            tempo = 0
            frame = frame % #sprites[direcao] + 1
        end
    else
        frame = 1
    end

    podeInteragir = false
    objetoProximo = nil

    for _, obj in ipairs(objetos) do
        if obj.isInterativo and not obj.interagido then
            local dx = x - obj.x
            local dy = y - obj.y
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist < 500 then
                podeInteragir = true
                objetoProximo = obj
                break
            end
        end
    end


    if love.keyboard.isDown("e") and objetoProximo then
        if not objetoProximo.interagido then
            objetoProximo:interagir()
            objetoProximo.interagido = true
            interacoes[objetoProximo.tipo] = true
        end

        if interacoes.peixe and interacoes.borboleta and interacoes.passaro then
            iniciarMinigame()
        end
    end
end

function drawMundo(objetos)
    if not visivel then visivel = true end 

    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    local camX = math.max(0, math.min(x - screenW/2, bgW - screenW))
    local camY = math.max(0, math.min(y - screenH/2, bgH - screenH))

    love.graphics.push()
    love.graphics.translate(-camX, -camY)
    love.graphics.draw(background, 0, 0, 0, bgScale, bgScale)

    
    for _, obj in ipairs(objetos) do obj:draw(bgScale) end

    -- player
    love.graphics.setColor(1,1,1)
    love.graphics.draw(sprites[direcao][frame], x, y, 0, scaleX, scaleY)

    love.graphics.pop()

    if podeInteragir and objetoProximo then
        love.graphics.printf(
            "Pressione [E] para interagir com " .. objetoProximo.tipo,
            0, love.graphics.getHeight()-80,
            love.graphics.getWidth(),
            "center"
        )
    end
end

function getPlayerPosition()
    return x, y
end

return player
