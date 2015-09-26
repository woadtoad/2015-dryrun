local world = require('src.world')
local Bubble = require('src.Bubble')
local Quiver = require("src.Quiver")

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
  self.lWall = world:newRectangleCollider(-1, 0, Room.static.WALL_WIDTH, Room.static.WALL_HEIGHT, {
    body_type = 'static',
    collision_class = 'RoomWall'
  })
  self.rWall = world:newRectangleCollider(love.graphics.getWidth(), 0, Room.static.WALL_WIDTH, Room.static.WALL_HEIGHT, {
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

  self.backgroudTexture = love.graphics.newImage("assets/entities/Background.png")
end

function Room:update(dt)
  self.quiver:update(dt)

  if self.hasBubbles then
    self:attemptToCreateBubble(dt)

    for i,bubble in ipairs(self.bubbles) do
      if bubble.health > 0 then
        bubble:update(dt)
      else
        pos = VECTOR(bubble.collision.body:getX(),bubble.collision.body:getY())
        Room:spawnPowerup(pos)
        bubble:destroy()
        table.remove(self.bubbles, i)
      end
    end
  end
end

function Room:draw()

  --love.graphics.draw(self.backgroudTexture, 0,0,0,1,1)

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

function Room:spawnPowerup(position)
  if(position.x and position.y) then
    print(position)
  end
end

return Room
