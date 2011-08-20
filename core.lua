-- core stuff here

core = {}
core.level = nil
core.items = {}
core.gravity = 0.3

function core:update(dt)
    for i, item in pairs(core.items) do
        if item.onGround == false then
            item.y = item.y + self.gravity
        end
    end
end
