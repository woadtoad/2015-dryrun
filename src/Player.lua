local world = require("src.world")


local PL = CLASS('Player')
PL:include(STATEFUL)

--Default state
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

function PL:initialize(room)
  self.Health = 10
  self.shootTimer = 0
  self.room  = room
  self.vector = VECTOR(0,0)
  self.defaultVec = VECTOR(0,0)
  self.resetNo = 1
  --this is how we setup the animations, I may write a
  --convinence function to make generating the file names easier. so it would be a functuon that takes the name then the range of numbers to go between and return the values.
  local bodyAnimList = {}
  bodyAnimList["Death"] = {
    framerate = 14,
    frames = {
            "Skid/Skid_0000",
    }
  }

  bodyAnimList["Run"] = {
    framerate = 10,
    frames = {
            "Run/Run_0000",
            "Run/Run_0001",
            "Run/Run_0002",
            "Run/Run_0003",
            "Run/Run_0004",
            "Run/Run_0005",
            "Run/Run_0006",
            "Run/Run_0007",
            "Run/Run_0008",
            "Run/Run_0009",
            "Run/Run_0010",
            "Run/Run_0011",
            "Run/Run_0012",
            "Run/Run_0013",
            "Run/Run_0014",
    }
  }

  local bowAnimList = {}
  bowAnimList["std"] = {
    framerate = 14,
    frames = {
      "Bow/Bow_0000",
    }
  }

  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TEXMATE(myAtlas,bodyAnimList,"Death",nil,nil,-12,0,nil,true)
  self.bowSprite = TEXMATE(myAtlas,bowAnimList,"std",nil,nil,-15,-60)
  self.sprite.endCallback["Run"] = function() print("run") end

  self.collision = world:newCircleCollider(love.graphics.getWidth() / 2, (love.graphics.getHeight() / 2) + 200, 23, {collision_class = 'Player'})
  self.collision.body:setFixedRotation(true)
  self.collision.fixtures['main']:setRestitution(0) -- no bouncing for char.

  INPUT:bind('leftx', 'move')
  INPUT:bind('rightx','bowx')
  INPUT:bind('righty','bowy')
  INPUT:bind('fdown','shoot')
  INPUT:bind('r2','shoot')

  self.anim = {bowHeight = 10}

  self.tween = TWEEN.new(1, self.anim, {bowHeight = 30}, 'inOutSine')

end



function PL:update(dt)
  self.sprite:update(dt)
  self.bowSprite:update(dt)

  --bow float anim. This is such a messy way of doing this.
  local reset = self.tween:update(dt)
  if reset then
    if self.resetNo == 1 then
      self.tween = TWEEN.new(1, self.anim, {bowHeight = 10}, 'inOutSine')
      self.resetNo = 0
    else
      self.resetNo = 1
      self.tween = TWEEN.new(1, self.anim, {bowHeight = 30}, 'inOutSine')
    end
  end

  --update the position of the sprite
  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  self.bowSprite:changeLoc(self.collision.body:getX(),self.collision.body:getY()+self.anim.bowHeight)
  self.bowSprite:changeRot(math.deg(self.collision.body:getAngle()))

  --input
  if INPUT:down('move') then self:moveX(INPUT:down('move')) end
  if INPUT:down('bowx') then self:rotBow(INPUT:down('bowx'),INPUT:down('bowy')) end
  if INPUT:down('shoot') then self:shoot(dt,INPUT:down('shoot')) end

  -- Player stomps arrow into dust
  for i, collisionClassName in ipairs({'ArrowHead', 'ArrowShaft'}) do
    if self.collision:enter(collisionClassName) then
      local _, arrow = self.collision:enter(collisionClassName)

      -- only stomp arrows that are 1 second or older
      if arrow.parent.aliveTime > 1 then
        arrow.parent:expire()
      end
    end
  end

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

  distance = self.vector:dist(self.defaultVec)

  if distance > 0.3 then self.bowSprite:changeRotVec(self.vector) end

end

function PL:shoot(dt,isinput)
  -- isinput is just if there is no input.
  if isinput == 0 then return end

  self.shootTimer = self.shootTimer - 100 * dt

  --Adds a shoot delay
  if self.shootTimer < 0 then

    if SCENES.room then print("rest") end

    self.room.quiver:forgeArrow(self.collision.body:getX(),self.collision.body:getY()-100,self.vector)
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
