local Game = SCENES:addState('Game')

local UPDATELIST = {}

function Game:initialize()
  --Player Class
  player = require('src.player')

  --we are using box 2d in this example, and i am using a little library called hxcx which simplifies using box 2d a ton, but we still have access to the core mappings so it's a win win for us.
  world = HX.newWorld({gravity_y = 70})

  world:addCollisionClass('Ghost')
  world:collisionClassesSet()

  --level Collission
  ground = world:newRectangleCollider(0, 750, 1024, 50, {body_type = 'static'})
  lWall = world:newRectangleCollider(0, 0, 50, 800, {body_type = 'static'})
  RWall = world:newRectangleCollider(976, 0, 50, 800, {body_type = 'static'})

  --instantiate a new player.
  Archer = player:new()

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

  --Iterate through the items for update
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
