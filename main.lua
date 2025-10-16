require("player.player")
require("objetos.objetos")


function love.load()
    love.keyboard.setKeyRepeat(true)
    love.window.setMode(0, 0, {fullscreen = true})
    
    initPlayer()
    initObjetos()
   
end

function love.update(dt)
    updatePlayer(dt, objetos)
end

function love.draw()
    drawMundo(objetos)
    
end