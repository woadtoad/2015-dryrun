local Arrow = require("src.Arrow")

local Quiver = CLASS('quiver')
Quiver:include(STATEFUL)

function Quiver:initialize()
  self.Arrows = {}
end

function Quiver:update(dt)
  for i,arr in ipairs(self.Arrows) do
    arr:update(dt)
  end
end

function Quiver:draw()
  for i,arr in ipairs(self.Arrows) do
    arr:draw()
  end
end

function Quiver:forgeArrow(x,y,vec)
  table.insert(self.Arrows,Arrow(x,y,vec))
end

return Quiver
