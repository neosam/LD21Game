require('camera.lua')
require('core.lua')
require('item.lua')

function newBasicEnemy(x, y)
    enemy = newItem(x, y, core.level.tileSize, core.level.tileSize)
    table.insert(core.enemies, enemy)
    table.insert(core.items, enemy)
    enemy.walking = -2

    function enemy:doStuff()
        if enemy:move(enemy.walking, 0) == false then
            enemy.walking = enemy.walking * -1
        end
    end

    return enemy
end
