local PL = CLASS('player')
PL:include(STATEFUL)

--Default state
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

function PL:initialize()
  self.Health = 10

  --this is how we setup the animations, I may write a
  --convinence function to make generating the file names easier. so it would be a functuon that takes the name then the range of numbers to go between and return the values.
  animlist = {}
  animlist["Death"] = {
    framerate = 14,
    frames = {
      "Death001",
      "Death002",
      "Death003",
      "Death004",
      "Death005",
      "Death006",
      "Death007",
      "Death008",
      "Death009"
    }
  }

  animlist["Run"] = {
    framerate = 14,
    frames = {
      "fastZomb001",
      "fastZomb002",
      "fastZomb003",
      "fastZomb004",
      "fastZomb005",
      "fastZomb006",
      "fastZomb007",
      "fastZomb008",
      "fastZomb009"
    }
  }

  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TEXMATE(myAtlas,animlist,"Death",nil,nil,0,-30)

  self.collision = world:newRectangleCollider(300, 300, 50, 50, {collision_class = 'Player'})
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.3)
  self.collision.body:applyLinearImpulse(100,0,self.collision.body:getX()-30,self.collision.body:getY()-30)
end

function PL:update(dt)
  self.sprite:update(dt)

  --update the position of the sprite
  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  --update the rotation of the sprite.

end

function PL:draw()
  self.sprite:draw()
end

function PL:speak()
  print("Default!")
end

function PL:keypressed(key, isrepeat)

end

--Idle state
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local Idle = PL:addState('Idle')

function Idle:speak()
  print("Idle!")
end

function Idle:update(dt)

end

return PL
