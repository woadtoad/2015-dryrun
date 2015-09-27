local world = require('src.world')
local Timer = require('libs.hump.timer')

local Arrow = CLASS('Arrow')
Arrow:include(STATEFUL)


function Arrow:initialize(x,y,vec)



  local angle = math.deg(math.atan2(vec.y,vec.x))

  self.collision = world:newCircleCollider(x or 100, y or 100, 5, {collision_class = 'ArrowHead'})
  self.collision.parent = self
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.6)

  self.collision2 = world:newRectangleCollider(x or 100, y+30 or 100, 3,30,{collision_class = 'ArrowShaft'})
  self.collision2.parent = self
  self.collision2.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.3)

  self.weld = world:addJoint('WeldJoint', self.collision2.body, self.collision.body, x, y, true)

  self.collision2.body:setLinearVelocity(2000*vec.x,2000*vec.y)
  self.collision2.body:setLinearDamping(1)

  self.collision.body:setAngle(math.rad(angle+90))
  self.collision2.body:setAngle(math.rad(angle+90))
  self.collision.body:setAngle(math.rad(angle+90))
  self.collision2.body:setAngle(math.rad(angle+90))

  local arrowAnimList = {}
  arrowAnimList = {}
  arrowAnimList["Idle"] = {
    framerate = 14,
    frames = {
          "Arrow/Arrow_0000",
    }
  }

  self.sprite = TEXMATE(myAtlas,arrowAnimList,"Idle",nil,nil,-8,20)

  self.aliveTime = 0 -- seconds
  self.canExpire = false
  self.timer = Timer.new()
  self.blinkCycle = 0

end

function Arrow:draw()
  if self.isVisible then
    self.sprite:draw()
  end
end

function Arrow:drawCheck(dt)
  local blinkSecondsStep = 0.5
  local emptyBlinkThreshold = 0.1

  self.blinkCycle = self.blinkCycle + dt
  if self.blinkCycle > blinkSecondsStep then
    self.blinkCycle = self.blinkCycle - blinkSecondsStep
  end

  if self.blinkCycle < emptyBlinkThreshold and self.isBlinking then
    self.isVisible = false
  else
    self.isVisible = true
  end
end

function Arrow:update(dt)
  self.sprite:update(dt)
  self.timer.update(dt)

  -- update alive time
  self.aliveTime = self.aliveTime + dt

  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  -- Burst on an bubble with the arrow peirces it
  if self.collision:enter('Bubble') and not self:stationary() then
    local _, bubble = self.collision:enter('Bubble')
    bubble.parent:burst()
  end

  -- Expire the arrow if this is enabled for the arrow
  if self.canExpire then
    if self:stationary() then
      self:queueExpire()
    else
      if self.hasQueuedExpire then
        self:resetExpire()
      end
    end
  end

  self:drawCheck(dt)
end

function Arrow:setExpiration(expireSeconds)
  self.canExpire = true
  self.expireSeconds = expireSeconds
end

function Arrow:queueExpire()
  if not self.hasQueuedExpire then
    -- this is the pre expire timer to avoid buggy timeout starting
    self.expireTimer = self.timer.add(1, function()
      -- this timer should not be canceled
      self.timer.add(self.expireSeconds, function() self:expire() end)
      self.isBlinking = true
    end)
    self.hasQueuedExpire = true
  end
end

function Arrow:resetExpire()
  self.hasQueuedExpire = false
  self.isBlinking = false
  if self.expireTimer then
    self.timer.cancel(self.expireTimer)
  end
end

function Arrow:expire()
  self.expired = true
end

function Arrow:stationary()
  local vx, vy = self.collision.body:getLinearVelocityFromWorldPoint(0, 0)
  return vx < 0.5 and vy < 0.5
end

function Arrow:destroy()
  self.collision.body:destroy()
  self.collision2.body:destroy()
end

return Arrow
