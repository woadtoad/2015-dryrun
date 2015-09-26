local world = require('src.world')

-- Room.lua
world:addCollisionClass('RoomWall')
world:addCollisionClass('RoomGround')

-- Player.lua
world:addCollisionClass('Player')

-- Platform.lua
world:addCollisionClass('Platform')

-- Bubble.lua
world:addCollisionClass('Bubble', {
  ignores = {'RoomGround'}
})

-- Arrow.lua
world:addCollisionClass('ArrowHead', {
  ignores = {'Bubble'}
})
world:addCollisionClass('ArrowShaft', {
  ignores = {'Bubble'}
})
