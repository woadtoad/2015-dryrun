local world = require("src.world")

local Coin = CLASS('Coin')
--Co:include(STATEFUL)
Coin.static.ANIM_IDLE = 'Idle'

function Coin:initialize(x, y, radius)
  -- set the defaults
  radius = radius or 15
  x = x or (love.graphics.getWidth() / 2) - (radius / 2)
  y = y or (love.graphics.getHeight() / 2) - (radius / 2)

  animlist = {}
  animlist[Coin.static.ANIM_IDLE] = {
    framerate = 14,
    frames = {
      "coin/Coin_0000",
      "coin/Coin_0001",
      "coin/Coin_0002",
      "coin/Coin_0003",
      "coin/Coin_0004",
      "coin/Coin_0005"
    }
  }
  self.sprite = TEXMATE(myAtlas, animlist, "Idle", nil, nil, -8, 5)
  self.collision = world:newCircleCollider(x, y, radius, {collision_class = 'Coin'})
  self.collision.parent = self
  self.collision.body:setFixedRotation(true)
  self.collision.body:setLinearDamping(0.6)
  self.collision.fixtures['main']:setRestitution(0.7)

  self.pickedUp = false
  self.aliveTime = 0
end

function Coin:update(dt)
  self.sprite:update(dt)

    --update the position of the sprite
    self.sprite:changeLoc(self.collision.body:getPosition())

  self.aliveTime = self.aliveTime + dt
end

function Coin:draw()
  self.sprite:draw()
end

function Coin:pickup()
  self.pickedUp = true
end

function Coin:destroy()
  self.collision.body:destroy()
end

return Coin
