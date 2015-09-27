local world = require("src.world")

local Cauldron = CLASS('Cauldron')
--Co:include(STATEFUL)
Cauldron.static.ANIM_IDLE = 'Idle'

function Cauldron:initialize(x, y, radius)
  -- set the defaults
  radius = radius or 35
  x = x or (love.graphics.getWidth() / 2) - (radius / 2)
  y = y or (love.graphics.getHeight() / 2) - (radius / 2)

  animlist = {}
  animlist[Cauldron.static.ANIM_IDLE] = {
    framerate = 14,
    frames = {
      "cauldron/caudron_0000",
      "cauldron/caudron_0001",
      "cauldron/caudron_0002",
    }
  }
  self.sprite = TEXMATE(myAtlas, animlist, "Idle", nil, nil, -8, 0)
  self.collision = world:newCircleCollider(x, y, radius, {collision_class = 'Cauldron'})
  self.collision.parent = self
  self.collision.body:setFixedRotation(true)
  self.collision.body:setLinearDamping(0.6)
  self.collision.fixtures['main']:setRestitution(0)
  self.collision.fixtures['main']:setFriction(0.7)

  self.pickedUp = false
  self.aliveTime = 0
end

function Cauldron:update(dt)
  self.sprite:update(dt)

    --update the position of the sprite
    self.sprite:changeLoc(self.collision.body:getPosition())

  self.aliveTime = self.aliveTime + dt
end

function Cauldron:draw()
  self.sprite:draw()
end

function Cauldron:pickup()
  self.pickedUp = true
end

function Cauldron:destroy()
  self.collision.body:destroy()
end

return Cauldron
