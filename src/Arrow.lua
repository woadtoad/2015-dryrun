local world = require("src.world")

local Arrow = CLASS('Arrow')
Arrow:include(STATEFUL)


function Arrow:initialize(x,y,vec)

  self.collision = world:newCircleCollider(x or 100, y or 100, 10, {collision_class = 'Arrow'})
  self.collision.body:setFixedRotation(false)

  self.collision.fixtures['main']:setRestitution(0.6)
  self.collision.body:setLinearVelocity(1000*vec.x,1000*vec.y)

  local angle = math.deg(math.atan2(vec.y,vec.x))

  self.collision.body:setAngle(math.rad(angle+90))

  -- there is a bug here that doesn't draw the debug correctly for added shapes.
  self.collision:addShape("head", "RectangleShape", 0,50,5,70)

  self.dragConstant = 0.5

end

function Arrow:draw()
end

function Arrow:update()
end

function Arrow:updateTODO()

  self.pointingDirection  = self.collision.body:getWorldVector(0,1)
  self.flightdir = VECTOR(self.collision.body:getLinearVelocity())
  self.flightSpeed  = self.vel:normalized()

  self.dot = self.flightdir:dot(self.pointingDirection)
  self.dragmagnitude = (1- self.dot:abs()) * self.flightSpeed * self.flightSpeed * self.dragConstant * self.collision.body:GetMass()

  print(self.dragmagnitude)
end

return Arrow
