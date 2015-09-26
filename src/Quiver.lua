local Arrow = require("src.Arrow")

local Quiver = CLASS('quiver')
Quiver:include(STATEFUL)

function Quiver:initialize(limit, expiration)
  self.limit = limit or math.huge
  self.expiration = expiration or 3 -- seconds
  self.Arrows = {}
end

function Quiver:update(dt)
  for i,arrow in ipairs(self.Arrows) do
    if arrow.expired then
      arrow:destroy()
      table.remove(self.Arrows, i)
    else
      arrow:update(dt)
    end
  end
end

function Quiver:draw()
  for i,arr in ipairs(self.Arrows) do
    arr:draw()
  end
end

function Quiver:forgeArrow(x,y,vec)
  if #self.Arrows < self.limit then
    local arrow = Arrow(x,y,vec)
    arrow:setExpiration(self.expiration)
    table.insert(self.Arrows,arrow)
  end
end

return Quiver
