local Peixe = {}

function Peixe:new(x, y)
    local self = setmetatable({}, {__index = Peixe})

    self.frames = {
        love.graphics.newImage("assets/cenario/Peixe/Fish1.png"),
        love.graphics.newImage("assets/cenario/Peixe/Fish2.png"),
        love.graphics.newImage("assets/cenario/Peixe/Fish3.png"),
        love.graphics.newImage("assets/cenario/Peixe/Fish4.png"),
        love.graphics.newImage("assets/cenario/Peixe/Fish5.png"),
        love.graphics.newImage("assets/cenario/Peixe/Fish6.png"),
        love.graphics.newImage("assets/cenario/Peixe/Fish7.png")
    }

    self.outlineFrames = {
        love.graphics.newImage("assets/cenario/Peixe/FishOutline1.png"),
        love.graphics.newImage("assets/cenario/Peixe/FishOutline2.png"),
        love.graphics.newImage("assets/cenario/Peixe/FishOutline3.png"),
        love.graphics.newImage("assets/cenario/Peixe/FishOutline4.png"),
        love.graphics.newImage("assets/cenario/Peixe/FishOutline5.png"),
        love.graphics.newImage("assets/cenario/Peixe/FishOutline6.png"),
        love.graphics.newImage("assets/cenario/Peixe/FishOutline7.png")
    }

    self.x = x
    self.y = y
    self.frame = 1
    self.timer = 0
    self.interval = 0.2
    self.scale = 0.6
    self.withOutline = false

    self.visible = true
    self.respawnDelay = 2
    self.respawnTimer = 0

    self.isInterativo = true
    self.tipo = "peixe"
    self.interagido = false

    return self
end

function Peixe:update(dt, playerX, playerY)
    if self.interagido then return end

    if not self.visible then
        self.respawnTimer = self.respawnTimer + dt
        if self.respawnTimer >= self.respawnDelay then
            self.visible = true
            self.respawnTimer = 0
            self.frame = 1
        end
        return
    end

    self.timer = self.timer + dt
    if self.timer >= self.interval then
        self.timer = 0
        self.frame = self.frame + 1

        if self.frame > #self.frames then
            self.visible = false
            self.respawnTimer = 0
            self.frame = 1
            return
        end
    end

    if playerX and playerY then
        local dx, dy = playerX - self.x, playerY - self.y
        local dist = math.sqrt(dx * dx + dy * dy)
        self.withOutline = (dist < 650) and not self.interagido
    end
end

function Peixe:interagir()
    if not self.interagido then
        self.interagido = true
        self.withOutline = false
     
    end
end

function Peixe:draw()
    if not self.visible then return end
    local sprite = self.withOutline and self.outlineFrames[self.frame] or self.frames[self.frame]
    love.graphics.draw(sprite, self.x, self.y, 0, self.scale, self.scale)
end

return Peixe
