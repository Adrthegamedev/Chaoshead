local DS = require("libs.tyoeerUtils.datastructures")
local EntityPool = require("libs.tyoeerUtils.entitypool")
local Bitplane = require("tools.bitplane")
local OBJ = require("levelhead.level.object")
local PN = require("levelhead.level.pathNode")


local S = Class()

function S:initialize()
	self.mask = DS.grid()
	self.tiles = EntityPool:new()
	self.layers = {
		foreground = true,
		background = true,
		pathNodes = true,
	}
	self.nTiles = 0
end


-- EDITING


function S:setLayerEnabled(layer,enabled)
	self.layers[layer] = enabled
end

function S:getLayerEnabled(layer)
	return self.layers[layer]
end

function S:has(x,y)
	return self.mask[x][y]
end

--add & remove are quiet when the tile is already in/out the selection

function S:add(x,y)
	if not self.mask[x][y] then
		local tile = {
			x = x,
			y = y,
		}
		self.mask[x][y] = tile
		self.nTiles = self.nTiles + 1
		self.tiles:add(tile)
	end
end

function S:remove(x,y)
	if self.mask[x][y] then
		self.tiles:remove(self.mask[x][y])
		self.mask[x][y] = false
		self.nTiles = self.nTiles - 1
	end
end

-- RETRIEVING

function S:getBounds()
	local xMin, yMin = math.huge, math.huge
	local xMax, yMax = -math.huge, -math.huge
	for tile in self.tiles:iterate() do
		if tile.x < xMin then xMin = tile.x end
		if tile.x > xMax then xMax = tile.x end
		if tile.y < yMin then yMin = tile.y end
		if tile.y > yMax then yMax = tile.y end
	end
	return xMin, yMin, xMax, yMax
end

function S:getBitplane()
	local xMin, yMin, xMax, yMax = self:getBounds()
	
	local plane = Bitplane.new(xMax-xMin+1, yMax-yMin+1)
	for tile in self.tiles:iterate() do
		-- +1 because the Bitplane starts at (1,1)
		plane:set(tile.x-xMin+1, tile.y-yMin+1, true)
	end
	
	return plane, xMin, yMin
end

-- DRAWING

local colors = settings.theme.levelEditor.colors

function S:drawTile(x,y)
	local xx, yy = x*TILE_SIZE, y*TILE_SIZE
	if self.layers.background then
		love.graphics.setColor(colors.backgroundObject.selected)
		love.graphics.setLineWidth(1)
		
		love.graphics.translate(xx,yy)
		love.graphics.polygon("line",OBJ.backgroundShape)
		love.graphics.translate(-xx,-yy)
	end
	if self.layers.pathNodes then
		love.graphics.setColor(colors.pathNode.selected)
		love.graphics.setLineWidth(math.sqrt(2)/2)
		
		love.graphics.translate(xx,yy)
		love.graphics.polygon("line",PN.shape)
		love.graphics.translate(-xx,-yy)
	end
	if self.layers.foreground then
		love.graphics.setColor(colors.foregroundObject.selected)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line",xx+0.5,yy+0.5,TILE_SIZE-1,TILE_SIZE-1)
	end
end

function S:draw(startX,startY, endX,endY)
	local drawArea = math.abs( (startX-endX+1) * (startY-endY+1) )
	
	if drawArea >= self.nTiles then
		for tile in self.tiles:iterate() do
			self:drawTile(tile.x, tile.y)
		end
	else
		for x = startX, endX, 1 do
			for y = startY, endY, 1 do
				if self.mask[x][y] then
					self:drawTile(x,y)
				end
			end
		end
	end
end


return S
