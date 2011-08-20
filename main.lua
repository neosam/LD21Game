require('camera.lua')
require('gridlayout.lua')
require('item.lua')
require('core.lua')

function love.load()
    gridLayout = newGridLayoutFromImage('level.png')
    player = newItem(500, 100, 32, 64)
    table.insert(core.items, player)
end

function love.update(dt)
    camera.x = camera.x + 0.1
    core:update(dt)
end

function love.draw()
    love.graphics.print("Static text", 400, 100)
    camera:set()
    gridLayout:draw()
    player:draw()
    love.graphics.print("World-Coordinate", 400, 200)
    camera:unset()
    love.graphics.print("Another static text", 400, 300)
    love.graphics.print("FPS: "..love.timer.getFPS(), 400, 400)
end
