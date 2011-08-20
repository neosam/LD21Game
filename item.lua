require('camera.lua')

function newItem(x, y, width, height)
    item = {}
    item.x = x
    item.y = y
    item.width = width
    item.height = height
    item.onGround = false
    
    function item:draw()
        love.graphics.setColor({255, 255, 0})
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end

    return item
end
