-- core stuff here

core = {}
core.level = nil
core.items = {}
core.gravity = 4

function core:update(dt)
    for item in pairs(self.items) do
        item.y = item.y + self.gravity 
    end
end
