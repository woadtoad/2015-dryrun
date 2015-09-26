local world = require('src.world')

-- Room.lua
world:addCollisionClass('RoomWall')
world:addCollisionClass('RoomGround')

-- Bubble.lua
world:addCollisionClass('Bubble', {
  ignores = {'RoomGround'}
})
