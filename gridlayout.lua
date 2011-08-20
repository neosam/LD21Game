
function newGridLayoutFromImage(filename, tileSize)
    local img = love.image.newImageData(filename)
    gridLayout = newGridLayout(img:getWidth(), img:getHeight(),
            tileSize)

    for y = 0, img:getHeight() - 1 do
        for x = 0, img:getWidth() - 1 do
            r, g, b, a = img:getPixel(x, y)
            if r ~= 0 or g ~= 0 or b ~= 0 then
                gridLayout.grid[y * gridLayout.width + x].wall = true
            end
            if r == 255 and g == 255 and b == 255 then
                gridLayout.grid[y * gridLayout.width + x].tile = 1
            elseif r == 255 and g == 0 and b == 0 then
                gridLayout.grid[y * gridLayout.width + x].tile = 2
            elseif r == 0 and g == 255 and b == 0 then
                gridLayout.grid[y * gridLayout.width + x].tile = 3
            elseif r == 0 and g == 0 and b == 255 then
                gridLayout.grid[y * gridLayout.width + x].tile = 4
            elseif r == 255 and g == 255 and b == 0 then
                newBasicEnemy(x * gridLayout.tileSize,
                            y * gridLayout.tileSize)
                gridLayout.grid[y * gridLayout.width + x].wall = false
            elseif r == 255 and g == 0 and b == 255 then
                gridLayout.grid[y * gridLayout.width + x].wall = false
                gridLayout.grid[y * gridLayout.width + x].checkpoint = true
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
        gridLayout.grid[i] = {
                tile=0,
                wall=false,
                checkpoint = false
        }
    end

    function gridLayout:getTileAt(x, y)
        x = math.floor(x / self.tileSize)
        y = math.floor(y / self.tileSize)
        return self.grid[y * self.width + x];
    end

    function gridLayout:draw()
        local xBegin = math.max(math.floor(camera.x / self.tileSize), 0)
        local yBegin = math.max(math.floor(camera.y / self.tileSize), 0)
        local xTo = math.min(xBegin + 32, self.width - 1)
        local yTo = math.min(yBegin + 32, self.height - 1)
        for y = yBegin, yTo do
            for x = xBegin, xTo do
                tile = self.grid[y * self.width + x]
                if tile.tile ~= 0 then
                    if tile.tile == 1 then
                        love.graphics.setColor({255, 255, 255})
                    elseif tile.tile == 2 then
                        love.graphics.setColor({255, 0, 0})
                    elseif tile.tile == 3 then
                        love.graphics.setColor({0, 255, 0})
                    elseif tile.tile == 4 then
                        love.graphics.setColor({0, 0, 255})
                    end
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
