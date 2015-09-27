local world = require("src.world")

local Platform = CLASS('Platform')

function Platform:initialize(x, y, scale)
  -- set the dimensions of the platform
  local wall = 50 -- TODO: refactor
  local gap = 5
  local width = love.graphics.getWidth() - (wall * 2) - (gap * 2)
  local height = 40

  -- set defaults
  x = (love.graphics.getWidth() / 2) +x
  y = height * 5 + y
  scale = scale or 1
  width = width * scale

  self.jointCollider = world:newCircleCollider(x, y, 2, {body_type = 'static'})
  self.collision = world:newRectangleCollider(x - (width / 2), y - (height / 2), width, height, {
    body_type = 'dynamic',
    collision_class = 'Platform'
  })
  self.collision.parent = self
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.3)

  self.joint = world:addJoint('RevoluteJoint', self.jointCollider.body, self.collision.body, x, y, false)
end

function Platform:update(dt)
end

function Platform:draw()
end

return Platform
