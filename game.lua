local world = require('src.world')
local Room = require('src.Room')

local Game = SCENES:addState('Game')

local UPDATELIST = {}

function Game:initialize()
  self.room = Room:new()

  --Player Class
  player = require('src.player')

  --instantiate a new player.
  Archer = player:new(self.room) --this is bad but it'll work, the whole passing the self.room ref

  --we'll just use a simple table to keep things updated
  table.insert(UPDATELIST,Archer)
end

function Game:update(dt)

  if love.joystick.isDown then
    print("controller")
  end

  world:update(dt)

  --Iterate through the items for update
  for i, v in pairs(UPDATELIST) do
    UPDATELIST[i]:update(dt)
  end

end

function Game:draw()

  --Debug Drawing for physics
  world:draw()

  --Iterate through the items for drawing
  for i, v in pairs(UPDATELIST) do
    UPDATELIST[i]:draw()
  end

end

function Game:keypressed(key, isrepeat)

  --Test stuff
  if key == "g" then
    GameState:gotoState('Game')
  elseif key =="m" then
    GameState:gotoState("Menu")
  end

  if key =="x" then
    Archer:speak()
  end

  if key =="z" then
    Archer:gotoState("Idle")
  end

end
