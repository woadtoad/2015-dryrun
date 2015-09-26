--Class commons library
--require("middleclass")
--require("middleclass-commons")
--class = require("30log")
class = require("slither")

AtlasImporter = require("AtlasImporter")
TexMate = require("TexMate")

function love.load ()

    --Load atlas you want to use

    --myAtlas = AtlasImporter.loadAtlasShoeBox("ASSETS/sprites","ASSETS/sprites.png")
    myAtlas = AtlasImporter.loadAtlasTexturePacker("ASSETS/spriteTP2","ASSETS/spriteTP.png")

    -- use the exporter marked Corona TM SDK from texture packer. 
    -- If using shoebox, use the settings file provided

    animlist = {}
    animlist["Death"] = {
        framerate = 14,
        frames = {
                "Death001",
                "Death002",
                "Death003",

                }
        }

    animlist["Run"] = {
        framerate = 14,
        frames = {
                "fastZomb002",
                "fastZomb003",
                "fastZomb004",
                }
        }

    --make the sprite , arguments: atlas, animlist, defaultanim, x, y, pivotx, pivoty, rotation
    --Pivot x and y is an offset from the center of the image.

    sprite = TexMate(myAtlas,animlist,"Death",nil,nil,0,-30)

    sprite:changeAnim("Run")

end

function love.update(dt)
    sprite:update(dt)
end

function love.draw()
    sprite:draw()
end