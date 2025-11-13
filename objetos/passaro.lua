local Objeto = require("objetos.objeto")

function Passaro(x, y, emPedraL)
  
    if emPedraL then
        y = y - 90  
        x = x + 40   
    end

    local frames = {
        love.graphics.newImage("assets/cenario/Pássaro/Passaro1.png"),
        love.graphics.newImage("assets/cenario/Pássaro/Passaro2.png")
    }

    local outlineFrames = {
        love.graphics.newImage("assets/cenario/Pássaro/PassaroOutline1.png"),
        love.graphics.newImage("assets/cenario/Pássaro/PassaroOutline2.png")
    }

    local passaro = Objeto:new("assets/cenario/Pássaro/Passaro1.png", x, y, {
        offsetX = 0,
        offsetY = 0,
        w = 25,
        h = 25
    })

    passaro.frames = frames
    passaro.outlineFrames = outlineFrames
    passaro.frame = 1
    passaro.timer = 0
    passaro.interval = 2
    passaro.scale = 0.9
    passaro.withOutline = false


    passaro.isInterativo = true
    passaro.tipo = "passaro"
    passaro.interagido = false

    function passaro:update(dt)
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

    function passaro:interagir()
        if not self.interagido then
            self.interagido = true
            self.withOutline = false
           
        end
    end

    function passaro:draw()
        local sprite = self.withOutline and self.outlineFrames[self.frame] or self.frames[self.frame]
        love.graphics.draw(sprite, self.x, self.y, 0, self.scale, self.scale)
    end

    return passaro
end

return Passaro
