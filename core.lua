-- core stuff here

core = {}
core.level = nil
core.player = nil
core.items = {}
core.gravity = 2
core.cameraPlayerDistance = 100 

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
end

function core:update(dt)
    for i, item in pairs(core.items) do
        -- gravity
        if item.onGround == false then
            local newY = item.y + self.gravity
            if self.level:getTileAt(item.x, newY + item.height).wall then
                item.onGround = true
                item.y = math.floor(item.y / self.level.tileSize + 1) 
                                * self.level.tileSize 
            else
                item.y = newY
            end
        end
    end

    -- reset camera position
    self:handleCamera()
end

function core:handleInput()
    if love.keyboard.isDown('left') then
        self.player:move(-2, 0)
    end
    if love.keyboard.isDown('right') then
        self.player:move(2, 0)
    end
end
