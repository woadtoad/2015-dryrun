local world = require('src.world')

-- Room.lua
world:addCollisionClass('RoomWall')
world:addCollisionClass('RoomRoof')
world:addCollisionClass('RoomGround')
world:addCollisionClass('RoomDeadZone')

-- Player.lua
world:addCollisionClass('Player')

-- Platform.lua
world:addCollisionClass('Platform', {
  ignores = {'RoomRoof'}
})

-- Cauldron.lua
world:addCollisionClass('Cauldron', {
  ignores = {'Player'}
})

-- Bubble.lua
world:addCollisionClass('Bubble', {
  ignores = {'RoomGround', 'RoomRoof'}
})

-- Coin.lua
world:addCollisionClass('Coin', {
  ignores = {'RoomGround', 'Player'}
})

-- Arrow.lua
world:addCollisionClass('ArrowHead', {
  ignores = {'Bubble', 'Player'}
})
world:addCollisionClass('ArrowShaft', {
  ignores = {'Bubble', 'Player'}
})
