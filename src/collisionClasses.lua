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
