require('camera.lua')
require('gridlayout.lua')
require('item.lua')
require('core.lua')
require('enemy.lua')
require('sprite.lua')

function love.load()
    gridLayout = newGridLayoutFromImage('level.png')
    player = newItem(500, 100, 32, 64)
    core.level = gridLayout
    table.insert(core.items, player)
    core.player = player
    levelDesign = love.graphics.newImage('tiles.png')
    gridLayout.tileImage = levelDesign
    sprite = newSprite(levelDesign, 32, 64)
    for i, item in pairs(core.items) do
        item.sprite = sprite
    end
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
    love.graphics.setColor({0, 0, 0})
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), 20)
    love.graphics.setColor({255, 255, 255})
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
    love.graphics.print("Time left: " .. core.timeLeft, 300, 10)
end
