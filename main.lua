


toad = [[

                                             ,▄▄▄▄▄,
                                         .▄▓█▀▀▀▀▀▀▀█▓▄
                                       ▄██▀`         ╙▀██▄
                                    ▄▓█▀└      ▄▓████▓▄.▀██
                                  #█▀╙       ▓███.@████▀ ╙██
                                ▄█▀`    ▄▄, ██ ▀█▄, ,▄▄▓▓███"
                               ▓█▀      ▀▀" █▌  └▀▀▀▀▀▀▀╙██∩
                              ƒ█▀      .▄▄  ██           ▀█▌
                              ██    ██─╚██   ▀█▄          ╙█▌
                              ██             ╒███▓▄        ▐█
                              ███▓▓▓▓▄▄      ██" ╙▀█▓▄     ▐█
                              ██▓▄  ╙▀▀█▄   ╒██     ╙▀█▓▄ ▓█"
                              ╙███▀▓▄▄ └██ ▄█▀██▄     ▄████í
                                ▀█▓,,└  ║██▀   ▀▀██▓▓▄▄█████▄
                                  ╙▀▀██████#▓▓▓▓███▀▀▀▀▀▀▀▀▀└
                                        .└└└└

  888       888 .d88888b.        d88888888888b.88888888888 .d88888b.        d88888888888b.
  888   o   888d88P" "Y88b      d88888888  "Y88b   888    d88P" "Y88b      d88888888  "Y88b
  888  d8b  888888     888     d88P888888    888   888    888     888     d88P888888    888
  888 d888b 888888     888    d88P 888888    888   888    888     888    d88P 888888    888
  888d88888b888888     888   d88P  888888    888   888    888     888   d88P  888888    888
  88888P Y88888888     888  d88P   888888    888   888    888     888  d88P   888888    888
  8888P   Y8888Y88b. .d88P d8888888888888  .d88P   888    Y88b. .d88P d8888888888888  .d88P
  888P     Y888 "Y88888P" d88P     8888888888P"    888     "Y88888P" d88P     8888888888P"

]]

DEBUG_MODES = {
  SHOW_GAME = 0,
  SHOW_GAME_AND_COLLISION = 1,
  SHOW_ONLY_COLLISION = 2
}
DEBUG = DEBUG_MODES.SHOW_GAME

local debugCliArg = arg[2]
if debugCliArg then
  if string.find(debugCliArg, '^--debug') ~= nil then
    local debugValue = tonumber(string.match(debugCliArg, '^--debug=(%d)'))

    DEBUG = debugValue or DEBUG_MODES.SHOW_GAME_AND_COLLISION
  end
end

--CLASSES -- lua doesn't have classes by default, so this library handles it.
CLASS = require("libs.middleclass")

--JUMPER -- THIS LIBRARY HANDLES ANY PATH FINDING WE MAY WANT! it takes a 2d grid.
JUMPER = require("libs.jumper.pathfinder")

--STI -- Tilemap loader. We can use tiled to bring in level maps.
STI = require("libs.sti.init")

--STATE MANAGER -- Nice clean state management -- https://github.com/kikito/stateful.lua
STATEFUL = require("libs.stateful")

--UI MANAGER -- using thrandui for this. It's much cleaner than loveframes  https://github.com/adonaac/thranduil/blob/master/README.md
UI = require("libs.thranduil.ui")
Theme  = require("libs.thranduil.Theme")
chatboxMaster = require('libs.thranduil.Chatbox')
UI.DefaultTheme = Theme

--SOUND --Just makes sound so much easier to handle
TESound = require("libs.TESound")

INPUT = require("libs.boipushy.Input")()

--COLISSION MANAGER
HARDON = require("libs.hardoncollider")
"platform/Platform_0000"
--Texmate is my own personal animation library for texture packer.
TEXMATE = require("libs.TexMate")
TEXMATESTATIC = require("libs.TexMateStatic")
--TIMER!
TIMER = require("libs.hump.timer")

--TWEEN
TWEEN = require("libs.tween.tween")

CAMERA = require("libs.hump.camera")

--VECTOR CLASS
VECTOR = require("libs.hump.vector")

--HXDX --https://github.com/adonaac/hxdx
HX = require("libs.hxdx")

--My fancy atlas importer. Use the corona exporter from texturepacker
AtlasImporter = require("libs.AtlasImporter")

--CUPID! dev console and hot loading.
--cupid = require("libs.cupid")

--Adds the entities folder to the lookup path
package.path = package.path .. ';assets/entities/?.lua'

------------------------------------------------------------------------------------------------------------------------------------------------------------
--GLOBALS
------------------------------------------------------------------------------------------------------------------------------------------------------------

--Call out global functions here for cleanliness sake!

myAtlas = AtlasImporter.loadAtlasTexturePacker("assets.entities.entitiesC","assets/entities/entitiesC.png")
bgAtlas = AtlasImporter.loadAtlasTexturePacker("assets.entities.Background","assets/entities/Background.png")

--Makes a class that controls the game state.
SCENES = CLASS('Menu')
SCENES:include(STATEFUL)

require("menu")
require("game")

--initializes the game state. Statemanager is a generic class based statemanager, where i chose to keep it simple and do some not so ideal stuff to avoid needing another library. We can swap this out if you don't like it.
--The main drawback of this method is the lack of nice animations between scenes, oh well
GameState = SCENES:new()
GameState:gotoState("Game")
GameState:initialize()
GameState:gotoState("Menu")
GameState:initialize()

GameState:gotoState("Game")


------------------------------------------------------------------------------------------------------------------------------------------------------------
--CALLBACKS
------------------------------------------------------------------------------------------------------------------------------------------------------------

--These call backs are what love calls. Pay attention to how love.update passes a delta time, we use this to make the game framerate independent.

--love.load really isn't a nessecary thing, it just exists to make things neat
function love.load()
  UI.registerEvents()
  love.graphics.setBackgroundColor( 100,100,100 )

  print("welcome")

end

function love.update(dt)
  --passes the update callback to the gamestate
  GameState:update(dt)

end

function love.draw()

  --passes the drawcallback to the gamestate
  GameState:draw()

  --check for joystick, debug.
  local joysticks = love.joystick.getJoysticks()
  for i, joystick in ipairs(joysticks) do
    love.graphics.print(joystick:getName(), 300, i * 20)
  end

end

function love.keypressed(key, isrepeat)

  GameState:keypressed(key, isrepeat)

end
