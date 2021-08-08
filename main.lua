


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
DEBUG_ZOOM = 1

local cliArgs = {}
for i=1,(#arg - 1) do
  table.insert(cliArgs, arg[i + 1])
end

-- TODO: refactor to cli args util, or use a lib
for i,cliArg in ipairs(cliArgs) do
  if string.find(cliArg, '^--debug') ~= nil then
    local debugValue = tonumber(string.match(cliArg, '^--debug=(%d)'))

    DEBUG = debugValue or DEBUG_MODES.SHOW_GAME_AND_COLLISION
  end

  if string.find(cliArg, '^--zoom') ~= nil then
    local debugValue = tonumber(string.match(cliArg, '^--zoom=(%d%.?%d?)'))

    DEBUG_ZOOM = debugValue or 0.5
  end
end

print('Info')
print('----')
print('DEBUG:      ' .. require('src.util').getkeyfromvalue(DEBUG_MODES, DEBUG))
print('DEBUG_ZOOM: ' .. DEBUG_ZOOM)
print('----\n')


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

CAMERA = require("libs.gamera.gamera")

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
Scene = require('src.Scene')

require('src.scenes.game')
require('src.scenes.menu')

GameScenes = Scene:new()
GameScenes:gotoState("Game")
GameScenes:initialize()
GameScenes:gotoState("Menu")
GameScenes:initialize()

GameScenes:gotoState("Game")

scale = 0

defaultCamPos = {500,420}

------------------------------------------------------------------------------------------------------------------------------------------------------------
--CALLBACKS
------------------------------------------------------------------------------------------------------------------------------------------------------------

--These call backs are what love calls. Pay attention to how love.update passes a delta time, we use this to make the game framerate independent.

--love.load really isn't a nessecary thing, it just exists to make things neat
function love.load()
    -- This is fine as relative, although that isn't mentioned in the docs
  local gamecontrollerdb_path = 'src/gamecontrollerdb/gamecontrollerdb.txt'
  local customdb_path = 'src/gamecontrollerdb/customdb.txt'

  if love.filesystem.exists(gamecontrollerdb_path) and love.filesystem.exists(customdb_path) then
    print('  Initializing gamepad mappings...')
    local loaded = love.joystick.loadGamepadMappings(gamecontrollerdb_path)
    local loaded = love.joystick.loadGamepadMappings(customdb_path)
    if loaded == false then
      print('    Failed')
    end
  end

  UI.registerEvents()
  love.graphics.setBackgroundColor( 100,100,100 )

  cam = CAMERA.new(-10000,-10000,20000,20000)

  cam:setScale(DEBUG_ZOOM)
  cam:setPosition(500,420)

end
local lurker = require('libs.lurker')


function love.update(dt)
  --passes the update callback to the gamestate
  GameScenes:update(dt)

  if DEBUG > 0 then
    lurker.update(dt)
  end
end

function love.draw()

  --passes the drawcallback to the gamestate
  cam:draw(function(l,t,w,h)
  -- draw camera stuff here
    GameScenes:draw()
  end)

end

function love.keypressed(key, isrepeat)

  GameScenes:keypressed(key, isrepeat)

end
