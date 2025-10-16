function love.load()
    love.keyboard.setKeyRepeat(true)
    love.window.setMode(0, 0, {fullscreen = true})

    x, y = 500, 500
    velocidade = 300

    -- Sprites do player
    sprites = {
        direita = {
            love.graphics.newImage("assets/personagem/mimiRight1.png"),
            love.graphics.newImage("assets/personagem/mimiRight2.png"),
            love.graphics.newImage("assets/personagem/mimiRight1.png"),
            love.graphics.newImage("assets/personagem/mimiRight3.png")
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

    direcao = "baixo"
    frame, tempo, intervalo = 1, 0, 0.15

    scaleX, scaleY = 0.5, 0.5
    targetW = sprites.baixo[1]:getWidth()
    targetH = sprites.baixo[1]:getHeight()

    -- Hitbox do player
    playerHitbox = {
    offsetX = 30,  --  o deslocamento para centralizar
    offsetY = 20,  -- deslocamento vertical
    w = targetW * scaleX - 50,  -- largura 
    h = targetH * scaleY - 40,   -- altura 
}

    background = love.graphics.newImage("assets/cenario/GrassBG.png")
    bgScale = 0.75
    bgW, bgH = background:getWidth() * bgScale, background:getHeight() * bgScale

    zoom = 1

    debugMode = false  -- debug inicialmente desligado

    -- Objetos 
    objetos = {
        {
            img = love.graphics.newImage("assets/cenario/Tree 1.png"),
            x = 1900, y = 500,
            hitboxOffsetX = 90,
            hitboxOffsetY = 140,
            hitboxW = 60,
            hitboxH = 40,
            drawOffsetY = 0
        },
        {
            img = love.graphics.newImage("assets/cenario/Pedra (L).png"),
            x = 500, y = 1300,
            hitboxOffsetX = 30,
            hitboxOffsetY = 20,
            hitboxW = 150,
            hitboxH = 50,
            drawOffsetY = 0
        },
        {
            img = love.graphics.newImage("assets/cenario/Pedra (M).png"),
            x = 1000, y = 1000,
            hitboxOffsetX = 40,
            hitboxOffsetY = 10,
            hitboxW = 70,
            hitboxH = 10,
            drawOffsetY = 0
        }
    }
end

function love.keypressed(key)
    if key == "f1" then
        debugMode = not debugMode
    end
end

-- Função de colisão
function checaColisao(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah
end

function love.update(dt)
    local andando = false
    local novoX, novoY = x, y

    if love.keyboard.isDown("d") then novoX = x + velocidade * dt; direcao = "direita"; andando = true
    elseif love.keyboard.isDown("a") then novoX = x - velocidade * dt; direcao = "esquerda"; andando = true end

    for _, obj in ipairs(objetos) do
        if checaColisao(
            novoX + playerHitbox.offsetX, y + playerHitbox.offsetY,
            playerHitbox.w, playerHitbox.h,
            obj.x + obj.hitboxOffsetX, obj.y + obj.hitboxOffsetY,
            obj.hitboxW, obj.hitboxH
        ) then
            novoX = x
            break
        end
    end

    if love.keyboard.isDown("s") then novoY = y + velocidade * dt; direcao = "baixo"; andando = true
    elseif love.keyboard.isDown("w") then novoY = y - velocidade * dt; direcao = "cima"; andando = true end

    for _, obj in ipairs(objetos) do
        if checaColisao(
            novoX + playerHitbox.offsetX, novoY + playerHitbox.offsetY,
            playerHitbox.w, playerHitbox.h,
            obj.x + obj.hitboxOffsetX, obj.y + obj.hitboxOffsetY,
            obj.hitboxW, obj.hitboxH
        ) then
            novoY = y
            break
        end
    end

    novoX = math.max(0, math.min(novoX, bgW - targetW * scaleX))
    novoY = math.max(0, math.min(novoY, bgH - targetH * scaleY))
    x, y = novoX, novoY

    if andando then
        tempo = tempo + dt
        if tempo > intervalo then
            tempo = 0
            frame = frame + 1
            if frame > #sprites[direcao] then frame = 1 end
        end
    else frame = 1 end
end

function love.draw()
    love.graphics.push()
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    local camX = math.max(0, math.min(x - screenW/(2*zoom), bgW - screenW/zoom))
    local camY = math.max(0, math.min(y - screenH/(2*zoom), bgH - screenH/zoom))
    love.graphics.scale(zoom, zoom)
    love.graphics.translate(-camX, -camY)

    -- Desenhar background
    love.graphics.draw(background, 0, 0, 0, bgScale, bgScale)

    -- Objetos atrás do player
    for _, obj in ipairs(objetos) do
        if (obj.y + obj.img:getHeight() * bgScale) <= (y + targetH * scaleY) then
            love.graphics.draw(obj.img, obj.x, obj.y + obj.drawOffsetY, 0, bgScale, bgScale)
        end
    end

    -- Player
    love.graphics.draw(sprites[direcao][frame], x, y, 0, scaleX, scaleY)

    -- Objetos na frente do player
    for _, obj in ipairs(objetos) do
        if (obj.y + obj.img:getHeight() * bgScale) > (y + targetH * scaleY) then
            love.graphics.draw(obj.img, obj.x, obj.y + obj.drawOffsetY, 0, bgScale, bgScale)
        end
    end

    -- Debug
    if debugMode then
        -- Player em verde
        love.graphics.setColor(0,1,0,0.5)
        love.graphics.rectangle("line", x + playerHitbox.offsetX, y + playerHitbox.offsetY, playerHitbox.w, playerHitbox.h)

        -- Objetos em vermelho
        love.graphics.setColor(1,0,0,0.5)
        for _, obj in ipairs(objetos) do
            love.graphics.rectangle("line", obj.x + obj.hitboxOffsetX, obj.y + obj.hitboxOffsetY, obj.hitboxW, obj.hitboxH)
        end

        love.graphics.setColor(1,1,1,1) -- reset cor
    end

    love.graphics.pop()
end
