-- core stuff here

core = {}
core.level = nil
core.player = nil
core.items = {}
core.gravity = 2

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
    camera.x = player.x - 400
    camera.y = player.y - 300
end

function core:handleInput()
    if love.keyboard.isDown('left') then
        self.player.x = self.player.x - 2
    end
    if love.keyboard.isDown('right') then
        self.player.x = self.player.x + 2
    end
end
