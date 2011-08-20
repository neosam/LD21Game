function newSprite(image, width, height)
    local sprite = {}
    sprite.image = image
    sprite.width = width
    sprite.height = height
    sprite.animations = {}
    sprite.currentAnimation = 'default'
    sprite.frame = 0

    function sprite:draw(x, y)
        quad = love.graphics.newQuad(0, 33, sprite.width, sprite.height,
                       image:getWidth(), image:getHeight()) 
        love.graphics.drawq(image, quad, x, y)
    end

    return sprite
end
