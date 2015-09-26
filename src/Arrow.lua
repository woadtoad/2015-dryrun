local world = require("src.world")

local Arrow = CLASS('Arrow')
Arrow:include(STATEFUL)


function Arrow:initialize(x,y,vec)

  self.collision = world:newCircleCollider(x or 100, y or 100, 5, {collision_class = 'Arrow'})
  self.collision.body:setFixedRotation(false)

  self.collision.fixtures['main']:setRestitution(0.6)
  --self.collision.body:setMass(1)

  self.collision2 = world:newRectangleCollider(x or 100, y+50 or 100, 3,30,{collision_class = 'Arrow'})
  self.collision2.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.3)

  local angle = math.deg(math.atan2(vec.y,vec.x))


  self.weld = world:addJoint('WeldJoint', self.collision2.body, self.collision.body, x, y, true)

  self.collision2.body:setLinearVelocity(2000*vec.x,2000*vec.y)

  self.collision2.body:setLinearDamping(1)

  self.collision.body:setAngle(math.rad(angle+90))
  self.collision2.body:setAngle(math.rad(angle+90))

end

function Arrow:draw()

end

function Arrow:update(dt)
  -- Burst on an bubble with the arrow peirces it
  if self.collision:enter('Bubble') then
    local _, bubble = self.collision:enter('Bubble')
    bubble.parent:burst()
  end
end


return Arrow
