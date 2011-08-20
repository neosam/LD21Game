require('camera.lua')

function newGridLayoutFromImage(filename, tileSize)
    local img = love.image.newImageData(filename)
    gridLayout = newGridLayout(img:getWidth(), img:getHeight(),
            tileSize)

    for y = 0, img:getHeight() - 1 do
        for x = 0, img:getWidth() - 1 do
            r, g, b, a = img:getPixel(x, y)
            if r ~= 0 and g ~= 0 and b ~= 0 then
                gridLayout.grid[y * gridLayout.width + x] = 1
            end
        end
    end

    return gridLayout
end

function newGridLayout(width, height, tileSize)
    gridLayout = {}
    gridLayout.width = width
    gridLayout.height = height
    gridLayout.size = width * height
    gridLayout.tileSize = tileSize or 32
    gridLayout.grid = {}

    for i = 0, gridLayout.size do
        gridLayout.grid[i] = {tile=0}
    end

    function gridLayout:draw()
        local xBegin = math.floor(camera.x / self.tileSize)
        local yBegin = math.floor(camera.y / self.tileSize)
        local xTo = xBegin + 32
        local yTo = yBegin + 32
        for y = yBegin, yTo do
            for x = xBegin, xTo do
                tile = self.grid[y * self.width + x]
                if tile.tile ~= 0 then
                    love.graphics.rectangle('fill', x * self.tileSize,
                                            y * self.tileSize,
                                            self.tileSize,
                                            self.tileSize)
                end
            end
        end
    end

    return gridLayout
end
