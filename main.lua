require('camera.lua')
require('gridlayout.lua')

function love.load()
    gridLayout = newGridLayoutFromImage('level.png')
end

function love.update(dt)
    camera.x = camera.x + 0.1
end

function love.draw()
    love.graphics.print("Static text", 400, 100)
    camera:set()
    gridLayout:draw()
    love.graphics.print("World-Coordinate", 400, 200)
    camera:unset()
    love.graphics.print("Another static text", 400, 300)
    love.graphics.print("FPS: "..love.timer.getFPS(), 400, 400)
end
