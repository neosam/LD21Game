require('camera.lua')
require('gridlayout.lua')
require('item.lua')
require('core.lua')

function love.load()
    gridLayout = newGridLayoutFromImage('level.png')
    player = newItem(500, 100, 32, 64)
    core.level = gridLayout
    table.insert(core.items, player)
end

function love.update(dt)
    camera.x = camera.x + 0.1
    core:update(dt)
end

function love.draw()
    camera:set()
    gridLayout:draw()
    player:draw()
    camera:unset()
    love.graphics.setColor({255, 255, 255})
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
end
