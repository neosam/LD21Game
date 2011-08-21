require('camera.lua')
require('gridlayout.lua')
require('item.lua')
require('core.lua')
require('enemy.lua')
require('sprite.lua')
require('bglayer.lua')

function love.load()
    gridLayout = newGridLayoutFromImage('level.png')
    player = newItem(500, 100, 32, 64)
    core.level = gridLayout
    table.insert(core.items, player)
    core.player = player
    levelDesign = love.graphics.newImage('tiles.png')
    gridLayout.tileImage = levelDesign
    sprite = newSprite(levelDesign, 32, 64)
    sprite:addAnimation('default', 33, 1)
    sprite:addAnimation('run', 33, 2)
    sprite:setAnimation('default')
    table.insert(core.sprites, sprite)
    background = love.graphics.newImage('background.png')
    core.gameLogo =love.graphics.newImage('titlescreen.png')
    core.deadLogo =love.graphics.newImage('dead.png')
    bgLayer = newBGLayer(background)
    for i, item in pairs(core.items) do
        item.sprite = sprite
    end
    core.jumpSound = love.audio.newSource("jump19.wav", "static")
    core.checkpointSound = love.audio.newSource("checkpoint.wav", "static")
    core.funnySound = love.audio.newSource("happy.wav", "static")
    core.sadSound = love.audio.newSource("sad.wav", "static")
    core.blipSound = love.audio.newSource("blip.wav", "static")

    love.graphics.setCaption("Dragon's Bloodmoney - a stupid game")
end

function love.update(dt)
    core:handleInput()
    core:update(dt)
end

function love.draw()
    core:draw()
end
