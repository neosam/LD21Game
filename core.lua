-- core stuff here

core = {}
core.level = nil
core.items = {}
core.gravity = 2

function core:update(dt)
    for i, item in pairs(core.items) do
        -- gravity
        if item.onGround == false then
            local newY = item.y + self.gravity
            if self.level:getTileAt(item.x, newY + item.height).wall then
                print("Hit ground")
                item.onGround = true
            else
                item.y = newY
            end
        end
    end
end
