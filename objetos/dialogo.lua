local Dialogo = {}

Dialogo.ativo = false
Dialogo.texto = {}
Dialogo.index = 1
Dialogo.caixaAltura = 160
Dialogo.larguraMargem = 60

Dialogo.letraTimer = 0
Dialogo.letraVel = 0.02
Dialogo.letrasVisiveis = 0
Dialogo.completouLinha = false

function Dialogo.start(lista)
    Dialogo.texto = lista
    Dialogo.index = 1
    Dialogo.ativo = true
    Dialogo.letrasVisiveis = 0
    Dialogo.completouLinha = false
end

function Dialogo.update(dt)
    if not Dialogo.ativo then return end

    if not Dialogo.completouLinha then
        Dialogo.letraTimer = Dialogo.letraTimer + dt
        if Dialogo.letraTimer > Dialogo.letraVel then
            Dialogo.letraTimer = 0
            Dialogo.letrasVisiveis = Dialogo.letrasVisiveis + 1

            if Dialogo.letrasVisiveis >= #Dialogo.texto[Dialogo.index] then
                Dialogo.completouLinha = true
            end
        end
    end
end

function Dialogo.next()
    if not Dialogo.ativo then return end

    if not Dialogo.completouLinha then
        Dialogo.letrasVisiveis = #Dialogo.texto[Dialogo.index]
        Dialogo.completouLinha = true
        return
    end

    Dialogo.index = Dialogo.index + 1

    if Dialogo.index > #Dialogo.texto then
        Dialogo.ativo = false
        if Dialogo.onFinish then
            Dialogo.onFinish()
        end
        return
    end

    Dialogo.letrasVisiveis = 0
    Dialogo.letraTimer = 0
    Dialogo.completouLinha = false
end

function Dialogo.draw()
    if not Dialogo.ativo then return end

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local caixaY = h - Dialogo.caixaAltura - 20

    love.graphics.setColor(0, 0, 0, 0.65)
    love.graphics.rectangle("fill", 20, caixaY, w - 40, Dialogo.caixaAltura, 20, 20)

    love.graphics.setColor(1, 1, 1)
    local linha = Dialogo.texto[Dialogo.index]
    local visivel = Dialogo.letrasVisiveis
    local txt = string.sub(linha, 1, visivel)

    love.graphics.printf(txt, 40, caixaY + 30, w - 80, "left")

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.printf("(ENTER)", 40, caixaY + Dialogo.caixaAltura - 40, w - 80, "right")
end

return Dialogo
