local Mask = require("tools.selection.mask")
local Contents = require("tools.selection.contents")

local T = Class()

function T:initialize(level)
	self.level = level
	self.mask = Mask:new()
	self.contents = Contents:new()
end


function T:draw(sx,sy,ex,ey)
	self.mask:draw(sx,sy,ex,ey)
end


function T:hasLayer(layer)
	return self.mask:getLayerEnabled(layer)
end

function T:removeLayer(layer)
	self.mask:setLayerEnabled(layer,false)
	self.contents:removeLayer(layer)
end


function T:add(x,y)
	self.mask:add(x,y)
	if self:hasLayer("foreground") then
		local obj = self.level.foreground[x][y]
		if obj then self.contents:addForeground(obj) end
	end
	if self:hasLayer("background") then
		local obj = self.level.background[x][y]
		if obj then self.contents:addBackground(obj) end
	end
	if self:hasLayer("pathNodes") then
		local obj = self.level.pathNodes[x][y]
		if obj then self.contents:addPathNode(obj) end
	end
end


return T
