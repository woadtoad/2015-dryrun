local world = require("src.world")

local PL = CLASS('player')
PL:include(STATEFUL)

--Default state
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

function PL:initialize()
  self.Health = 10

  --this is how we setup the animations, I may write a
  --convinence function to make generating the file names easier. so it would be a functuon that takes the name then the range of numbers to go between and return the values.
  bodyAnimList = {}
  bodyAnimList["Death"] = {
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

  bodyAnimList["Run"] = {
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

  bowAnimList = {}
  bowAnimList["std"] = {
    framerate = 14,
    frames = {
      "Bow",
    }
  }


  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TEXMATE(myAtlas,bodyAnimList,"Death",nil,nil,0,-30)
  self.bowSprite = TEXMATE(myAtlas,bowAnimList,"std",nil,nil,0,-30)

  self.collision = world:newRectangleCollider(300, 300, 50, 50, {collision_class = 'Player'})
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0) -- no bouncing for char.

  INPUT:bind('leftx', 'move')
  INPUT:bind('rightx','bowx')
  INPUT:bind('righty','bowy')
end

function PL:update(dt)
  self.sprite:update(dt)
  self.bowSprite:update(dt)

  --update the position of the sprite
  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  self.bowSprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.bowSprite:changeRot(math.deg(self.collision.body:getAngle()))
  --input
  if INPUT:down('move') then self:moveX(INPUT:down('move')) end
  if INPUT:down('bowx') then self:rotBow(INPUT:down('bowx'),INPUT:down('bowy')) end
end

function PL:moveX(dir)
  local speed = 50 * dir

  if dir > 0.3 or dir < -0.3 then
    self.sprite:changeAnim("Run",dir)
    self.collision.body:applyLinearImpulse(speed,0,self.collision.body:getX(),self.collision.body:getY())
  else
    self.sprite:changeAnim("Death",dir)
  end

end

function PL:rotBow(x,y)
  local vector = VECTOR(x,y)

  self.bowSprite:changeRotVec(vector)
end

function PL:draw()
  self.sprite:draw()
  self.bowSprite:draw()
end

function PL:speak()
  print("Default!")
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
