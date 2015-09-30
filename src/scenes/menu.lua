local Scene = require('src.Scene')

local Menu = Scene.static.states.Menu

function Menu:initialize()
  chatbox = chatboxMaster(10, 200, 300, 390)

  button = UI.Button(10, 10, 90, 90)
end

function Menu:update(dt)
  chatbox:update(dt)
  button:update(dt)

  -- buttons have a bool
  if button.pressed then
    GameState:gotoState('Game')
  end

end

function Menu:draw()
  chatbox:draw()
  button:draw()
end

function Menu:keypressed(key, isrepeat)
  if key == "g" then
    GameState:gotoState('Game')
  else
    GameState:gotoState("Menu")
  end
end
