local world = require("src.world")

local Bubble = CLASS('Bubble')
Bubble:include(STATEFUL)
Bubble.static.ANIM_IDLE = 'Idle'
Bubble.static.ANIM_BURST = 'Burst'

function Bubble:initialize(x, y, radius,random)

  -- set the defaults
  self.random = random
  self.radius = (radius or 35) * self.random
  self.x = x or (love.graphics.getWidth() / 2) - (radius / 2)
  self.y = y or (love.graphics.getHeight() / 2) - (radius / 2)

  self.health = 1

  animlist = {}
  animlist[Bubble.static.ANIM_IDLE] = {
    framerate = 6,
    frames = {
        "bubblepop/Bubble_0000",
        "bubblepop/Bubble_0001",
        "bubblepop/Bubble_0002",
        "bubblepop/Bubble_0003",
        "bubblepop/Bubble_0004"
    }
  }
  animlist[Bubble.static.ANIM_BURST] = {
    framerate = 14,
    frames = {
      "bubblepop/Pop_0000",
      "bubblepop/Pop_0001"
    }
  }

  self.sprite = TEXMATE(myAtlas, animlist, "Idle", nil, nil, -8, 5,nil,nil,self.random)

  self.collision = world:newCircleCollider(self.x, self.y, self.radius, {collision_class = 'Bubble'})
  self.collision.parent = self
  self.collision.body:setFixedRotation(false)
  self.collision.body:setLinearDamping(0.6)
  self.collision.fixtures['main']:setRestitution(0.7)
  self.collision.fixtures['main']:setDensity(0.007)

  self.hasBurst = false
end

function Bubble:update(dt)
  self.sprite:update(dt)

  --update the position of the sprite
  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  --self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  --update the rotation of the sprite.
  -- TODO: emulate random wind impulses

  -- apply continuous anti-grav force
  local xVel, yVel = self.collision.body:getLinearVelocity()
  if yVel > -100 then
    local yforce = -1500
    local forceMod = (self.collision.body:getMass() / 10) * (yforce / 1.5)
    yforce = forceMod + yforce
    self.collision.body:applyForce(0, yforce)
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
    self:expire()
    self.sprite:pause()
    self.hasBurst = true
  end
end

function Bubble:expire()
  self.health = 0
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
