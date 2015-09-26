local world = require("src.world")

local Bubble = CLASS('bubble')
Bubble:include(STATEFUL)

--Default state
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function Bubble:initialize()
  self.Health = 1

  --this is how we setup the animations, I may write a
  --convinence function to make generating the file names easier. so it would be a functuon that takes the name then the range of numbers to go between and return the values.
  animlist = {}
  animlist["Death"] = {
    framerate = 14,
    frames = {
      "Death001",
      "Death002"
    }
  }

  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TEXMATE(myAtlas,animlist,"Death",nil,nil,0,-30)

  self.collision = world:newRectangleCollider(300, 300, 50, 50, {collision_class = 'Player'})
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.3)
  self.collision.body:applyLinearImpulse(100,0,self.collision.body:getX()-30,self.collision.body:getY()-30)
end

function Bubble:update(dt)
  self.sprite:update(dt)

  --update the position of the sprite
  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  --update the rotation of the sprite.

end

function Bubble:draw()
  self.sprite:draw()
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
