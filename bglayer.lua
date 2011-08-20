function newBGLayer(image, scale)
    local bgLayer = {}
    bgLayer.image = image
    bgLayer.scale = scale or 14

    function bgLayer:draw()
        love.graphics.draw(self.image, -camera.x / self.scale, 
                                        -camera.y / self.scale)
    end

    return bgLayer
end
