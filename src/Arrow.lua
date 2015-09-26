local world = require("src.world")

local Arrow = CLASS('Arrow')
Arrow:include(STATEFUL)


function Arrow:initialize(x,y,vec)
--[[

  self.collision = world:newRectangleCollider(x or 100, y or 100, 5, 70, {collision_class = 'Arrow'})
  self.collision.body:setFixedRotation(false)

  self.collision.fixtures['main']:setRestitution(0.6)
  self.collision.body:setLinearVelocity(1000*vec.x,1000*vec.y)
  self.collision.body:setAngle(math.deg(math.atan2(vec.y,vec.x))+90 or 90)

  -- there is a bug here that doesn't draw the debug correctly for added shapes.
  self.collision:addShape("head", "CircleShape", 0,70,10)

  ]]

  self.collision = world:newCircleCollider(x or 100, y or 100, 10, {collision_class = 'Arrow'})
  self.collision.body:setFixedRotation(false)

  self.collision.fixtures['main']:setRestitution(0.6)
  self.collision.body:setLinearVelocity(1000*vec.x,1000*vec.y)

  local angle = math.deg(math.atan2(vec.y,vec.x))

  self.collision.body:setAngle(math.rad(angle+90))

  -- there is a bug here that doesn't draw the debug correctly for added shapes.
  self.collision:addShape("head", "RectangleShape", 0,50,5,70)


end

function Arrow:draw()

end

function Arrow:update()

end

return Arrow
