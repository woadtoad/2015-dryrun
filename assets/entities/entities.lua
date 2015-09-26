-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:74da0b9c05315ea1a74e44ec8604bc44:a7583183347e5cd695df8a48dd4b0425:62588ab9a1a47639b20e953a1cfac427$
--
--[[------------------------------------------------------------------------
-- Example Usage --

function love.load()
	myAtlas = require("entities")
	batch = love.graphics.newSpriteBatch( myAtlas.texture, 100, "stream" )
end
function love.draw()
	batch:clear()
	batch:bind()
		batch:add( myAtlas.quads['mySpriteName'], love.mouse.getX(), love.mouse.getY() )
	batch:unbind()
	love.graphics.draw(batch)
end

--]]------------------------------------------------------------------------

local TextureAtlas = {}
local Quads = {}
local Texture = love.graphics.newImage( "assets/entities/entities.png" )

Quads["Death001"] = love.graphics.newQuad(208, 2, 38, 50, 388, 64 )
Quads["Death002"] = love.graphics.newQuad(108, 2, 40, 60, 388, 64 )
Quads["Death003"] = love.graphics.newQuad(2, 2, 52, 60, 388, 64 )
Quads["Death004"] = love.graphics.newQuad(56, 2, 50, 60, 388, 64 )
Quads["Death005"] = love.graphics.newQuad(150, 2, 56, 58, 388, 64 )
Quads["Death006"] = love.graphics.newQuad(248, 2, 66, 48, 388, 64 )
Quads["Death007"] = love.graphics.newQuad(316, 2, 70, 42, 388, 64 )
Quads["Death008"] = love.graphics.newQuad(316, 46, 52, 14, 388, 64 )
Quads["Death009"] = love.graphics.newQuad(316, 46, 52, 14, 388, 64 )

function TextureAtlas:getDimensions(quadName)
	local quad = self.quads[quadName]
	if not quad then
		return nil 
	end
	local x, y, w, h = quad:getViewport()
    return w, h
end

TextureAtlas.quads = Quads
TextureAtlas.texture = Texture

return TextureAtlas
