local world = require('src.world')
local Room = require('src.Room')
local Platform = require('src.Platform')

local Game = SCENES:addState('Game')

local UPDATELIST = {}

function Game:initialize()
  -- Initialise the worlds collision classes, for everything to use
  require('src.collisionClasses')

  self.room = Room()
  table.insert(UPDATELIST, self.room)

  -- Platform
  self.platform = Platform()
  table.insert(UPDATELIST, self.platform)

  --Player Class
  player = require('src.player')

  --instantiate a new player.
  Archer = player:new(self.room) --this is bad but it'll work, the whole passing the self.room ref
  table.insert(UPDATELIST,Archer)
  self.room:start()
  --instantiate a text area
  --UI.DefaultTheme = Theme
  self.textArea = UI.Textarea(20,20,100,20)
  self.textArea:addText('help')

end

function Game:update(dt)

  if love.joystick.isDown then
    print("controller")
  end
  self.textArea:update(dt)
  world:update(dt)
  --Iterate through the items for update
  for i, v in pairs(UPDATELIST) do
    UPDATELIST[i]:update(dt)
  end

end

function Game:draw()

  --Debug Drawing for physics
  world:draw()
  self.textArea:draw()
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
