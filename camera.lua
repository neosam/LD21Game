camera = {}
camera.x = 0
camera.y = 0

function camera:set()
    love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)
end

function camera:unset()
    love.graphics.pop()
end
