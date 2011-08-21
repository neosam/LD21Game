-- core stuff here

core = {}
core.level = nil
core.player = nil
core.items = {}
core.gravity = 8
core.cameraPlayerDistance = 200 
core.enemies = {}
core.timeLeft = 1000
core.sprites = {}
core.gameLogo = nil
core.deadLogo = nil
core.storyImages = {}
core.state = 0
core.storyline = 0
core.lastCheckpoint = nil

function core:handleCamera()
    local dx = player.x - camera.x
    local dy = player.y - camera.y
    if dx < self.cameraPlayerDistance then
        camera.x = player.x - core.cameraPlayerDistance
    end
    if dy < self.cameraPlayerDistance then
        camera.y = player.y - core.cameraPlayerDistance
    end
    if dx > love.graphics.getWidth() - self.cameraPlayerDistance then
        camera.x = player.x - love.graphics.getWidth() 
                                + self.cameraPlayerDistance
    end
    if dy > love.graphics.getHeight() - self.cameraPlayerDistance then
        camera.y = player.y - love.graphics.getHeight() 
                                + self.cameraPlayerDistance
    end
    camera.x = math.min(math.max(camera.x, 0), 
                    core.level.width * core.level.tileSize 
                    - love.graphics.getWidth())
    camera.y = math.min(math.max(camera.y, -30),
                    core.level.height * core.level.tileSize 
                    - love.graphics.getHeight())
end

function core:update(dt)
    if self.state == 0 then
        self:titleScreenUpdate(dt)
    elseif self.state == 1 then
        self:storyImageUpdate(dt)
    elseif self.state == 2 then
        self:ingameUpdate(dt)
    elseif self.state == 3 then
        self:deadUpdate(dt)
    end
end

function core:draw()
    if self.state == 0 then
        self:titleScreenDraw()
    elseif self.state == 1 then
        self:storyImageDraw()
    elseif self.state == 2 then
        self:ingameDraw()
    elseif self.state == 3 then
        self:deadDraw()
    end
end

function core:ingameDraw()
    bgLayer:draw()
    camera:set()
    gridLayout:draw()
    for i, item in pairs(core.items) do
        item:draw()
    end
    camera:unset()
    love.graphics.setColor({0, 0, 0})
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), 30)
    love.graphics.setColor({255, 255, 255})
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
    love.graphics.print("Time left: " .. core.timeLeft, 300, 10)
end

function core:ingameUpdate(dt)
    for i, item in pairs(core.items) do
        -- gravity
        if item.onGround == false or item.jumpsLeft > 0 then
            local newY = 0
            if item.jumpsLeft > 0 then
                newY = item.y - self.gravity
                item.onGround = false
            else
                newY = item.y + self.gravity
            end
                
            if item.jumpsLeft <= 0
                    and (self.level:getTileAt(item.x + 4, newY + item.height).wall 
                    or self.level:getTileAt(item.x + item.width - 4,
                                            newY + item.height).wall) then
                item.onGround = true
                item.y = math.floor(item.y / self.level.tileSize + 1) 
                                * self.level.tileSize 
            elseif item.jumpsLeft > 0
                    and (self.level:getTileAt(item.x + 4, newY).wall
                    or self.level:getTileAt(item.x + item.width - 4, 
                                                newY).wall) then

            else
                item.y = newY
            end
            if item.jumpsLeft > 0 then
                item.jumpsLeft = item.jumpsLeft - 1
            end
        end
    end
    core.timeLeft = core.timeLeft - 1
    if core.timeLeft < 0 then
        core.state = 3
    end

    -- reset camera position
    self:handleCamera()

    -- enemies
    for i, enemy in pairs(core.enemies) do
        enemy:doStuff()
    end

    -- sprites
    for i, sprite in pairs(core.sprites) do
        sprite:update()
    end
end

function core:handleInput()
    if movementButtonDown == nil then
        movementButtonDown = false
    end
    if love.keyboard.isDown('left') then
        self.player:move(-8, 0)
        self.player.sprite.flip = true
    end
    if love.keyboard.isDown('right') then
        self.player:move(8, 0)
        self.player.sprite.flip = false
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        if movementButtonDown == false then
            movementButtonDown = true
            self.player.sprite:setAnimation('run')
        end
    else
        if movementButtonDown == true then
            movementButtonDown = false
            self.player.sprite:setAnimation('default')
            print("no movemtn button down")
        end
        io.flush()
    end

    if love.keyboard.isDown('up') then
        self.player:jump()
    end
end

function core:titleScreenDraw()
    love.graphics.draw(self.gameLogo, 0, 0)
    love.graphics.setColor({255, 255, 255})
    love.graphics.rectangle('fill', 340, 500, 145, 15)
    love.graphics.setColor({0, 0, 0})
    love.graphics.print("Press space to start", 350, 500)
    love.graphics.setColor({255, 255, 255})
end

function core:storyImageDraw()
    if core.currentStoryImage == nil then
        core.currentStoryImage = love.graphics.newImage(
                                    core.storyImages[core.storyIndex])
    end
    love.graphics.draw(core.currentStoryImage, 0, 0)
end

function core:deadDraw()
    love.graphics.draw(self.deadLogo, 0, 0)
end

function core:titleScreenUpdate(dt)
    if love.keyboard.isDown(' ') then
        local d, i = love.keyboard.getKeyRepeat()
        if i > 1 then
            return
        end
        core.timeLeft = 1000
        core.level = nil
        core.player = nil
        core.items = {}
        core.gravity = 8
        core.cameraPlayerDistance = 200 
        core.enemies = {}
        core.timeLeft = 1000
        core.sprites = {}
        core.gameLogo = nil
        core.deadLogo = nil
        core.storyImages = {'story1.png', 
                            'story2.png',
                            'story3.png',
                            'story4.png',
                            'story5.png',
                            'story6.png',
                            'story7.png',
                            'story8.png',
                            'story9.png',
                            'story10.png',
                            'story11.png',
                            }
        core.storyIndex = 1
        core.state = 1
        core.storyline = 0
        core.lastCheckpoint = {x=500, y=100, startpoint=true}

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
    end
end

function prepareForStory2()
        core.storyImages = {'story12.png', 
                            'story13.png',
                            'story14.png',
                            }
        core.storyIndex = 1
        core.state = 1
        core.storyline = 1
        print("Switched to storyline 2")
        io.flush()
end
function prepareForStory3()
        core.storyImages = {'story15.png', 
                            'story16.png',
                            'story17.png',
                            'story18.png',
                            'story19.png',
                            'story20.png',
                            'story21.png',
                            'story22.png',
                            'story23.png',
                            'story24.png',
                            }
        core.storyIndex = 1
        core.state = 1
        core.storyline = 3
        print("Switched to storyline 3")
        io.flush()
end

function prepareForLevel2()
        core.timeLeft = 1000
        core.level = nil
        core.player = nil
        core.items = {}
        core.gravity = 8
        core.cameraPlayerDistance = 200 
        core.enemies = {}
        core.timeLeft = 1000
        core.lastCheckpoint = {x=32000-100, y=3200-200, startpoint=true}
    
        gridLayout = newGridLayoutFromImage('level2.png')
        player = newItem(32000 - 100, 3200-200, 32, 64)
        --player = newItem(500, 100, 32, 64)
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
        background = love.graphics.newImage('background2.png')
        core.gameLogo =love.graphics.newImage('titlescreen.png')
        core.deadLogo =love.graphics.newImage('dead.png')
        bgLayer = newBGLayer(background)
        for i, item in pairs(core.items) do
            item.sprite = sprite
        end
end

function core:storyImageUpdate(dt)
    if core.storyline == 1 then
        core.storyline = 2
    elseif core.storyline == 3 then
        core.storyline = 4
    end
    if wasStoryButtonReleased == nil then
        wasStoryButtonReleased = false
    end
        if love.keyboard.isDown(' ') then
        if wasStoryButtonReleased then
            wasStoryButtonReleased = false
            core.storyIndex = core.storyIndex + 1
            if core.storyIndex > table.getn(core.storyImages) then
                if core.storyline == 2 then
                    prepareForLevel2()
                end
                if core.storyline == 4 then
                    core.storyIndex = core.storyIndex - 1
                else
                    core.state = 2
                end
            end
            core.currentStoryImage = nil
        end
    else
        wasStoryButtonReleased = true
    end
end

function core:deadUpdate(dt)
    if love.keyboard.isDown(' ') then
        --core.state = 0
        core.state = 2
        core.player.x = core.lastCheckpoint.x
        core.player.y = core.lastCheckpoint.y
        if core.lastCheckpoint.startpoint then
            core.timeLeft = 1000
        else 
            core.timeLeft = 0
        end
        for i, tile in pairs(core.level.grid) do
            if tile.initCheckpoint then
                tile.checkpoint = true
            end
        end
        core.player:move(0, 0)
    end
end
