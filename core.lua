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
