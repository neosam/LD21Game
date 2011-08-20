function newSprite(image, width, height)
    local sprite = {}
    sprite.image = image
    sprite.width = width
    sprite.height = height
    sprite.animations = {}
    sprite.currentAnimation = 'default'
    sprite.frame = 0
    sprite.flip = false
    sprite.frameFlip = 10

    function sprite:addAnimation(name, y, size)
        self.animations[name] = {y=y, size=size}
    end

    function sprite:setAnimation(name)
        self.frame = 0
        self.currentAnimation = name
    end

    function sprite:draw(x, y)
        local anim = sprite.animations[self.currentAnimation]
        local refY = anim.y
        local refX = (math.floor(self.frame / self.frameFlip) % anim.size) * self.width
        quad = love.graphics.newQuad(refX, refY, sprite.width, sprite.height,
                       image:getWidth(), image:getHeight()) 
        if self.flip then
            love.graphics.drawq(image, quad, x + sprite.width,
                                            y, 0, -1, 1)
        else
            love.graphics.drawq(image, quad, x, y)
        end
    end

    function sprite:update(dt)
        self.frame = self.frame + 1
    end

    return sprite
end
