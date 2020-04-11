local BaseUI = require("ui.base")
local LHS = require("levelhead.lhs")

local UI = Class(BaseUI)

function UI:initialize(w,h,level)
	UI.super.initialize(self,w,h)
	self.title = "World Viewer"
	
	if type(level)=="table" then
		self:setLevel(level)
	elseif type(level)=="string" then
		self:loadLevel(level)
	elseif level == nil then
		self:loadLevel()
	else
		error("Invalid level type: "..type(level).." "..tostring(level))
	end
	
	self:reload()
end

function UI:loadLevel(level)
	self.level = LHS:new(level)
end

function UI:setLevel(level)
	self.level = level
end

function UI:reload()
	local l = self.level
	l:readAll()
	self.world = l:parseAll()
end

function UI:getMouseTile()
	return math.ceil(self:getMouseX()/TILE_SIZE), math.ceil(self:getMouseY()/TILE_SIZE)
end

function UI:draw()
	--bg
	love.graphics.setColor(0,0.5,1,1)
	love.graphics.rectangle(
		"fill",
		0, 0,
		self.world.width*TILE_SIZE, self.world.height*TILE_SIZE
	)
	--objects
	for obj in self.world.allObjects:iterate() do
		obj:draw()
	end
	--hover
	local x,y = self:getMouseTile()
	love.graphics.setColor(1,1,1,0.5)
	love.graphics.rectangle(
		"fill",
		(x-1)*TILE_SIZE, (y-1)*TILE_SIZE,
		TILE_SIZE, TILE_SIZE
	)
end

function UI:keypressed(key, scancode, isrepeat)
	if key=="r" or key=="space" then
		self:loadLevel(self.level.fileName)
		self:reload()
	end
end

return UI
