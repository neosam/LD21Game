
function newGridLayoutFromImage(filename, tileSize)
    local img = love.image.newImageData(filename)
    local gridLayout = newGridLayout(img:getWidth(), img:getHeight(),
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
                gridLayout.grid[y * gridLayout.width + x].initCheckpoint = true
                gridLayout.grid[y * gridLayout.width + x].tile = 5
            elseif r == 204 and g == 204 and b == 204 then
                gridLayout.grid[y * gridLayout.width + x].wall = false
                gridLayout.grid[y * gridLayout.width + x].tile = 5
            elseif r == 17 and g == 17 and b == 17 then
                gridLayout.grid[y * gridLayout.width + x].wall = false
                gridLayout.grid[y * gridLayout.width + x].goal = true
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
    gridLayout.tileImage = nil

    for i = 0, gridLayout.size do
        gridLayout.grid[i] = {
                tile=0,
                wall=false,
                initCheckpoint = false,
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
        local quad = nil;
        local quad1 = love.graphics.newQuad(0, 0, 32, 32, 
                            self.tileImage:getWidth(),
                            self.tileImage:getHeight())
        local quad2 = love.graphics.newQuad(33, 0, 32, 32, 
                            self.tileImage:getWidth(),
                            self.tileImage:getHeight())
        local quad3 = love.graphics.newQuad(98, 0, 32, 32, 
                            self.tileImage:getWidth(),
                            self.tileImage:getHeight())
        local quad5 = love.graphics.newQuad(65, 0, 32, 32, 
                            self.tileImage:getWidth(),
                            self.tileImage:getHeight())
        love.graphics.setColor({255, 255, 255})
        for y = yBegin, yTo do
            for x = xBegin, xTo do
                tile = self.grid[y * self.width + x]
                if tile.tile ~= 0 then
                    if tile.tile == 1 then
                        quad = quad1
                    elseif tile.tile == 2 then
                        quad = quad2
                    elseif tile.tile == 3 then
                        quad = quad3
                    elseif tile.tile == 4 then
                    elseif tile.tile == 5 then
                        quad = quad5
                    end
                    love.graphics.drawq(self.tileImage, quad, 
                                    (x+1) * self.tileSize,
                                    (y+1) * self.tileSize, 0, 1, 1,
                                    32, 32)
                end
            end
        end
    end

    return gridLayout
end
