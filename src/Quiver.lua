local Arrow = require("src.Arrow")

local Quiver = CLASS('quiver')
Quiver:include(STATEFUL)

Quiver.Arrows = {}

function Quiver:update()
  for i=1,#self.Arrows do
    self.Arrows:update()
  end
end

function Quiver:draw()
  for i=1,#self.Arrows do
    self.Arrows:draw()
  end
end

function Quiver:forgeArrow(x,y,vec)
  table.insert(self.Arrows,Arrow(x,y,vec))
end

return Quiver
