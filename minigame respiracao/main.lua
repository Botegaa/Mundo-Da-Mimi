local respiracao = require("minigame respiracao.minigame")

function love.load()
    respiracao.load()
end

function love.update(dt)
    respiracao.update(dt)
end

function love.draw()
    respiracao.draw()
end