local world = require('src.world')
local Bubble = require('src.Bubble')
local Quiver = require("src.Quiver")
local Coin = require('src.Coin')
local Platform = require('src.Platform')

-- The room is the physical ground and walls in the world
local Room = CLASS('Room')
Room.static.WALL_WIDTH = 50;
Room.static.WALL_HEIGHT = 800 * 2; -- allows easy trapping of bubbles into deadzone
Room.static.WALL_RIGHT_OFFSET = -140;
Room.static.GROUND_HEIGHT = 50;
Room.static.ROOF_HEIGHT = 50;

function Room:initialize()
  -- Setup room physicals
  self.ground = world:newRectangleCollider(0, 750, love.graphics.getWidth(), Room.static.GROUND_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomGround'
  })
  self.roof = world:newRectangleCollider(0, -Room.static.ROOF_HEIGHT, love.graphics.getWidth(), Room.static.ROOF_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomRoof'
  })
  self.lWall = world:newRectangleCollider(-1, 0 - (Room.static.WALL_HEIGHT / 2 / 2), Room.static.WALL_WIDTH, Room.static.WALL_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomWall'
  })
  self.rWall = world:newRectangleCollider(love.graphics.getWidth() + Room.static.WALL_RIGHT_OFFSET, 0 - (Room.static.WALL_HEIGHT / 2 / 2), Room.static.WALL_WIDTH, Room.static.WALL_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomWall'
  })

  -- Setup room dead zones
  self.deadZone = world:newRectangleCollider(0, -Room.static.ROOF_HEIGHT - 100, love.graphics.getWidth(), Room.static.ROOF_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomDeadZone'
  })

  -- arrow constructor class
  self.quiver = Quiver:new(3)

  -- Bubble state
  self.bubbles = {}
  self.hasBubbles = false
  self.bubbleSpeedMod = 1
  self.bubbleSpeedAccel = 5 -- gravity
  self.bubbleSecondsBetween = 2
  self.bubbleTimer = -1 -- start straight away

  -- pickups state
  self.pickups = {}

  self.background = TEXMATESTATIC(bgAtlas,"Background/Background_0000",-2,798)
  self.wallLeft = TEXMATESTATIC(bgAtlas,"Walls/Wall1_0000",420,800)
  self.wallRight = TEXMATESTATIC(bgAtlas,"Walls/Wall2_0000",-530,800)
  self.ground = TEXMATESTATIC(bgAtlas,"floor/Floor_0000",-40,1200)

    -- Platform
  self.platform = Platform(-55,0,0.8)

end

function Room:update(dt)
  self.quiver:update(dt)
  self.platform:update(dt)

  if self.hasBubbles then
    self:attemptToCreateBubble(dt)

    for i,bubble in ipairs(self.bubbles) do
      if bubble.health > 0 then
        bubble:update(dt)
      else
        if bubble.hasBurst then
          self:spawnPickup(bubble.collision.body:getPosition())
        end

        bubble:destroy()
        table.remove(self.bubbles, i)
      end
    end

    for i,pickup in ipairs(self.pickups) do
      if not pickup.pickedUp then
        pickup:update(dt)
      else
        pickup:destroy()
        table.remove(self.pickups, i)
      end
    end
  end

  -- destroy things on the deadzone
  for i,collisionClassName in ipairs({'Bubble'}) do
    if self.deadZone:enter(collisionClassName) then
      local _, dead = self.deadZone:enter(collisionClassName)
      if dead.parent.expire then
        dead.parent:expire()
      end
    end
  end
end

function Room:draw()

  self.background:draw()
  self.wallLeft:draw()
  self.wallRight:draw()
  self.ground:draw()
  self.platform:draw()

  for i,bubble in ipairs(self.bubbles) do
    bubble:draw()
  end

  for i,pickup in ipairs(self.pickups) do
    pickup:draw()
  end

  self.quiver.draw(self.quiver)

end

function Room:start()
  self.hasBubbles = true
end

function Room:stop()
  self.hasBubbles = false
end

function Room:attemptToCreateBubble(dt)
  self.bubbleTimer = self.bubbleTimer - 100 * dt

  if self.bubbleTimer < 0 then
    local bubbleRadius = 35

    local bubble = Bubble(Room:getRandXSpawn(), love.graphics.getHeight() + bubbleRadius * 2, bubbleRadius, math.random(300,1000)/1000 );
    table.insert(self.bubbles, bubble)
    self:resetBubbleTimer()
  end
end

function Room:resetBubbleTimer()
  self.bubbleTimer = 100 * self.bubbleSecondsBetween
end

-- Spawn a powerup at a position
function Room:spawnPickup(x, y)
  if(x and y) then
    local coin = Coin(x, y, 15);
    table.insert(self.pickups, coin)
  end
end

function Room:getRandXSpawn(steps)
  steps = steps or 16
  local stepWidth = (love.graphics.getWidth() - (Room.static.WALL_WIDTH * 2) + Room.static.WALL_RIGHT_OFFSET) / steps
  return Room.static.WALL_WIDTH + math.floor(math.random(0, steps + 1)) * stepWidth
end

return Room
