local world = require('src.world')
local Bubble = require('src.Bubble')
local Quiver = require("src.Quiver")

-- The room is the physical ground and walls in the world
local Room = CLASS('Room')
Room.static.WALL_WIDTH = 50;
Room.static.WALL_HEIGHT = 800;

function Room:initialize()
  -- Setup room colliders, ground and walls
  self.ground = world:newRectangleCollider(0, 750, 1024, 50, {
    body_type = 'static',
    collision_class = 'RoomGround'
  })
  self.lWall = world:newRectangleCollider(0, 0, Room.static.WALL_WIDTH, Room.static.WALL_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomWall'
  })
  self.rWall = world:newRectangleCollider(976, 0, Room.static.WALL_WIDTH, Room.static.WALL_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomWall'
  })

  -- arrow constructor class
  self.quiver = Quiver:new()

  -- Bubble state
  self.bubbles = {}
  self.hasBubbles = false
  self.bubbleSpeedMod = 1
  self.bubbleSpeedAccel = 5 -- gravity
  self.bubbleSecondsBetween = 2
  self.bubbleTimer = -1 -- start straight away
end

function Room:update(dt)
  self.quiver.update(self.quiver, dt)

  if self.hasBubbles then
    self:attemptToCreateBubble(dt)

    for i,bubble in ipairs(self.bubbles) do
      if bubble.health > 0 then
        bubble:update(dt)
      else
        bubble:destroy()
        table.remove(self.bubbles, i)
      end
    end
  end
end

function Room:draw()
  for i,bubble in ipairs(self.bubbles) do
    bubble:draw()
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
    local xSteps = 16
    local xStepWidth = love.graphics.getWidth() / xSteps
    local randomX = math.floor(math.random(0, xSteps + 1)) * xStepWidth

    local bubbleRadius = 35

    local bubble = Bubble(randomX, love.graphics.getHeight() + bubbleRadius * 2, bubbleRadius);
    table.insert(self.bubbles, bubble)
    self:resetBubbleTimer()
  end
end

function Room:resetBubbleTimer()
  self.bubbleTimer = 100 * self.bubbleSecondsBetween
end

return Room
