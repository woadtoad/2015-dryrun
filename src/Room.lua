local world = require('src.world')

-- The room is the physical ground and walls in the world
local Room = CLASS('Room')

function Room:initialize()
  -- Setup room colliders, ground and walls
  self.ground = world:newRectangleCollider(0, 750, 1024, 50, {body_type = 'static'})
  self.lWall = world:newRectangleCollider(0, 0, 50, 800, {body_type = 'static'})
  self.rWall = world:newRectangleCollider(976, 0, 50, 800, {body_type = 'static'})
end

function Room:update(dt)
end

function Room:draw()
end

return Room;
