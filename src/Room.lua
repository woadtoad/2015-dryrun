local world = require('src.world')
local Bubble = require('src.Bubble')
local Quiver = require("src.Quiver")
local Coin = require('src.Coin')
local Platform = require('src.Platform')

-- The room is the physical ground and walls in the world
local Room = CLASS('Room')
Room.static.WALL_WIDTH = 1;
Room.static.WALL_HEIGHT = 800;

function Room:initialize()
  -- Setup room colliders, ground and walls
  self.ground = world:newRectangleCollider(0, 750, 1024, 50, {
    body_type = 'static',
    collision_class = 'RoomGround'
  })
  self.lWall = world:newRectangleCollider(-1, 0, Room.static.WALL_WIDTH+50, Room.static.WALL_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomWall'
  })
  self.rWall = world:newRectangleCollider(love.graphics.getWidth()-140, 0, Room.static.WALL_WIDTH, Room.static.WALL_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomWall'
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
        self:spawnPickup(bubble.collision.body:getPosition())

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
end

function Room:draw()

  --self.background:draw()
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
  local stepWidth = (love.graphics.getWidth()-300) / steps
  return math.floor(math.random(0, steps + 1)) * stepWidth
end

return Room
