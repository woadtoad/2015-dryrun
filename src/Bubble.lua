local world = require("src.world")

local Bubble = CLASS('bubble')
Bubble:include(STATEFUL)
Bubble.static.ANIM_IDLE = 'Idle'
Bubble.static.ANIM_BURST = 'Burst'

function Bubble:initialize(x, y, radius)
  -- set the defaults
  radius = radius or 35
  x = x or (love.graphics.getWidth() / 2) - (radius / 2)
  y = y or (love.graphics.getHeight() / 2) - (radius / 2)

  self.health = 1

  animlist = {}
  animlist[Bubble.static.ANIM_IDLE] = {
    framerate = 14,
    frames = {
      "bubblepop/Bubble_0000"
    }
  }
  animlist[Bubble.static.ANIM_BURST] = {
    framerate = 14,
    frames = {
      "bubblepop/pop_0000",
      "bubblepop/pop_0001"
    }
  }

  self.sprite = TEXMATE(myAtlas, animlist, "Idle", nil, nil, 0, 0)

  self.collision = world:newCircleCollider(x, y, radius, {collision_class = 'Bubble'})
  self.collision.parent = self
  self.collision.body:setFixedRotation(false)
  self.collision.body:setLinearDamping(0.6)
  self.collision.fixtures['main']:setRestitution(0.7)
end

function Bubble:update(dt)
  self.sprite:update(dt)

  --update the position of the sprite
  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  --update the rotation of the sprite.
  -- TODO: emulate random wind impulses

  -- apply continuous anti-grav force
  local xVel, yVel = self.collision.body:getLinearVelocity()
  if yVel > -100 then
    self.collision.body:applyForce(0, -2500)
  end
end

function Bubble:draw()
  if self.health > 0 then
    self.sprite:draw()
  end
end

function Bubble:burst()
  self.sprite:changeAnim(Bubble.static.ANIM_BURST)
  self.sprite.endCallback[Bubble.static.ANIM_BURST] = function()
    self.health = 0
    self.sprite:pause()
  end
end

function Bubble:destroy()
  self.collision.body:destroy()
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
