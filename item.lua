require('camera.lua')
require('core.lua')

function newItem(x, y, width, height)
    local item = {}
    item.x = x
    item.y = y
    item.width = width
    item.height = height
    item.onGround = false
    item.jumpsLeft = 0
    item.sprite = nil
    
    function item:draw()
        --love.graphics.setColor({255, 255, 0})
        --love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
        self.sprite:draw(self.x, self.y)
    end

    function item:move(dx, dy)
        local newX = self.x + dx
        local newY = self.y + dy
        local possible = false
        if newX < 0 or newY < 0 or 
                    newX > core.level.width * core.level.tileSize or
                    newY > core.level.height * core.level.tileSize then
            return
        end
        if core.level:getTileAt(newX, newY).wall 
                or core.level:getTileAt(newX + self.width, newY).wall 
                or core.level:getTileAt(newX + self.width, newY + self.height - 2).wall 
                or core.level:getTileAt(newX, newY + self.height - 2).wall 
                or core.level:getTileAt(newX + self.width, newY + self.height/2 - 2).wall 
                or core.level:getTileAt(newX, newY + self.height/2 - 2).wall 
                or core.level:getTileAt(newX + self.width, newY + self.height/4*2 + 2).wall 
                or core.level:getTileAt(newX, newY + self.height/4*3 + 2).wall then
            if dx > 0 then
                self.x = math.floor((self.x - 3) / core.level.tileSize) 
                            * core.level.tileSize + core.level.tileSize
            else
                self.x = math.floor(self.x / core.level.tileSize)
                            * core.level.tileSize
            end
        else
            item.x = newX
            item.y = newY
            possible = true
        end
        if core.level:getTileAt(item.x + 4, item.y + self.height).wall 
                                == false
                    and core.level:getTileAt(item.x + self.width - 4,
                                    item.y + self.height).wall == false then
            self.onGround = false
        end
        -- Checkpoint
        if core.level:getTileAt(newX, newY).checkpoint 
                or core.level:getTileAt(newX + self.width, newY).checkpoint 
                or core.level:getTileAt(newX + self.width, newY + self.height - 2).checkpoint 
                or core.level:getTileAt(newX, newY + self.height - 2).checkpoint 
                or core.level:getTileAt(newX + self.width, newY + self.height/2 - 2).checkpoint 
                or core.level:getTileAt(newX, newY + self.height/2 - 2).checkpoint 
                or core.level:getTileAt(newX + self.width, newY + self.height/4*2 + 2).checkpoint 
                or core.level:getTileAt(newX, newY + self.height/4*3 + 2).checkpoint then
            core.level:getTileAt(newX, newY).checkpoint = false
            core.level:getTileAt(newX + self.width, newY).checkpoint = false
            core.level:getTileAt(newX + self.width, newY + self.height - 2).checkpoint = false
            core.level:getTileAt(newX, newY + self.height - 2).checkpoint = false
            core.level:getTileAt(newX + self.width, newY + self.height/2 - 2).checkpoint = false
            core.level:getTileAt(newX, newY + self.height/2 - 2).checkpoint = false
            core.level:getTileAt(newX + self.width, newY + self.height/4*2 + 2).checkpoint = false
            core.level:getTileAt(newX, newY + self.height/4*3 + 2).checkpoint = false
            core.timeLeft = core.timeLeft + 1000
            core.lastCheckpoint = {x=newX, y=newY, startpoint=false}
            io.flush()
            core.checkpointSound:stop()
            core.checkpointSound:play()
        end
        if core.level:getTileAt(newX, newY).goal 
                or core.level:getTileAt(newX + self.width, newY).goal 
                or core.level:getTileAt(newX + self.width, newY + self.height - 2).goal 
                or core.level:getTileAt(newX, newY + self.height - 2).goal 
                or core.level:getTileAt(newX + self.width, newY + self.height/2 - 2).goal 
                or core.level:getTileAt(newX, newY + self.height/2 - 2).goal 
                or core.level:getTileAt(newX + self.width, newY + self.height/4*2 + 2).goal 
                or core.level:getTileAt(newX, newY + self.height/4*3 + 2).goal then
            if core.storyline == 0 then
                prepareForStory2()
            elseif core.storyline == 2 and core.storyIndex > 2 then
                prepareForStory3()
            end
            core.checkpointSound:stop()
            core.checkpointSound:play()
            core.state = 1
        end
        return possible
    end

    function item:jump()
        if self.onGround == false then
            return
        end
        core.jumpSound:stop()
        core.jumpSound:play()
        item.jumpsLeft = 18
    end

    return item
end
