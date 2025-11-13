local Objeto = require("objetos.objeto")

function Borboleta(x, y)
    local frames = {
        love.graphics.newImage("assets/cenario/Borboleta/Borboleta1.png"),
        love.graphics.newImage("assets/cenario/Borboleta/Borboleta2.png")
    }

    local outlineFrames = {
        love.graphics.newImage("assets/cenario/Borboleta/BorboletaOutline1.png"),
        love.graphics.newImage("assets/cenario/Borboleta/BorboletaOutline2.png")
    }

    local borboleta = Objeto:new("assets/cenario/Borboleta/Borboleta1.png", x, y, {
        offsetX = 0,
        offsetY = 0,
        w = 20,
        h = 20
    })

    borboleta.frames = frames
    borboleta.outlineFrames = outlineFrames
    borboleta.frame = 1
    borboleta.timer = 0
    borboleta.interval = 0.2
    borboleta.scale = 0.8
    borboleta.withOutline = false

    -- 🔹 interatividade adicionada
    borboleta.isInterativo = true
    borboleta.tipo = "borboleta"
    borboleta.interagido = false

    function borboleta:update(dt)
        self.timer = self.timer + dt
        if self.timer >= self.interval then
            self.timer = 0
            self.frame = self.frame + 1
            if self.frame > #self.frames then
                self.frame = 1
            end
        end

        local px, py = getPlayerPosition()
        if px and py then
            local dx, dy = px - self.x, py - self.y
            local dist = math.sqrt(dx*dx + dy*dy)
            self.withOutline = (dist < 650) and not self.interagido
        end
    end

    function borboleta:interagir()
        if not self.interagido then
            self.interagido = true
            self.withOutline = false
            
        end
    end

    function borboleta:draw()
        local sprite = self.withOutline and self.outlineFrames[self.frame] or self.frames[self.frame]
        love.graphics.draw(sprite, self.x, self.y, 0, self.scale, self.scale)
    end

    return borboleta
end

return Borboleta

