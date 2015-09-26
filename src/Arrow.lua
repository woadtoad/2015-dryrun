local world = require("src.world")

local Arrow = CLASS('Arrow')
Arrow:include(STATEFUL)


function Arrow:initialize(x,y,vec)

  local angle = math.deg(math.atan2(vec.y,vec.x))

  self.collision = world:newCircleCollider(x or 100, y or 100, 5, {collision_class = 'Arrow'})
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.6)

  self.collision2 = world:newRectangleCollider(x or 100, y+30 or 100, 3,30,{collision_class = 'Arrow'})
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

end

function Arrow:draw()
  self.sprite:draw()
end

function Arrow:update(dt)
  self.sprite:update(dt)

  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  -- Burst on an bubble with the arrow peirces it
  if self.collision:enter('Bubble') then
    local _, bubble = self.collision:enter('Bubble')
    bubble.parent:burst()
  end
end



return Arrow
