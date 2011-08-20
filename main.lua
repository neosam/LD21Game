require('camera.lua')
require('gridlayout.lua')
require('item.lua')
require('core.lua')
require('enemy.lua')

function love.load()
    gridLayout = newGridLayoutFromImage('level.png')
    player = newItem(500, 100, 32, 64)
    core.level = gridLayout
    table.insert(core.items, player)
    core.player = player
    newBasicEnemy(400, 400)
end

function love.update(dt)
    core:handleInput()
    core:update(dt)
end

function love.draw()
    camera:set()
    gridLayout:draw()
    for i, item in pairs(core.items) do
        item:draw()
    end
    camera:unset()
    love.graphics.setColor({255, 255, 255})
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
end
