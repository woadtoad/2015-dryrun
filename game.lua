local world = require('src.world')
local Room = require('src.Room')


local Game = SCENES:addState('Game')

local UPDATELIST = {}

function Game:initialize()
  -- Initialise the worlds collision classes, for everything to use
  require('src.collisionClasses')

  self.room = Room()
  table.insert(UPDATELIST, self.room)


  --Player Class
  player = require('src.Player')

  --instantiate a new player.
  Archer = player:new(self.room) --this is bad but it'll work, the whole passing the self.room ref
  table.insert(UPDATELIST,Archer)
  self.room:start()
  --instantiate a text area
  self.textArea = UI.Textarea(20,20,100,40, {editing_locked = true})
  table.insert(UPDATELIST, self.textArea)
  self.textArea:addText('pls sned heldp')

  self.endTextScale = 1
  self.endTextNegation = 1
  self.endTextScaleDirection = true

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

  self.endTextScale = (self.endTextScale + ((0.7 * dt) * self.endTextNegation))
  if self.endTextScaleDirection and self.endTextScale > 2 then
    self.endTextNegation = -1
    self.endTextScaleDirection = false
  end
  if not self.endTextScaleDirection and self.endTextScale < 1 then
    self.endTextNegation = 1
    self.endTextScaleDirection = true
  end

end

function Game:draw()

  if DEBUG == DEBUG_MODES.SHOW_GAME or DEBUG == DEBUG_MODES.SHOW_GAME_AND_COLLISION then
    --Iterate through the items for drawing
      for i, v in pairs(UPDATELIST) do
        UPDATELIST[i]:draw()
      end
  end

  if DEBUG == DEBUG_MODES.SHOW_GAME_AND_COLLISION or DEBUG == DEBUG_MODES.SHOW_ONLY_COLLISION then
    --Debug Drawing for physics
    world:draw()
  end

  if self.room.cauldronDropped then
    love.graphics.printf('You\'ve been kicked out of the sauna!', love.graphics.getWidth() / 2 - (125 / 2) - (Room.static.WALL_WIDTH), love.window.getHeight() / 2 - (125 / 2), 125, "center", 0, self.endTextScale)
  end

end



function Game:drawFromUpdateList()
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
