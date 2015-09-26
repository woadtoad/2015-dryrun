local world = require("src.world")


local PL = CLASS('player')
PL:include(STATEFUL)

--Default state
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

function PL:initialize(room)
  self.Health = 10
  self.shootTimer = 0
  self.room  = room
  self.vector = VECTOR(0,0)
  --this is how we setup the animations, I may write a
  --convinence function to make generating the file names easier. so it would be a functuon that takes the name then the range of numbers to go between and return the values.
  bodyAnimList = {}
  bodyAnimList["Death"] = {
    framerate = 14,
    frames = {
      "Death001.png",
      "Death002.png",
      "Death003.png",
      "Death004.png",
      "Death005.png",
      "Death006.png",
      "Death007.png",
      "Death008.png",
      "Death009.png"
    }
  }

  bodyAnimList["Run"] = {
    framerate = 14,
    frames = {
      "fastZomb001.png",
      "fastZomb002.png",
      "fastZomb003.png",
      "fastZomb004.png",
      "fastZomb005.png",
      "fastZomb006.png",
      "fastZomb007.png",
      "fastZomb008.png",
      "fastZomb009.png"
    }
  }

  bowAnimList = {}
  bowAnimList["std"] = {
    framerate = 14,
    frames = {
      "Bow.png",
    }
  }

  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TEXMATE(myAtlas,bodyAnimList,"Death",nil,nil,0,-30)
  self.bowSprite = TEXMATE(myAtlas,bowAnimList,"std",nil,nil,0,-30)
  self.sprite.endCallback["Run"] = function() print("run") end

  self.collision = world:newRectangleCollider(300, 300, 50, 50, {collision_class = 'Player'})
  self.collision.body:setFixedRotation(true)
  self.collision.fixtures['main']:setRestitution(0) -- no bouncing for char.

  INPUT:bind('leftx', 'move')
  INPUT:bind('rightx','bowx')
  INPUT:bind('righty','bowy')
  INPUT:bind('fdown','shoot')
  INPUT:bind('r2','shoot')

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
  if INPUT:down('shoot') then self:shoot(dt,INPUT:down('shoot')) end

  self.shootTimer = self.shootTimer - 100 * dt
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
  self.vector = VECTOR(x,y)

  self.bowSprite:changeRotVec(self.vector)
end

function PL:shoot(dt,isinput)
  -- isinput is just if there is no input.
  if isinput == 0 then return end

  self.shootTimer = self.shootTimer - 100 * dt

  --Adds a shoot delay
  if self.shootTimer < 0 then

    if SCENES.room then print("rest") end

    self.room.quiver:forgeArrow(self.collision.body:getX(),self.collision.body:getY()-200,self.vector)
    self.shootTimer = 100

  end

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
