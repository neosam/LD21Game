require('camera.lua')

function love.update(dt)
    camera.x = camera.x + 1
end

function love.draw()
    love.graphics.print("Static text", 400, 100)
    camera:set()
    love.graphics.print("World-Coordinate", 400, 200)
    camera:unset()
    love.graphics.print("Another static text", 400, 300)
    love.graphics.print("FPS: "..love.timer.getFPS(), 400, 400)
end
