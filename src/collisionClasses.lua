local world = require('src.world')

-- Room.lua
world:addCollisionClass('RoomWall')
world:addCollisionClass('RoomGround')

-- Player.lua
world:addCollisionClass('Player')

-- Bubble.lua
world:addCollisionClass('Bubble', {
  ignores = {'RoomGround'}
})

-- Arrow.lua
world:addCollisionClass('Arrow', {
  ignores = {'Bubble'}
})
