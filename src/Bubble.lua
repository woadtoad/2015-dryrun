local world = require("src.world")

local Bubble = CLASS('bubble')
Bubble:include(STATEFUL)

--Default state
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function Bubble:initialize(x, y, radius)
  -- set the defaults
  radius = radius or 35
  x = x or (love.graphics.getWidth() / 2) - (radius / 2)
  y = y or (love.graphics.getHeight() / 2) - (radius / 2)

  self.Health = 1

  animlist = {}
  animlist["Death"] = {
    framerate = 14,
    frames = {
      "Death001",
      "Death002"
    }
  }

  self.sprite = TEXMATE(myAtlas,animlist,"Death",nil,nil,0,-30)

  self.collision = world:newCircleCollider(x, y, radius, {collision_class = 'Bubble'})
  self.collision.body:setFixedRotation(false)
  self.collision.body:setLinearDamping(0.6)
  self.collision.fixtures['main']:setRestitution(0.7)
end

function Bubble:update(dt)
  -- self.sprite:update(dt)

  --update the position of the sprite
  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  --update the rotation of the sprite.

  -- apply continuous anti-grav force
  local xVel, yVel = self.collision.body:getLinearVelocity()
  if yVel > -100 then
    self.collision.body:applyForce(0, -2500)
  end

end

function Bubble:draw()
  -- self.sprite:draw()
end

function Bubble:speak()
  print("Default!")
end

function Bubble:keypressed(key, isrepeat)

end

--Idle state
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Idle = Bubble:addState('Idle')

function Idle:speak()
  print("Idle!")
end

function Idle:update(dt)

end

return Bubble
