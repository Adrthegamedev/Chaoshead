local BaseUI = require("ui.base")

local PAD = require("ui.structure.padding")
local DET_LEVEL = require("ui.details.level")

local UI = Class(BaseUI)

function UI:initialize()
	--self.level
	self.viewer = require("ui.worldEditor"):new(nil,self)
	self.detailsUI = require("ui.structure.tabs"):new()
	self:addTab(DET_LEVEL:new())
	self.rootUI = require("ui.structure.horDivide"):new(self.detailsUI, self.viewer)
	self.rootUI.parent = self
	self.detailsUI.tabHeight = settings.editor.details.tabHeight
	
	UI.super.initialize(self)
	self.title = "Level Editor"
end

function UI:addTab(tab)
	tab = PAD:new(tab, settings.editor.details.inset)
	self.detailsUI:addChild(tab)
	self.detailsUI:setActive(tab)
end

function UI:removeTab(tab)
	for child in self.detailsUI.children:iterate() do
		if child.child==tab then
			self.detailsUI:removeChild(child)
			break
		end
	end
end

function UI:reload()
	for v in self.detailsUI.children:iterate() do
		if v.reload then v:reload() end
	end
end

-- events

local relay = function(index)
	UI[index] = function(self, ...)
		self.rootUI[index](self.rootUI, ...)
	end
end

relay("update")

relay("draw")

function UI:focus(focus)
	if focus then self:reload() end
	self.rootUI:focus(focus)
end
relay("visible")
function UI:resize(w,h)
	self.width = w
	self.height = h
	self.rootUI:resize(w,h)
end

function UI:keypressed(key, scancode, isrepeat)
	if key=="r" then
		require("utils.levelUtils").reload()
		self:reload()
	elseif key=="s" and love.keyboard.isDown("lctrl") then
		require("utils.levelUtils").save()
	else
		self.rootUI:keypressed(key, scancode, isrepeat)
	end
end
relay("textinput")

relay("mousepressed")
relay("mousereleased")
relay("mousemoved")
relay("wheelmoved")



return UI
