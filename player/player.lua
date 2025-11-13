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

    debugMode = false
end

local function checaColisao(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah
end

function love.keypressed(key)
    if key == "f1" then
        debugMode = not debugMode
    end
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

    -- colisão
    for _, obj in ipairs(objetos) do
        if obj.getHitbox then
            local bx, by, bw, bh = obj:getHitbox()
            if checaColisao(
                novoX + playerHitbox.offsetX, y + playerHitbox.offsetY,
                playerHitbox.w, playerHitbox.h,
                bx, by, bw, bh
            ) then
                novoX = x
                break
            end
        end
    end

    for _, obj in ipairs(objetos) do
        if obj.getHitbox then
            local bx, by, bw, bh = obj:getHitbox()
            if checaColisao(
                novoX + playerHitbox.offsetX, novoY + playerHitbox.offsetY,
                playerHitbox.w, playerHitbox.h,
                bx, by, bw, bh
            ) then
                novoY = y
                break
            end
        end
    end

    novoX = math.max(0, math.min(novoX, bgW - playerHitbox.w))
    novoY = math.max(0, math.min(novoY, bgH - playerHitbox.h))
    x, y = novoX, novoY

    if andando then
        tempo = tempo + dt
        if tempo > intervalo then
            tempo = 0
            frame = frame % #sprites[direcao] + 1
        end
    else
        frame = 1
    end

    -- detectar objeto próximo
    podeInteragir = false
    objetoProximo = nil
    for _, obj in ipairs(objetos) do
        if obj.isInterativo and not obj.interagido and obj.withOutline then
            local dx, dy = (x - obj.x), (y - obj.y)
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist < 500 then
                podeInteragir = true
                objetoProximo = obj
                break
            end
        end
    end


    if love.keyboard.isDown("e") and podeInteragir and objetoProximo then
    if not objetoProximo.interagido and objetoProximo.interagir then
        
        objetoProximo:interagir()
        objetoProximo.interagido = true

        
        interacoes[objetoProximo.tipo] = true
       

      
        if interacoes.peixe and interacoes.borboleta and interacoes.passaro then

            iniciarMinigame()
        end
    end
end

end

function drawMundo(objetos)
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    local camX = math.max(0, math.min(x - screenW / 2, bgW - screenW))
    local camY = math.max(0, math.min(y - screenH / 2, bgH - screenH))

    love.graphics.push()
    love.graphics.translate(-camX, -camY)
    love.graphics.draw(background, 0, 0, 0, bgScale, bgScale)

    -- desenha objetos atrás do player
    for _, obj in ipairs(objetos) do
        if obj.img then
            if (obj.y + obj.img:getHeight() * bgScale) <= (y + playerHitbox.h) then
                obj:draw(bgScale)
            end
        else
            obj:draw()
        end
    end

  
    love.graphics.draw(sprites[direcao][frame], x, y, 0, scaleX, scaleY)

   
    for _, obj in ipairs(objetos) do
        if obj.img then
            if (obj.y + obj.img:getHeight() * bgScale) > (y + playerHitbox.h) then
                obj:draw(bgScale)
            end
        else
            obj:draw()
        end
    end

    -- debug visual
    if debugMode then
        love.graphics.setColor(0, 1, 0, 0.5)
        love.graphics.rectangle("line",
            x + playerHitbox.offsetX,
            y + playerHitbox.offsetY,
            playerHitbox.w,
            playerHitbox.h
        )
        love.graphics.setColor(1, 0, 0, 0.5)
        for _, obj in ipairs(objetos) do
            if obj.getHitbox then
                local bx, by, bw, bh = obj:getHitbox()
                love.graphics.rectangle("line", bx, by, bw, bh)
            end
        end
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.pop()

    if podeInteragir and objetoProximo then
        local msg = "Pressione [E] para interagir com " .. objetoProximo.tipo
        love.graphics.printf(msg, 0, love.graphics.getHeight() - 80, love.graphics.getWidth(), "center")
    end
end

function getPlayerPosition()
    return x, y
end
